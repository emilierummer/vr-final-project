class_name Face extends Area3D

@export_enum("x", "-x", "y", "-y", "z", "-z") var controls: String
@export var geometry: Geometry

## Emitted every time the face is moved by the controller
signal face_moved

## Tracks which controller is holding the face
var held_by: XRNode3D = null

## Every frame, if the face is being held, move it to the controller's position
func _process(_delta: float) -> void:
	if held_by:
		DebugConsole.log("============")
		var new_position = held_by.global_position
		DebugConsole.log("Moving face " + controls + " to")
		DebugConsole.log(new_position)
		match controls:
			"x" : geometry.end_vertex.global_position.x   = new_position.x
			"-x": geometry.start_vertex.global_position.x = new_position.x
			"y" : geometry.end_vertex.global_position.y   = new_position.y
			"-y": geometry.start_vertex.global_position.y = new_position.y
			"z" : geometry.end_vertex.global_position.z   = new_position.z
			"-z": geometry.start_vertex.global_position.z = new_position.z
		geometry._on_box_size_change()

func update_geometry() -> void:
	var min_pos = geometry.start_vertex.global_position.min(geometry.end_vertex.global_position)
	var max_pos = geometry.start_vertex.global_position.max(geometry.end_vertex.global_position)
	match controls:
		"x" : 
			global_position = Vector3(max_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.x = geometry.size.z
			%Collider.shape.size.y = geometry.size.y
		"-x": 
			global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.y = geometry.size.y
			%Collider.shape.size.x = geometry.size.z
		"y" : 
			global_position = Vector3(min_pos.x, max_pos.y, min_pos.z)
			%Collider.shape.size.x = geometry.size.x
			%Collider.shape.size.y = geometry.size.z
		"-y": 
			global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
			%Collider.shape.size.x = geometry.size.x
			%Collider.shape.size.y = geometry.size.z
		"z" : 
			global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.x = geometry.size.x
			%Collider.shape.size.y = geometry.size.y
		"-z": 
			global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
			%Collider.shape.size.x = geometry.size.x
			%Collider.shape.size.y = geometry.size.y
	%Collider.position = Vector3(%Collider.shape.size.x / 2, %Collider.shape.size.y / 2, 0)
