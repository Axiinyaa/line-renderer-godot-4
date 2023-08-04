# Line Renderer
A GDScript implementation of a line renderer in Godot, useful for rendering cylindrical volume such as lasers, trails, etc. Based on the helpful C# implementation by @paulohyy at https://github.com/paulohyy/linerenderer, with some additional features such as UV tiling and a .tscn file for ease of use.

## Instructions
1. Simply download and unzip the folder, the `LineRenderer` subfolder can be copied directly into the Godot project.
2. Drag and drop the `LineRenderer.tscn` scene into the project, press the update button, and you should see a line!

To edit the line's points, simply edit the `points` member variable of the line renderer, and add/remove points from the array. This can also be done via the editor in Godot.

## Features
- **Start thickness/end thickness**: how thick to make the line, which will be interpolated between each segment.
- **Corner smooth/cap smooth**: how much smoothing to apply to the line's corners/caps. Generally, values around 5 work well. A value of 2 results in pointed corners/caps.
- **Draw caps/corners**: Enables/disables drawing caps or corners separately.
- **Global coords**: If enabled, the line's points are assumed to be global coordinates, which are independent of the line's transform or its parent. To have the line move/rotate with either itself or its parent, uncheck this so that the points are local.
- **Scale texture**: Checking this box tiles the texture, automatically repeating in the line's axial direction. Unchecking this box stretches the texture instead along the line's segments.

## Limitations
- Since this effectively uses camera-facing billboards, as with most billboards, certain angles can break the illusion of cylindrical volume.
- Corners and caps currently have suboptimal UV mapping, but textures formed in the shape of a line should generally work well.
- Texture scaling doesn't connect neatly to each segment at the moment; however, this is not very noticable in most cases.
- Line doesn't update position or parameters in editor due to performance reasons, however, pressing the Update button in the line renderer will allow you to preview your changes.

## License
MIT License (credit to @paulohyy for initial implementation)

## Example Code
```gdscript
@export var line: LineRenderer3D
@export var target_position: Vector3

func _process(delta):
  line.points = [global_position, target_position]
```
This will draw a line between the origin of the object and the target destination every frame.
