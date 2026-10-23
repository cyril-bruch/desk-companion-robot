"""
Desk Companion Robot — parametric CAD (CadQuery)  — v0 (design preview)

Axes: X = width (right +), Y = depth (front +), Z = up. Ground at Z = 0.
All dimensions in mm. Component dimensions come from docs/bom.md.

Run:  python robot.py      -> writes ../stl/*.stl and ../preview/robot.glb
"""
from pathlib import Path
import cadquery as cq

OUT = Path(__file__).resolve().parent.parent

# ---------------------------------------------------------------- parameters
# Body
W, D, H = 80.0, 80.0, 72.0      # outer width, depth, height of the body
Z0 = 5.0                         # body bottom (ground clearance)
R_V, R_TOP, R_BOT = 18.0, 14.0, 3.0   # fillets: vertical edges, top edges, bottom edges
WALL = 2.0
FLOOR = 2.0
TOL = 0.3                        # print clearance

# Components (from BOM)
WHEEL_D, WHEEL_W = 32.0, 7.0                     # Pololu #1087
MOTOR_L, MOTOR_W, MOTOR_H = 24.0, 12.0, 10.0     # GA12-N20 body (gearbox + motor)
SHAFT_L = 10.0
NANO = (18.0, 45.0, 1.6)                          # Nano R4 (X, Y, thickness) – lies along Y
OLED_PCB = (35.5, 33.7)                           # SH1106 module (W, H)
OLED_ACTIVE = (29.4, 14.7)
BATT = (40.0, 30.0, 7.8)                          # LiPo 803040
TP4056 = (17.0, 28.0, 5.0)                        # charger (X, Y, Z) – USB-C toward the rear
BOOST = (11.0, 18.0, 4.0)
DRV = (10.2, 17.8, 3.0)                           # DRV8835
QTR = (7.6, 12.7, 1.6)                            # QTR-1A
TTP = (15.0, 11.0, 1.6)                           # TTP223
CASTER_H = 10.2                                    # Pololu #951 height

# Derived positions
AXLE_Z = WHEEL_D / 2                               # 16
MOTOR_X0 = 2.0                                     # inner end of each motor (from centre)
MOTOR_X1 = MOTOR_X0 + MOTOR_L                      # 26 – gearbox face
WHEEL_X0 = MOTOR_X1 + 3.0                          # 29 – inner face of wheel
WHEEL_X1 = WHEEL_X0 + WHEEL_W                      # 36 – outer face (body is at 40)
WELL_X0 = MOTOR_X1 + 1.5                           # wheel-well inner wall face
WELL_Y = WHEEL_D / 2 + 3.0                         # wheel well half-length
WELL_Z = AXLE_Z + WHEEL_D / 2 + 3.0                # wheel well top
Z_TOP = Z0 + H
SPLIT_Z = Z0 + FLOOR                               # shell sits on the floor plate
SCREEN_Z = Z0 + 44.0                               # screen centre height
DECK_Z = 31.0                                      # Nano deck (top of plate)
FACE_W, FACE_H, FACE_R = 40.0, 26.0, 8.0           # dark face plate (separate print)


def rounded_block(w, d, h, z, rv, rtop, rbot):
    b = cq.Workplane("XY").box(w, d, h, centered=(True, True, False)).translate((0, 0, z))
    b = b.edges("|Z").fillet(rv)
    if rtop:
        b = b.faces(">Z").edges().fillet(rtop)
    if rbot:
        b = b.faces("<Z").edges().fillet(rbot)
    return b


def box(x, y, z, cx, cy, z0):
    return cq.Workplane("XY").box(x, y, z, centered=(True, True, False)).translate((cx, cy, z0))


