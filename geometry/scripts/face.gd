class_name Face extends Area3D

@export_enum("x", "-x", "y", "-y", "z", "-z") var controls: String
@export var geometry: Geometry

## Emitted every time the face is moved by the controller
signal face_moved

## Emitted if the axis of a face need to switch
signal flip_axis(axis: String)

## Tracks which controller is holding the face
var held_by: XRNode3D = null

## Gets the controller's colliders for hover detection
@onready var controller_colliders = get_tree().get_nodes_in_group("ControllerColliders")

## Every frame, if the face is being held, move it to the controller's position
func _process(_delta: float) -> void:
	# Check if the face is being hovered
	var overlapping_controllers = get_overlapping_areas().filter(func filter(item): return controller_colliders.has(item))
	#TODO: hovered = overlapping_controllers.size() > 0
	# Move the face if it's being held
	if held_by:
		var new_position = held_by.global_position
		# Move face
		var control_vertex = geometry.start_vertex if controls.contains("-") else geometry.end_vertex
		var control_axis = controls[-1]
		control_vertex.global_position[control_axis] = new_position[control_axis]
		# Check if the axis should swap
		if geometry.start_vertex.global_position.x > geometry.end_vertex.global_position.x: flip_axis.emit("x")
		if geometry.start_vertex.global_position.y > geometry.end_vertex.global_position.y: flip_axis.emit("y")
		if geometry.start_vertex.global_position.z > geometry.end_vertex.global_position.z: flip_axis.emit("z")
		face_moved.emit()

func update_size(min_pos: Vector3, max_pos: Vector3, size: Vector3) -> void:
	match controls:
		"x" : 
			%Collider.shape.size.x = size.z
			%Collider.shape.size.y = size.y
			%Mesh.mesh.size.x = size.z
			%Mesh.mesh.size.y = size.y
		"-x": 
			%Collider.shape.size.x = size.z
			%Collider.shape.size.y = size.y
			%Mesh.mesh.size.x = size.z
			%Mesh.mesh.size.y = size.y
		"y" : 
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.z
			%Mesh.mesh.size.x = size.x
			%Mesh.mesh.size.y = size.z
		"-y": 
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.z
			%Mesh.mesh.size.x = size.x
			%Mesh.mesh.size.y = size.z
		"z" : 
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.y
			%Mesh.mesh.size.x = size.x
			%Mesh.mesh.size.y = size.y
		"-z": 
			%Collider.shape.size.x = size.x
			%Collider.shape.size.y = size.y
			%Mesh.mesh.size.x = size.x
			%Mesh.mesh.size.y = size.y
	update_position(min_pos, max_pos, size)

func update_position(min_pos: Vector3, max_pos: Vector3, size: Vector3) -> void:
	match controls:
		"x" : global_position = Vector3(max_pos.x, min_pos.y, max_pos.z)
		"-x": global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
		"y" : global_position = Vector3(min_pos.x, max_pos.y, min_pos.z)
		"-y": global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
		"z" : global_position = Vector3(min_pos.x, min_pos.y, max_pos.z)
		"-z": global_position = Vector3(min_pos.x, min_pos.y, min_pos.z)
	%Collider.position = Vector3(%Collider.shape.size.x / 2, %Collider.shape.size.y / 2, 0)
	%Mesh.position = Vector3(%Mesh.mesh.size.x / 2, %Mesh.mesh.size.y / 2, 0)
