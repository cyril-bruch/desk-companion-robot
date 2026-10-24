"""
Desk Companion Robot — parametric CAD (CadQuery) — v1

Axes: X = width (right +), Y = depth (front +), Z = up. Ground at Z = 0. Units: mm.
Component dimensions: docs/bom.md (AliExpress version). Where the seller does not
publish a dimension, a typical value for that kind of board is used and the bay is
oversized ("vise large"): small boards are held with double-sided tape.

Run:  python robot.py      -> ../stl/*.stl  and  ../preview/robot.glb
"""
from pathlib import Path
import cadquery as cq

OUT = Path(__file__).resolve().parent.parent

# ============================================================== parameters
# --- body
W, D, H = 86.0, 92.0, 76.0        # outer width, depth, height
Z0 = 5.0                           # underside of the floor (ground clearance)
FLOOR = 2.4
WALL = 2.2
R_V, R_TOP = 19.0, 15.0            # fillets: vertical edges, top edges
TOL = 0.5                          # generous print clearance
SPLIT_Z = Z0 + FLOOR               # top of floor = bottom of the shell
Z_TOP = Z0 + H
IN_X, IN_Y = W / 2 - WALL, D / 2 - WALL      # inner wall faces

# --- parts (published dimensions unless noted)
MOTOR_L, MOTOR_W, MOTOR_H = 26.0, 12.0, 10.0  # N20, body length incl. gearbox
SHAFT_L = 10.0
TIRE_D = 30.6                      # printed rim (groove Ø26) + O-ring OD30 CS2.4
RIM_D, FLANGE_D, WHEEL_W = 26.0, 29.0, 8.0
OLED = (35.5, 33.5, 4.3)           # W, H, total thickness (PCB 1.6)
OLED_ACTIVE = (29.4, 14.7)
NANO = (18.0, 45.0, 1.6)
BATT = (40.0, 30.0, 8.0)           # 803040
TP4056 = (17.0, 28.0, 6.0)         # not published -> typical, bay oversized
DRV = (16.0, 18.5, 8.0)            # not published -> typical
MT3608 = (37.0, 17.5, 9.0)         # boost 7.5 V: L x W x height incl. trimmer (typical, oversized)
BUZZER = (12.0, 9.5)               # passive piezo buzzer: diameter, height (standard 12 mm part)
BUZZER_XY = (0.0, -11.0)
TCRT = (32.0, 14.0, 10.0)          # module L x W, height with components
TTP = (15.0, 11.0, 1.6)
CASTER_H, CASTER_FOOT = 15.0, 20.0 # published height; footprint not published
SWITCH = (8.5, 3.5, 3.5)

# --- layout
AXLE_Y = 6.0                       # wheels slightly in front of the centre
AXLE_Z = TIRE_D / 2
MOTOR_X0, MOTOR_X1 = 2.0, 2.0 + MOTOR_L          # 2 .. 28
WHEEL_X0, WHEEL_X1 = 30.5, 30.5 + WHEEL_W        # 30.5 .. 38.5 (body side at 43)
FENDER_X = 28.4                                   # fender wall inner face
WELL_HY = TIRE_D / 2 + 3.0                        # wheel-well half length
WELL_Z = AXLE_Z + TIRE_D / 2 + 3.0
CASTER_Y = -30.0
SCREEN_Z = Z0 + 50.0
FACE_W, FACE_H, FACE_R = 40.0, 26.0, 8.0
BATT_SHELF_Z = 19.5                # top of the battery shelf
DECK_Z = 35.0                      # top of the Nano deck (room to lift the battery in)
CLIFF_SHELF_Z = 19.5               # underside of the plates the cliff sensors hang from
BOSS = [(sx * 37.0, sy * 30.0) for sx in (-1, 1) for sy in (-1, 1)]
CRADLE_W = MOTOR_W + 8                             # motor cradle width (Y)
CAP_Z = AXLE_Z + MOTOR_H / 2 + 0.3                 # top of the cradles = underside of the cap
CAP_HOLE_DY = MOTOR_W / 2 + 2.0