# ---------------------------------------------------------------- shell (top cover)
def make_shell():
    outer = rounded_block(W, D, H - FLOOR, SPLIT_Z, R_V, R_TOP, 0)
    shell = outer.faces("<Z").shell(-WALL)

    # ears
    for sx in (-1, 1):
        ear = (cq.Workplane("XY").circle(9.5).extrude(14)
               .faces(">Z").edges().fillet(7.5)
               .rotate((0, 0, 0), (0, 1, 0), sx * 22)
               .translate((sx * 22, -2, Z_TOP - 9)))
        shell = shell.union(ear)

    # face opening: receives the separate dark face plate
    face = (cq.Workplane("XZ").center(0, SCREEN_Z).rect(FACE_W, FACE_H).extrude(12)
            .edges("|Y").fillet(FACE_R).translate((0, D / 2 + 4, 0)))
    shell = shell.cut(face)

    # wheel wells
    for sx in (-1, 1):
        cx = sx * (WELL_X0 + W / 2) / 2 + sx * 1
        shell = shell.cut(box(W / 2 - WELL_X0 + 2, 2 * WELL_Y, WELL_Z, cx, 0, 0)
                          .edges("|X").fillet(4))

    # rear openings: charge USB-C (low) + programming USB-C (Nano) + switch
    shell = shell.cut(box(10.0, 10, 4.5, -12, -D / 2, 19.5).edges("|Y").fillet(1.5))   # charge port
    shell = shell.cut(box(10.0, 10, 4.5, 0, -D / 2, DECK_Z + 0.5).edges("|Y").fillet(1.5))  # Nano port
    shell = shell.cut(box(9.0, 10, 4.2, 14, -D / 2, 20.0))                               # slide switch

    # "pet me" dimple on top
    dimple = cq.Workplane("XY").sphere(30).translate((0, 0, Z_TOP + 30 - 1.2))
    shell = shell.cut(dimple)

    # inner ribs to hold the OLED (two slots) – simple L rails
    for sx in (-1, 1):
        rail = box(3, 4, OLED_PCB[1] + 4, sx * (OLED_PCB[0] / 2 + 2.0), D / 2 - WALL - 5.0, SCREEN_Z - OLED_PCB[1] / 2 - 6)
        shell = shell.union(rail)
    # screw bosses (4) at the corners, M2 self-tapping from below
    for sx in (-1, 1):
        for sy in (-1, 1):
            boss = (cq.Workplane("XY").circle(3.2).circle(0.9).extrude(10)
                    .translate((sx * (W / 2 - 9), sy * (D / 2 - 9), SPLIT_Z)))
            shell = shell.union(boss)
    return shell


# ---------------------------------------------------------------- face plate (print in black)
def make_faceplate():
    y_out = D / 2
    plate = (cq.Workplane("XZ").center(0, SCREEN_Z).rect(FACE_W - 2 * TOL, FACE_H - 2 * TOL).extrude(WALL)
             .edges("|Y").fillet(FACE_R - TOL).translate((0, y_out, 0)))
    lip = (cq.Workplane("XZ").center(0, SCREEN_Z).rect(FACE_W + 4, FACE_H + 4).extrude(1.2)
           .edges("|Y").fillet(FACE_R + 2).translate((0, y_out - WALL, 0)))
    plate = plate.union(lip)
    win = (cq.Workplane("XZ").center(0, SCREEN_Z).rect(OLED_ACTIVE[0] + 1.0, OLED_ACTIVE[1] + 1.0)
           .extrude(10).edges("|Y").fillet(1.5).translate((0, y_out + 2, 0)))
    return plate.cut(win)


