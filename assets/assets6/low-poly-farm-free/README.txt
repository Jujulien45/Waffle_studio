Low Poly Farm Free
==================

20 low-poly farm props for an autumn vegetable patch, taken from Low Poly Farm (121 props, eight
crops at four stages, the farm's buildings and tools, and a playable farming season for Godot and
Unity): https://heyheythere.itch.io/low-poly-farm
One 2048x2048 texture atlas filtered with mipmaps, the occlusion baked into vertex colours,
real-world scale (1 unit = 1 metre).

What's in the zip
-----------------
glb/        one file per prop, with its animations (the best format for Godot, Blender, three.js)
fbx/        one file per prop, with its animations as takes (Unreal, Unity, most 3D apps)
obj/        one file per prop, still (any 3D app)
textures/   atlas.png, the one texture every prop uses, and the seamless textures it tiles from,
            for your own geometry
icons/      an icon per prop, 256x256 PNG with transparency
props.json  every prop: title, group, size, triangles, parts, animations and, for the produce,
            its crop's "game" numbers
blender/    every prop in one .blend, the atlas packed in
addons/     the Godot addon, low_poly_farm/: this folder is a Godot 4.3+ project that opens on
            its gallery (.gdignore keeps Godot out of the other folders)

Crops
-----
A planting is one prop covering a 2 m plot: crop_<crop>_sprout, _young, _grown and _ripe, and
crop_sown for any crop just sown. Set it on a plot's centre. A crop's numbers (days to ripen,
seed cost, price, its stages by name) are under "game" in props.json on its produce
(produce_carrot, produce_pumpkin). A plot's bed top is 6 cm above the ground.

Tools
-----
The hoe and the watering can are held props: the origin is the grip, the working end down and
forward, and `use` plays the work (the hoe chops, the can pours). The shipping bin's lid `open`s.

The grid
--------
Everything snaps to a 2 m grid, a tile's pivot at its cell's centre, its top at 0. Fronts face -Y
in Blender and +Z in Godot.

Godot 4.3 and later
-------------------
Copy addons/low_poly_farm/ into your project's addons/ folder. Each prop is a scene in props/:
drag it into your level and turn on grid snapping at 1 m. It has a box collider (StaticBody3D) on
each of its parts and, where it moves, an AnimationPlayer.
demo/gallery.tscn shows every prop: drag to turn, arrows to browse, A for all of them.
Low Poly Farm uses the same addon folder: it installs over this one, with the game.
The props use one material, props.tres: the atlas times the vertex colours, lit.

Other engines and apps
----------------------
Use fbx/, glb/ or obj/ with textures/atlas.png, filtered, with mipmaps, multiplied by the vertex
colours (the baked occlusion) in your material.

License: CC BY 4.0, see LICENSE.txt for the credit line. Made by heyheythere:
https://heyheythere.itch.io
