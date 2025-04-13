class_name Vertex extends Draggable

signal vertex_moved

func move(pos: Vector3) -> void:
	global_position = pos
	vertex_moved.emit()

func move_axis(axis: String, pos: float) -> void:
	global_position[axis] = pos
	vertex_moved.emit()

## Overrides Draggable's process method
func _process(_delta: float) -> void:
	if held_by:
		move(held_by.global_position - grab_offset)