# ---------------------------------------------------------------- chassis (floor plate + mounts)
def make_chassis():
    floor = rounded_block(W, D, FLOOR, Z0, R_V, 0, 1.0)

    # wheel wells through the floor
    for sx in (-1, 1):
        cx = sx * (WELL_X0 + W / 2) / 2 + sx * 1
        floor = floor.cut(box(W / 2 - WELL_X0 + 2, 2 * WELL_Y, 20, cx, 0, 0))

    # fender walls (hide wheels from the inside, carry the shaft hole)
    for sx in (-1, 1):
        fx = sx * (WELL_X0 - 0.75)
        fender = box(1.5, 2 * WELL_Y + 3, WELL_Z - Z0, fx, 0, Z0)
        fender = fender.cut(cq.Workplane("YZ").circle(3.0).extrude(4).translate((fx - 2, 0, AXLE_Z)))
        floor = floor.union(fender)
        # roof of the well
        floor = floor.union(box(W / 2 - WELL_X0 - WALL - TOL, 2 * WELL_Y + 3, 1.5,
                                sx * (WELL_X0 + (W / 2 - WALL - TOL - WELL_X0) / 2), 0, WELL_Z - 1.5))

    # motor cradles: two U-clamps per motor
    for sx in (-1, 1):
        for x in (MOTOR_X0 + 5, MOTOR_X1 - 5):
            mz = AXLE_Z - MOTOR_H / 2                     # motor bottom
            u = box(4, MOTOR_W + 4, mz + MOTOR_H + 2 - (Z0 + FLOOR), sx * x, 0, Z0 + FLOOR)
            u = u.cut(box(5, MOTOR_W + TOL, MOTOR_H + 0.2, sx * x, 0, mz))
            floor = floor.union(u)

    # battery tray (rear) – low walls
    by = -D / 2 + WALL + 1.5 + BATT[1] / 2
    tray = box(BATT[0] + 4, BATT[1] + 4, 4, 0, by, Z0 + FLOOR)
    tray = tray.cut(box(BATT[0] + TOL * 2, BATT[1] + TOL * 2, 5, 0, by, Z0 + FLOOR))
    floor = floor.union(tray)

    # Nano deck on 4 posts (rear half, USB-C at the back wall)
    deck_y0, deck_y1 = -D / 2 + WALL + 0.5, 12.0
    deck = box(30, deck_y1 - deck_y0, 2, 0, (deck_y0 + deck_y1) / 2, DECK_Z - 2)
    floor = floor.union(deck)
    for sx in (-1, 1):
        for y in (deck_y0 + 4, deck_y1 - 4):
            floor = floor.union(box(4, 4, DECK_Z - 2 - (Z0 + FLOOR), sx * 13, y, Z0 + FLOOR))
    # TP4056 shelf (above battery, rear-left), port aligned with the charge opening
    floor = floor.union(box(TP4056[0] + 4, TP4056[1], 1.5, -12, -D / 2 + WALL + 0.5 + TP4056[1] / 2, 18.5 - 1.5 - 0.5))

    # cliff sensor bosses (front corners, hanging under the floor, face 3 mm above ground)
    for sx in (-1, 1):
        b = box(QTR[0] + 3, QTR[1] + 3, Z0 - 2.0, sx * 17, D / 2 - 14, 2.0)
        b = b.cut(box(QTR[0] + TOL, QTR[1] + TOL, Z0, sx * 17, D / 2 - 14, 3.0 - 1.6))
        floor = floor.union(b)

    # caster "hat" (rear centre): the caster is 10.2 tall, higher than the floor -> raised mount
    cy = -D / 2 + 13
    floor = floor.cut(box(16, 12, FLOOR + 1, 0, cy, Z0 - 0.5))
    hat = box(20, 16, CASTER_H + 2 - Z0, 0, cy, Z0).cut(box(16, 12, CASTER_H - Z0 + 0.01, 0, cy, Z0 - 0.01))
    hat = hat.cut(cq.Workplane("XY").pushPoints([(-6.73, cy), (6.73, cy)]).circle(1.1).extrude(5).translate((0, 0, CASTER_H - 1)))
    floor = floor.union(hat)
    # screw holes matching the shell bosses
    for sx in (-1, 1):
        for sy in (-1, 1):
            floor = floor.cut(cq.Workplane("XY").circle(1.1).extrude(10)
                              .translate((sx * (W / 2 - 9), sy * (D / 2 - 9), Z0 - 1)))
    return floor


