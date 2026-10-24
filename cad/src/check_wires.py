# Wire-routing check: voxelise the free space inside the closed robot (shell + chassis + all parts as
# obstacles), inflate obstacles so a ~3 mm wire bundle fits, then check every wire run is connected.
import sys, os; sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import robot as R, cadquery as cq, numpy as np, trimesh, tempfile, os
from scipy import ndimage
def mesh(s):
    f = tempfile.mktemp(suffix='.stl'); cq.exporters.export(s, f, tolerance=0.1); m = trimesh.load(f); os.remove(f); return m
obs = [mesh(R.make_chassis()), mesh(R.make_shell())]
parts = R.make_parts()
skip = {'tires'}
for k,(s,_) in parts.items():
    if k not in skip: obs.append(mesh(s))
# motor caps in place
cap = R.make_motor_cap()
obs.append(mesh(cap.translate((0, R.AXLE_Y, R.CAP_Z))))
obs.append(mesh(cap.mirror("YZ").translate((0, R.AXLE_Y, R.CAP_Z))))
res = 1.0
xs = np.arange(-46, 46, res)+res/2; ys = xs.copy(); zs = np.arange(R.Z0, 80, res)+res/2
G = np.stack(np.meshgrid(xs, ys, zs, indexing='ij'), -1).reshape(-1, 3)
occ = np.zeros((len(xs), len(ys), len(zs)), bool)
for n_, m in enumerate(obs):
    P = np.vstack([trimesh.sample.sample_surface(m, int(m.area * 12))[0], m.vertices])   # dense surface samples
    ii = np.floor((P[:,0]+46)/res).astype(int); jj = np.floor((P[:,1]+46)/res).astype(int); kk = np.floor((P[:,2]-R.Z0)/res).astype(int)
    ok = (ii>=0)&(ii<len(xs))&(jj>=0)&(jj<len(ys))&(kk>=0)&(kk<len(zs))
    occ[ii[ok], jj[ok], kk[ok]] = True
    print('obs', n_, len(P), flush=True)
occ = occ.reshape(-1)
# inside the shell cavity? points outside the rounded outer envelope are not free
inside = (np.abs(G[:,0]) < R.W/2-R.WALL-0.2) & (np.abs(G[:,1]) < R.D/2-R.WALL-0.2)
occ |= ~inside
occ = occ.reshape(len(xs), len(ys), len(zs))
def free_for(d):  # d = bundle diameter in mm
    r = int(np.ceil(d/2/res)); st = ndimage.generate_binary_structure(3,1)
    return ~ndimage.binary_dilation(occ, st, iterations=r) if r else ~occ
def idx(p): return tuple(int(np.argmin(np.abs(a-v))) for a,v in zip((xs,ys,zs),p))
def near_free(free, p, rad=4):
    i = np.array(idx(p)); best=None
    for dx in range(-rad,rad+1):
        for dy in range(-rad,rad+1):
            for dz in range(-rad,rad+1):
                j = tuple(np.clip(i+[dx,dy,dz],0,np.array(free.shape)-1))
                if free[j]:
                    dd=dx*dx+dy*dy+dz*dz
                    if best is None or dd<best[0]: best=(dd,j)
    return best and best[1]
deck = (-10, -25, R.DECK_Z + 12)          # above the Nano header pins
runs = {
 'moteur G -> driver':        ((-4, R.AXLE_Y, R.AXLE_Z), (21, -24, R.SPLIT_Z+5)),
 'moteur D -> driver':        ((4,  R.AXLE_Y, R.AXLE_Z), (21, -24, R.SPLIT_Z+5)),
 'driver -> Nano':            ((21, -24, R.SPLIT_Z+5), deck),
 'chargeur -> Nano/A0':       ((-21, -30, R.SPLIT_Z+5), deck),
 'batterie -> chargeur':      ((-R.BATT[0]/2-2.5, -20, R.BATT_SHELF_Z+4), (-21, -30, R.SPLIT_Z+5)),
 'MT3608 -> Nano VIN':        ((10, 33, R.CLIFF_SHELF_Z+6), deck),
 'MT3608 -> driver':          ((10, 33, R.CLIFF_SHELF_Z+6), (21, -24, R.SPLIT_Z+5)),
 'chargeur -> interrupteur':  ((-21, -30, R.SPLIT_Z+5), (22, -25, 47)),
 'anti-chute G -> Nano':      ((-4, 33, R.CLIFF_SHELF_Z-5), deck),
 'anti-chute D -> Nano':      ((4, 33, R.CLIFF_SHELF_Z-5), deck),
 'buzzer -> Nano':            ((17, 13, R.DECK_Z+8), deck),
 'écran -> Nano':             ((0, 30, R.SCREEN_Z), deck),
 'caresse -> Nano':           ((0, -2, 66), deck),
}
for d in (2.0, 3.0, 4.0):
    free = free_for(d); lab, n = ndimage.label(free)
    print(f'--- faisceau de {d} mm ---')
    for name,(a,b) in runs.items():
        ia, ib = near_free(free,a), near_free(free,b)
        ok = ia is not None and ib is not None and lab[ia]==lab[ib] and lab[ia]>0
        print(f'{name:28s} {"OK" if ok else "BLOQUÉ"}' + ('' if ia and ib else f'  (extrémité sans place: {"a" if not ia else "b"})'))