# ============================================================== helpers
def box(x, y, z, cx, cy, z0):
    return cq.Workplane("XY").box(x, y, z, centered=(True, True, False)).translate((cx, cy, z0))


def bay(x, y, wall_h, cx, cy, z0, t=1.2):
    """Low open frame that locates a board (board is taped inside)."""
    return box(x + 2 * t, y + 2 * t, wall_h, cx, cy, z0).cut(box(x, y, wall_h + 1, cx, cy, z0 - 0.5))


def rounded_block(w, d, h, z, rv, rtop=0, rbot=0):
    b = box(w, d, h, 0, 0, z).edges("|Z").fillet(rv)
    if rtop:
        b = b.faces(">Z").edges().fillet(rtop)
    if rbot:
        b = b.faces("<Z").edges().fillet(rbot)
    return b


def front_xz(w, h, r, cz, depth, y_from):
    """Rounded rectangle in the XZ plane, cut/extruded toward -Y starting at y_from."""
    return (cq.Workplane("XZ").center(0, cz).rect(w, h).extrude(depth)
            .edges("|Y").fillet(r).translate((0, y_from, 0)))


CLIFF_X = (1.3, 33.3)              # each cliff module spans x = 1.3..33.3 (mirrored)
CLIFF_Y = (26.0, 40.0)


# ============================================================== shell
def make_shell():
    s = rounded_block(W, D, H - FLOOR, SPLIT_Z, R_V, R_TOP).faces("<Z").shell(-WALL)

    for sx in (-1, 1):                                  # ears
        ear = (cq.Workplane("XY").circle(10).extrude(15).faces(">Z").edges().fillet(8)
               .rotate((0, 0, 0), (0, 1, 0), sx * 22).translate((sx * 23, -4, Z_TOP - 9.5)))
        s = s.union(ear)

    s = s.cut(front_xz(FACE_W, FACE_H, FACE_R, SCREEN_Z, 14, D / 2 + 4))   # face opening

    for sx in (-1, 1):                                  # wheel wells
        s = s.cut(box(W / 2 - FENDER_X + 2, 2 * WELL_HY, WELL_Z, sx * (FENDER_X + W / 2 + 2) / 2, AXLE_Y, 0)
                  .edges("|X").fillet(4))

    # rear openings — oversized on purpose
    s = s.cut(box(13, 12, 8, -21.2, -D / 2, SPLIT_Z + 0.6).edges("|Y").fillet(2))    # charge USB-C
    s = s.cut(box(13, 12, 8, 0, -D / 2, DECK_Z - 0.5).edges("|Y").fillet(2))         # Nano USB-C
    s = s.cut(box(10, 12, 5, 18, -D / 2, SPLIT_Z + 1.0).edges("|Y").fillet(1))       # slide switch

    # "pet me" dimple + touch-sensor cage under it
    s = s.cut(cq.Workplane("XY").sphere(34).translate((0, -2, Z_TOP + 34 - 1.4)))
    cage = bay(TTP[0] + 2, TTP[1] + 2, 4, 0, -2, Z_TOP - WALL - 4)
    s = s.union(cage)

    # OLED pocket: side guides outside the PCB edge, back stops behind it, bottom ledge.
    # The face plate lip is the front stop (glass rests against it). PCB drops in from above.
    y_pcb_front = IN_Y - 1.2 - (OLED[2] - 1.6) - 0.3
    y_pcb_back = y_pcb_front - 1.6
    z_bot = SCREEN_Z - OLED[1] / 2 - TOL
    gx = OLED[0] / 2 + TOL                                    # guide inner face
    for sx in (-1, 1):
        guide = box(2.0, IN_Y - (y_pcb_back - TOL - 2.0), OLED[1] + 4, sx * (gx + 1.0),
                    (IN_Y + y_pcb_back - TOL - 2.0) / 2, z_bot)
        stop = box(4.0, 2.0, OLED[1] + 4, sx * (gx - 1.0), y_pcb_back - TOL - 1.0, z_bot)
        s = s.union(guide).union(stop)
    s = s.union(box(2 * gx + 4, IN_Y - (y_pcb_back - TOL - 2.0), 2.0, 0,
                    (IN_Y + y_pcb_back - TOL - 2.0) / 2, z_bot - 2.0)
                .cut(box(OLED_ACTIVE[0] + 6, 10, 6, 0, IN_Y - 1, z_bot - 3)))   # ledge (flex-cable notch)

    # keep the face-plate lip zone free (lip sits just behind the front wall)
    s = s.cut(front_xz(FACE_W + 4 + 2 * TOL, FACE_H + 4 + 2 * TOL, FACE_R + 2, SCREEN_Z, 1.2 + TOL, IN_Y + 0.001))

    for (bx, by) in BOSS:                               # screw bosses (M2 self-tapping)
        s = s.union(cq.Workplane("XY").circle(3.2).circle(0.85).extrude(12).translate((bx, by, SPLIT_Z)))
    return s