# ---------------------------------------------------------------- non-printed parts (for the preview)
def make_parts():
    p = {}
    wheels = None
    for sx in (-1, 1):
        w = (cq.Workplane("YZ").circle(WHEEL_D / 2).circle(4).extrude(WHEEL_W)
             .translate((sx * WHEEL_X0 if sx > 0 else -WHEEL_X1, 0, AXLE_Z)))
        w = w.faces("<X or >X").edges().fillet(1.5) if False else w
        wheels = w if wheels is None else wheels.union(w)
    p["wheels"] = (wheels, (0.12, 0.12, 0.14))

    motors = None
    for sx in (-1, 1):
        m = box(MOTOR_L, MOTOR_W, MOTOR_H, sx * (MOTOR_X0 + MOTOR_L / 2), 0, AXLE_Z - MOTOR_H / 2)
        s = cq.Workplane("YZ").circle(1.5).extrude(SHAFT_L).translate((MOTOR_X1 if sx > 0 else -MOTOR_X1 - SHAFT_L, 0, AXLE_Z))
        m = m.union(s)
        motors = m if motors is None else motors.union(m)
    p["motors"] = (motors, (0.72, 0.72, 0.76))

    by = -D / 2 + WALL + 1.5 + BATT[1] / 2
    p["battery"] = (box(*BATT, 0, by, Z0 + FLOOR + 0.2), (0.85, 0.75, 0.25))
    p["nano"] = (box(*NANO, 0, (-D / 2 + WALL + 0.5 + 12.0) / 2 - 2, DECK_Z), (0.0, 0.55, 0.6))
    p["charger"] = (box(*TP4056, -12, -D / 2 + WALL + 0.5 + TP4056[1] / 2, 18.5), (0.15, 0.3, 0.75))
    p["boost"] = (box(*BOOST, 14, 22, Z0 + FLOOR), (0.15, 0.3, 0.75))
    p["driver"] = (box(*DRV, -14, 22, Z0 + FLOOR), (0.1, 0.45, 0.2))
    cliff = None
    for sx in (-1, 1):
        q = box(*QTR, sx * 17, D / 2 - 14, 3.0 - 1.6)
        cliff = q if cliff is None else cliff.union(q)
    p["cliff_sensors"] = (cliff, (0.1, 0.45, 0.2))
    p["touch"] = (box(*TTP, 0, 0, Z_TOP - WALL - 1.2 - TTP[2] - 0.2), (0.75, 0.15, 0.15))
    caster = (cq.Workplane("XY").box(15, 11, CASTER_H - 4.5, centered=(True, True, False))
              .translate((0, -D / 2 + 13, 4.5))
              .union(cq.Workplane("XY").sphere(4.76).translate((0, -D / 2 + 13, 4.76))))
    p["caster"] = (caster, (0.55, 0.55, 0.6))

    # OLED module + glass + eyes
    oy = D / 2 - WALL - 2.6
    pcb = cq.Workplane("XZ").center(0, SCREEN_Z).rect(*OLED_PCB).extrude(1.6).translate((0, oy - 2.2, 0))
    p["oled_pcb"] = (pcb, (0.1, 0.25, 0.6))
    glass = cq.Workplane("XZ").center(0, SCREEN_Z).rect(OLED_ACTIVE[0] + 4, OLED_ACTIVE[1] + 4).extrude(1.2).translate((0, oy - 0.2, 0))
    p["screen"] = (glass, (0.03, 0.03, 0.05))
    eyes = None
    for sx in (-1, 1):
        e = (cq.Workplane("XZ").center(sx * 7.5, SCREEN_Z).rect(7, 10).extrude(0.3)
             .edges("|Y").fillet(2.5).translate((0, oy + 0.15, 0)))
        eyes = e if eyes is None else eyes.union(e)
    p["eyes"] = (eyes, (0.75, 0.95, 1.0))
    return p


def build():
    shell, chassis, parts = make_shell(), make_chassis(), make_parts()
    faceplate = make_faceplate()
    (OUT / "stl").mkdir(exist_ok=True)
    (OUT / "preview").mkdir(exist_ok=True)
    cq.exporters.export(shell, str(OUT / "stl" / "shell.stl"), tolerance=0.05, angularTolerance=0.1)
    cq.exporters.export(chassis, str(OUT / "stl" / "chassis.stl"), tolerance=0.05, angularTolerance=0.1)
    cq.exporters.export(faceplate, str(OUT / "stl" / "faceplate.stl"), tolerance=0.05, angularTolerance=0.1)

    assy = cq.Assembly(name="robot")
    assy.add(shell, name="shell", color=cq.Color(0.96, 0.93, 0.88))
    assy.add(chassis, name="chassis", color=cq.Color(0.98, 0.72, 0.68))
    assy.add(faceplate, name="faceplate", color=cq.Color(0.10, 0.10, 0.12))
    for n, (s, c) in parts.items():
        assy.add(s, name=n, color=cq.Color(*c))
    assy.save(str(OUT / "preview" / "robot.glb"))
    return shell, chassis, parts


if __name__ == "__main__":
    s, c, _ = build()
    bb = s.val().BoundingBox()
    print("shell bbox", round(bb.xlen, 1), round(bb.ylen, 1), round(bb.zmax, 1))
    print("shell volume cm3", round(s.val().Volume() / 1000, 1), "chassis", round(c.val().Volume() / 1000, 1))
