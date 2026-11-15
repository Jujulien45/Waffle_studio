Low-Poly Animals Free
=====================
5 low-poly props: a rabbit and a hen, each rigged with ten clips (idle, walk, run,
eat, lie_down, sleep, stand_up, attack, hit, death), a grass tile, a rail fence and
a pine tree. Made and licensed by heyheythere.

GLB and FBX carry the clips; OBJ is static; the .blend source, colour atlas, PNG
icons and props.json are included. This folder is a Godot 4.3+ project with a
gallery. Copy addons/low_poly_animals/ into your project; the full pack replaces it
in the same folder.

Metre scale. In Blender, +Z is up and everything faces -Y; in Godot, +Y is up and
it faces +Z. Each animal is one skinned mesh on a skeleton; its walk and run play
in place. The grass tile is 12 x 12 m, origin at the centre, surface at 0 m; the
fence is 3 m long along X.

animal.gd is the full pack's behaviour, ready to put on an animal's scene: it
wanders round a home, eats, lies down to sleep, gets up and runs from a threat.
Props use box colliders.