# ============================================================== face plate (print in black)
def make_faceplate():
    p = front_xz(FACE_W - 2 * 0.3, FACE_H - 2 * 0.3, FACE_R - 0.3, SCREEN_Z, WALL, D / 2)
    p = p.union(front_xz(FACE_W + 4, FACE_H + 4, FACE_R + 2, SCREEN_Z, 1.2, D / 2 - WALL))
    return p.cut(front_xz(OLED_ACTIVE[0] + 1.6, OLED_ACTIVE[1] + 1.6, 2, SCREEN_Z, 10, D / 2 + 2))


# ============================================================== wheel (print 4: 2 + 2 spares)
def make_wheel():
    w = cq.Workplane("YZ").circle(FLANGE_D / 2).extrude(WHEEL_W)
    for x0 in (1.0, 4.4):                               # two O-ring grooves, 2.6 wide
        groove = (cq.Workplane("YZ").circle(FLANGE_D / 2 + 1).circle(RIM_D / 2).extrude(2.6)
                  .translate((x0, 0, 0)))
        w = w.cut(groove)
    # D-shaft bore 3.2 / flat at 1.1 mm from the axis (N20: 3 mm, flat 2.5) - press fit
    bore = (cq.Workplane("YZ").circle(1.6).extrude(WHEEL_W + 2).translate((-1, 0, 0))
            .cut(box(WHEEL_W + 4, 4, 2, WHEEL_W / 2, 0, 1.1)))
    w = w.cut(bore)
    # lightening holes = cute "rims"
    for i in range(5):
        import math
        a = 2 * math.pi * i / 5
        w = w.cut(cq.Workplane("YZ").circle(2.3).extrude(WHEEL_W + 2)
                  .translate((-1, 7.2 * math.cos(a), 7.2 * math.sin(a))))
    return w   # local frame: x 0..WHEEL_W, axis on X


# ============================================================== motor cap (print 3: 2 + 1 spare)
def make_motor_cap():
    x0, x1 = MOTOR_X0 + 2, MOTOR_X1 - 2
    cap = box(x1 - x0, CRADLE_W, 2.0, (x0 + x1) / 2, 0, 0)
    cap = cap.union(box(x1 - x0 - 10, MOTOR_W - 2, 0.5, (x0 + x1) / 2, 0, -0.5))   # presses the motor (0.2 mm)
    for x in (MOTOR_X0 + 4, MOTOR_X1 - 4):
        for dy in (-CAP_HOLE_DY, CAP_HOLE_DY):
            cap = cap.cut(cq.Workplane("XY").circle(1.2).extrude(4).translate((x, dy, -1)))
    return cap   # local frame: right motor, y centred on the axle, z = 0 at the cradle tops


