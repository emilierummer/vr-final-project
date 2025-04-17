class_name Geometry extends Draggable

## Minimum length of a size for the geometry (if the side is smaller than this, the geometry is not created)
const MIN_SIDE_LENGTH: float = 0.1

@export var start_vertex: Vertex
@export var end_vertex: Vertex

@export var faces: Array[Face]

## Stores the child furniture scene
var furniture_scene: Node3D = null
## Stores the size of the furniture's bounding box so it doesn't have to be recalculated
var furniture_size: Vector3

func start_create(controller: Controller) -> void:
	start_vertex.move(controller.global_position)
	end_vertex.move(controller.global_position)
	end_vertex.grab(controller, false)

func end_create() -> void:
	end_vertex.drop()
	start_vertex.disable()
	end_vertex.disable()
	# if any side is shorter than allowed, remove the geometry
	if size.x < MIN_SIDE_LENGTH \
	or size.y < MIN_SIDE_LENGTH \
	or size.z < MIN_SIDE_LENGTH:
		call_deferred("queue_free")
		return

func on_size_changed() -> void:
	# vertices are already in the right place because that's what triggers this function
	# update box collider size
	%BoxCollider.shape.size = size
	%BoxCollider.global_position = min_pos + (size / 2)
	# update each face's size
	for face in faces:
		match face.axis:
			"x": face.update_size(Vector2(size.z, size.y), Vector3(0, min_pos.y, max_pos.z))
			"y": face.update_size(Vector2(size.x, size.z), Vector3(min_pos.x, 0, min_pos.z))
			"z": face.update_size(Vector2(size.x, size.y), Vector3(min_pos.x, min_pos.y, 0))
	# update furniture mesh's size
	if furniture_scene:
		var furniture_scale = size / furniture_size
		furniture_scene.transform = furniture_scene.transform.orthonormalized().scaled(furniture_scale)
		furniture_scene.global_position = Vector3(
			min_pos.x + size.x / 2,
			min_pos.y,
			min_pos.z + size.z / 2
		)

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

##################### MESH UPDATING #####################

func set_furniture(furniture: PackedScene, f_size: Vector3, f_rotation: Vector3, controller: Controller) -> void:
	if furniture_scene: furniture_scene.call_deferred("queue_free")
	furniture_scene = furniture.instantiate()
	add_child(furniture_scene)
	furniture_size = f_size
	furniture_scene.rotation_degrees.y = round((controller.rotation_degrees.y + f_rotation.y) / 90) * 90
	for face in faces: 
		face.set_has_furniture_mesh(true)
	on_size_changed()
