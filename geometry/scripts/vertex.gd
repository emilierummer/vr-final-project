class_name Vertex extends Node3D

## Emitted every time the vertex is moved by the controller
signal vertex_moved

## Tracks which controller is holding the vertex
var held_by: XRNode3D = null

## Every frame, if the vertex is being held, move it to the controller's position
func _process(delta: float) -> void:
	if held_by:
		var new_position = held_by.global_position
		if new_position != global_position:
			global_position = new_position
			vertex_moved.emit()