# ============================================================== chassis
def make_chassis():
    c = rounded_block(W, D, FLOOR, Z0, R_V, 0, 1.0)

    for sx in (-1, 1):
        # wheel well through the floor + fender wall with shaft hole + well roof
        c = c.cut(box(W / 2 - FENDER_X + 2, 2 * WELL_HY, 20, sx * (FENDER_X + W / 2 + 2) / 2, AXLE_Y, 0))
        fx = sx * (FENDER_X + 0.7)
        fender = box(1.4, 2 * WELL_HY, WELL_Z - Z0, fx, AXLE_Y, Z0)
        fender = fender.cut(cq.Workplane("YZ").circle(3.5).extrude(6).translate((fx - 3, AXLE_Y, AXLE_Z)))
        c = c.union(fender)
        c = c.union(box(IN_X - TOL - FENDER_X - 1.4, 2 * WELL_HY, 1.6,
                        sx * (FENDER_X + 1.4 + (IN_X - TOL - FENDER_X - 1.4) / 2), AXLE_Y, WELL_Z - 1.6))

        # motor cradles (2 per motor), open on top: the motor drops in, then a printed
        # cap is screwed on top (2 x M2 self-tapping per cradle)
        for x in (MOTOR_X0 + 4, MOTOR_X1 - 4):
            u = box(4, CRADLE_W, CAP_Z - SPLIT_Z, sx * x, AXLE_Y, SPLIT_Z)
            u = u.cut(box(5, MOTOR_W + TOL, 30, sx * x, AXLE_Y, AXLE_Z - MOTOR_H / 2))
            for dy in (-CAP_HOLE_DY, CAP_HOLE_DY):
                u = u.cut(cq.Workplane("XY").circle(0.8).extrude(7).translate((sx * x, AXLE_Y + dy, CAP_Z - 6.9)))
            c = c.union(u)

        # cliff sensor hanger: plate under which the TCRT5000 module is taped (components down)
        x0, x1 = CLIFF_X
        cx = sx * (x0 + x1) / 2
        px0, px1 = x0 - 1.0, x1 + 0.3
        plate = box(px1 - px0, CLIFF_Y[1] - CLIFF_Y[0] + 5, 1.8, sx * (px0 + px1) / 2, sum(CLIFF_Y) / 2, CLIFF_SHELF_Z)
        c = c.union(plate)
        for (px, py) in ((9.5, CLIFF_Y[0] - 1.5), (25.0, CLIFF_Y[0] - 1.5), (9.5, CLIFF_Y[1] + 1.5), (25.0, CLIFF_Y[1] + 1.5)):
            c = c.union(box(3, 3, CLIFF_SHELF_Z - SPLIT_Z, sx * px, py, SPLIT_Z))
        # light window under the sensor end (outer end), oversized
        c = c.cut(box(14, 16, 10, sx * (x1 - 6), sum(CLIFF_Y) / 2, Z0 - 1))

    # caster "hat" (rear centre): mounting face at CASTER_H above ground
    hat_in = CASTER_FOOT + 2
    c = c.cut(box(hat_in, hat_in, FLOOR + 2, 0, CASTER_Y, Z0 - 1))
    hat = box(hat_in + 2.4, hat_in + 2.4, CASTER_H + 2 - Z0, 0, CASTER_Y, Z0)
    hat = hat.cut(box(hat_in, hat_in, CASTER_H - Z0 + 0.01, 0, CASTER_Y, Z0 - 0.01))
    for ang in (0, 90):                                 # cross of M2 slots: fits most hole spacings
        slot = box(16, 2.4, 6, 0, 0, CASTER_H - 1).rotate((0, 0, 0), (0, 0, 1), ang).translate((0, CASTER_Y, 0))
        hat = hat.cut(slot)
    c = c.union(hat)

    # floor-level bays (boards taped inside)
    # charger: L-shaped stop (front + inner side), USB-C end free toward the rear opening
    CH_X, CH_Y0 = -21.2, -IN_Y + 1.5                  # board centre x, rear edge y
    c = c.union(box(TP4056[0] + 2, 1.2, 3, CH_X, CH_Y0 + TP4056[1] + TOL + 0.6, SPLIT_Z))
    c = c.union(box(1.2, TP4056[1] * 0.6, 3, CH_X + TP4056[0] / 2 + TOL + 0.6, CH_Y0 + TP4056[1] * 0.7, SPLIT_Z))
    c = c.union(bay(DRV[0] + 2, DRV[1] + 2, 3, 21.0, -21.6, SPLIT_Z))
    # buzzer: ring holder + sound grille in the floor (sound bounces off the desk: softer)
    bx, by = BUZZER_XY
    c = c.union(cq.Workplane("XY").circle(BUZZER[0] / 2 + TOL + 1.2).circle(BUZZER[0] / 2 + TOL).extrude(4)
                .translate((bx, by, SPLIT_Z)))
    import math
    for i in range(6):
        a = 2 * math.pi * i / 6
        c = c.cut(cq.Workplane("XY").circle(1.0).extrude(5).translate((bx + 3.2 * math.cos(a), by + 3.2 * math.sin(a), Z0 - 1)))
    c = c.cut(cq.Workplane("XY").circle(1.0).extrude(5).translate((bx, by, Z0 - 1)))
    # slide switch: two side blocks at the rear wall
    for dx in (-1, 1):
        c = c.union(box(2.0, 5.0, 5.0, 18 + dx * (SWITCH[0] / 2 + TOL + 1.0), -IN_Y + 3.0, SPLIT_Z))

    # battery shelf (above the caster hat), 3 posts + cantilever over the charger
    shelf_y0, shelf_y1 = -IN_Y + 0.8, -3.5
    c = c.union(box(46, shelf_y1 - shelf_y0, 1.8, 0, (shelf_y0 + shelf_y1) / 2, BATT_SHELF_Z - 1.8))
    c = c.union(bay(BATT[0] + 1.5, BATT[1] + 1.5, 3, 0, (shelf_y0 + shelf_y1) / 2, BATT_SHELF_Z))
    for (px, py) in ((22, -5), (-22, -5), (27, -36), (-9, -12)):
        c = c.union(box(3, 3, BATT_SHELF_Z - 1.8 - SPLIT_Z, px, py, SPLIT_Z))

    # Nano deck (posts stand on the battery shelf), USB-C at the rear wall
    deck_y0, deck_y1 = -IN_Y + 0.8, 3.0
    c = c.union(box(34, deck_y1 - deck_y0, 1.8, 0, (deck_y0 + deck_y1) / 2, DECK_Z - 1.8))
    c = c.union(bay(NANO[0] + 1.5, NANO[1] + 1.0, 2, 0, deck_y0 + (NANO[1] + 1.0) / 2 + 1.2, DECK_Z))
    for (px, py) in ((15.5, -6), (-15.5, -6), (15.5, deck_y0 + 2), (-15.5, deck_y0 + 2)):
        c = c.union(box(2.5, 2.5, DECK_Z - 1.8 - BATT_SHELF_Z, px, py, BATT_SHELF_Z))

    # wire passages
    for (hx, hy) in ((0, -1), (-12, 12), (12, 12)):
        c = c.cut(cq.Workplane("XY").circle(3).extrude(5).translate((hx, hy, Z0 - 1)))
    c = c.cut(box(8, 5, 4, 0, -6, BATT_SHELF_Z - 2.5))
    c = c.cut(box(8, 5, 4, 0, 0.5, DECK_Z - 2.5))

    # everything above the floor must stay inside the shell (with clearance)
    env = rounded_block(W - 2 * (WALL + TOL), D - 2 * (WALL + TOL), 200, SPLIT_Z - 0.01, R_V - WALL - TOL)
    env = env.union(rounded_block(W, D, FLOOR + 0.02, Z0 - 0.01, R_V))
    c = c.intersect(env)

    for (bx, by) in BOSS:                               # screw holes
        c = c.cut(cq.Workplane("XY").circle(1.1).extrude(10).translate((bx, by, Z0 - 1)))
        c = c.cut(cq.Workplane("XY").circle(2.0).extrude(1.2).translate((bx, by, Z0 - 0.01)))  # head recess
    return c


