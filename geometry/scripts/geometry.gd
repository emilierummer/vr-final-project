class_name Geometry extends Area3D

## Minimum length of a size for the geometry (if the side is smaller than this, the geometry is not created)
const MIN_SIDE_LENGTH: float = 0.1

## The first corner of the rectangular prism (the initial drag position)
@export var start_vertex: Vertex
## The opposite corner from the first, it's final position is where the drag ends
@export var end_vertex: Vertex

## Stores the child furniture scene
var furniture_scene: Node3D
## Stores the size of the furniture's bounding box so it doesn't have to be recalculated
var furniture_size: Vector3

## Tracks which controller is holding the geometry
var held_by: XRNode3D = null
## Tracks how far offset the controller is from the geometry's root position
var grab_offset: Vector3

##################### INPUT HANDLING #####################

func _on_start_initial_drag(controller: XRNode3D) -> void:
	end_vertex.held_by = controller
	end_vertex.vertex_moved.connect(_on_box_size_change)
	global_position = controller.global_position

func _on_end_initial_drag() -> void:
	end_vertex.held_by = null
	end_vertex.vertex_moved.disconnect(_on_box_size_change)

func _on_start_move(controller: XRNode3D) -> void:
	grab_offset = controller.global_position - global_position
	held_by = controller

func _on_end_move() -> void:
	held_by = null

## Every frame, if the geometry is being held, move it to the controller's position
func _process(delta: float) -> void:
	if held_by:
		var new_position = held_by.global_position - grab_offset
		if new_position != global_position:
			global_position = new_position
			_on_box_position_change()

######################### UTILS #########################

var size: Vector3 :
	get:
		return Vector3(
			abs(start_vertex.global_position.x - end_vertex.global_position.x),
			abs(start_vertex.global_position.y - end_vertex.global_position.y),
			abs(start_vertex.global_position.z - end_vertex.global_position.z),
		)
	set(value):
		printerr("Cannot set size directly, modify start_vertex or end_vertex instead")

var min_pos: Vector3 :
	get:
		return start_vertex.global_position.min(end_vertex.global_position)
	set(value):
		printerr("Cannot set min_pos directly, modify start_vertex or end_vertex instead")

var max_pos: Vector3 :
	get:
		return start_vertex.global_position.max(end_vertex.global_position)
	set(value):
		printerr("Cannot set max_pos directly, modify start_vertex or end_vertex instead")

func get_faces():
	return %"FaceColliders".get_children()

## Swap the faces controlling a particular axis
## Example: x becomes -x and -x becomes x
func swap_face_axis(axis: String) -> void:
	var pos = axis
	var neg = "-" + axis
	# Find the right faces
	var faces = get_faces()
	var pos_face_index = faces.find_custom(func find(face): return face.controls == pos)
	var pos_face = faces[pos_face_index]
	var neg_face_index = faces.find_custom(func find(face): return face.controls == neg)
	var neg_face = faces[neg_face_index]
	# Swap their controls
	pos_face.controls = neg
	neg_face.controls = pos

##################### MESH UPDATING #####################

func _on_box_size_change() -> void:
	update_box_size()
	update_face_sizes()
	update_furniture_size()

func _on_box_position_change() -> void:
	update_box_position()
	update_face_positions()
	update_furniture_position()

func update_box_size() -> void:
	%BoxMesh.mesh.size = size
	%BoxCollider.shape.size = size
	update_box_position()

func update_box_position() -> void:
	var offset = Vector3(
		min_pos.x + size.x / 2,
		min_pos.y + size.y / 2,
		min_pos.z + size.z / 2,
	)
	%BoxMesh.global_position = offset
	%BoxCollider.global_position = offset

func update_face_sizes() -> void:
	for face in get_faces():
		face.update_size(min_pos, max_pos, size)

func update_face_positions() -> void:
	for face in get_faces():
		face.update_position(min_pos, max_pos, size)

func update_furniture_size() -> void:
	if !furniture_scene: return
	# scale furniture scene to match box
	var furniture_scale = size / furniture_size
	furniture_scene.transform = furniture_scene.transform.orthonormalized().scaled(furniture_scale)
	update_furniture_position()

func update_furniture_position() -> void:
	furniture_scene.global_position = Vector3(
		min_pos.x + size.x / 2,
		min_pos.y,
		min_pos.z + size.z / 2,
	)

func set_furniture(furniture: PackedScene) -> void:
	if furniture_scene: furniture_scene.call_deferred("queue_free")
	%BoxMesh.visible = false
	furniture_scene = furniture.instantiate()
	add_child(furniture_scene)
	furniture_size = furniture_scene.get_child(0).mesh.get_aabb().size
	update_furniture_size()
