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
		var distance_to_start = abs(new_position - geometry.start_vertex.global_position)
		var distance_to_end   = abs(new_position - geometry.end_vertex.global_position)
		if controls == "x" or controls == "-x":
			if distance_to_start.x < distance_to_end.x:
				geometry.start_vertex.global_position.x = new_position.x
			else: 
				geometry.end_vertex.global_position.x = new_position.x
		elif controls == "y" or controls == "-y":
			if distance_to_start.y < distance_to_end.y:
				geometry.start_vertex.global_position.y = new_position.y
			else: 
				geometry.end_vertex.global_position.y = new_position.y
		elif controls == "z" or controls == "-z":
			if distance_to_start.z < distance_to_end.z:
				geometry.start_vertex.global_position.z = new_position.z
			else: 
				geometry.end_vertex.global_position.z = new_position.z
		face_moved.emit()

func update_geometry(min_pos: Vector3, max_pos: Vector3, size: Vector3) -> void:
	match controls:
		"x" : 
			global_position = Vector3(max_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.x = size.z
			%Collider.shape.size.y = size.y
		"-x": 
			global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.y = size.y
			%Collider.shape.size.x = size.z
		"y" : 
			global_position = Vector3(min_pos.x, max_pos.y, min_pos.z)
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.z
		"-y": 
			global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.z
		"z" : 
			global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.y
		"-z": 
			global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.y
	%Collider.position = Vector3(%Collider.shape.size.x / 2, %Collider.shape.size.y / 2, 0)