# ============================================================== non-printed parts (preview only)
def make_parts():
    p = {}
    def u(a, b):
        return b if a is None else a.union(b)

    mot = tires = None
    for sx in (-1, 1):
        mot = u(mot, box(MOTOR_L, MOTOR_W, MOTOR_H, sx * (MOTOR_X0 + MOTOR_L / 2), AXLE_Y, AXLE_Z - MOTOR_H / 2))
        mot = mot.union(cq.Workplane("YZ").circle(1.5).extrude(SHAFT_L)
                        .translate((MOTOR_X1 if sx > 0 else -MOTOR_X1 - SHAFT_L, AXLE_Y, AXLE_Z)))
        for x0 in (1.0, 4.4):
            xs = (WHEEL_X0 + x0) if sx > 0 else -(WHEEL_X0 + x0 + 2.6)
            tires = u(tires, cq.Workplane("YZ").circle(TIRE_D / 2).circle(RIM_D / 2).extrude(2.6)
                      .translate((xs, AXLE_Y, AXLE_Z)))
    p["motors"] = (mot, (0.72, 0.72, 0.76))
    p["tires"] = (tires, (0.12, 0.12, 0.14))

    sy0 = -IN_Y + 0.8
    p["battery"] = (box(*BATT, 0, (sy0 - 3.5) / 2, BATT_SHELF_Z + 0.2), (0.85, 0.75, 0.25))
    p["nano"] = (box(*NANO, 0, sy0 + NANO[1] / 2 + 1.7, DECK_Z + 0.2), (0.0, 0.55, 0.6))
    p["charger"] = (box(TP4056[0], TP4056[1], 1.6, -21.2, -IN_Y + 1.5 + TP4056[1] / 2, SPLIT_Z + 0.2)
                    .union(box(9, 7.5, 3.2, -21.2, -IN_Y + 1.5 + 3.0, SPLIT_Z + 1.8)), (0.15, 0.3, 0.75))
    p["driver"] = (box(DRV[0], DRV[1], 1.6, 21.0, -21.6, SPLIT_Z + 0.2), (0.12, 0.12, 0.14))
    # MT3608 taped on top of the two front sensor plates (spans both)
    mt = box(MT3608[0], MT3608[1], 1.6, 0, 33.0, CLIFF_SHELF_Z + 1.8 + 0.2)
    mt = mt.union(box(9.5, 4.5, MT3608[2] - 1.6, -9, 33.0 + 4, CLIFF_SHELF_Z + 1.8 + 1.8))   # trimmer
    p["boost"] = (mt, (0.15, 0.3, 0.75))
    p["buzzer"] = (cq.Workplane("XY").circle(BUZZER[0] / 2).extrude(BUZZER[1]).translate((*BUZZER_XY, SPLIT_Z + 0.2)),
                   (0.12, 0.12, 0.14))
    p["switch"] = (box(SWITCH[0], SWITCH[1], SWITCH[2], 18, -IN_Y + 2.5, SPLIT_Z + 1)
                   .union(box(2, 3, 2, 18.5, -IN_Y - 0.5, SPLIT_Z + 1.8)), (0.25, 0.25, 0.28))
    cliff = None
    for sx in (-1, 1):
        x0, x1 = CLIFF_X
        pcb = box(TCRT[0], TCRT[1], 1.6, sx * (x0 + x1) / 2, sum(CLIFF_Y) / 2, CLIFF_SHELF_Z - 1.6)
        eye = box(10, 6, 7.5, sx * (x1 - 6), sum(CLIFF_Y) / 2, CLIFF_SHELF_Z - 1.6 - 7.5)
        cliff = u(cliff, pcb.union(eye))
    p["cliff_sensors"] = (cliff, (0.1, 0.45, 0.2))
    p["touch"] = (box(*TTP, 0, -2, Z_TOP - WALL - 1.4 - TTP[2] - 0.3), (0.75, 0.15, 0.15))
    p["caster"] = (box(CASTER_FOOT, CASTER_FOOT, CASTER_H - 9, 0, CASTER_Y, 9)
                   .union(cq.Workplane("XY").sphere(6).translate((0, CASTER_Y, 6))), (0.55, 0.55, 0.6))

    y_pcb_front = IN_Y - 1.2 - (OLED[2] - 1.6) - 0.3
    p["oled_pcb"] = (front_xz(OLED[0], OLED[1], 0.5, SCREEN_Z, 1.6, y_pcb_front), (0.1, 0.25, 0.6))
    p["screen"] = (front_xz(OLED_ACTIVE[0] + 4, OLED_ACTIVE[1] + 5, 0.5, SCREEN_Z, OLED[2] - 1.6, y_pcb_front + OLED[2] - 1.6),
                   (0.03, 0.03, 0.05))
    eyes = None
    for sx in (-1, 1):
        eyes = u(eyes, (cq.Workplane("XZ").center(sx * 7.5, SCREEN_Z).rect(7, 10).extrude(0.3)
                        .edges("|Y").fillet(2.5).translate((0, y_pcb_front + OLED[2] - 1.6 + 0.3, 0))))
    p["eyes"] = (eyes, (0.75, 0.95, 1.0))
    return p


def build():
    shell, chassis, face, wheel = make_shell(), make_chassis(), make_faceplate(), make_wheel()
    cap = make_motor_cap()
    parts = make_parts()
    (OUT / "stl").mkdir(exist_ok=True)
    (OUT / "preview").mkdir(exist_ok=True)
    for name, solid in (("shell", shell), ("chassis", chassis), ("faceplate", face), ("wheel", wheel), ("motor_cap", cap)):
        cq.exporters.export(solid, str(OUT / "stl" / f"{name}.stl"), tolerance=0.04, angularTolerance=0.1)

    assy = cq.Assembly(name="robot")
    assy.add(shell, name="shell", color=cq.Color(0.96, 0.93, 0.88))
    assy.add(chassis, name="chassis", color=cq.Color(0.98, 0.72, 0.68))
    assy.add(face, name="faceplate", color=cq.Color(0.10, 0.10, 0.12))
    for sx in (-1, 1):
        wloc = wheel.translate((WHEEL_X0, AXLE_Y, AXLE_Z)) if sx > 0 else \
            wheel.mirror("YZ").translate((-WHEEL_X0, AXLE_Y, AXLE_Z))
        assy.add(wloc, name=f"wheel_{'r' if sx > 0 else 'l'}", color=cq.Color(0.98, 0.72, 0.68))
    for sx in (-1, 1):
        cl = cap.translate((0, AXLE_Y, CAP_Z)) if sx > 0 else cap.mirror("YZ").translate((0, AXLE_Y, CAP_Z))
        assy.add(cl, name=f"motor_cap_{'r' if sx > 0 else 'l'}", color=cq.Color(0.98, 0.72, 0.68))
    for n, (s, col) in parts.items():
        assy.add(s, name=n, color=cq.Color(*col))
    assy.save(str(OUT / "preview" / "robot.glb"))
    return shell, chassis, face, wheel, parts


if __name__ == "__main__":
    s, c, f, w, parts = build()
    bb = s.val().BoundingBox()
    print("shell bbox", round(bb.xlen, 1), round(bb.ylen, 1), round(bb.zmax, 1))
    vol = {n: round(x.val().Volume() / 1000, 1) for n, x in (("shell", s), ("chassis", c), ("face", f), ("wheel", w))}
    print("volumes cm3", vol)
    # interference check between the printed parts and the purchased parts
    printed = {"shell": s, "chassis": c}
    for pn, ps in printed.items():
        for n, (part, _) in parts.items():
            try:
                v = ps.intersect(part).val().Volume()
            except Exception:
                v = 0
            if v > 1.0:
                print(f"  CLASH {pn} x {n}: {v:.1f} mm3")
