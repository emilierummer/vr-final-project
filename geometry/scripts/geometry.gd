class_name Geometry extends Node3D

## Minimum length of a size for the geometry (if the side is smaller than this, the geometry is not created)
const MIN_SIDE_LENGTH: float = 0.1

## The first corner of the verted (the initial drag position)
@export var start_vertex: Vertex
## The opposite corner from the first, it's final position is where the drag ends
@export var end_vertex: Vertex

func _on_start_initial_drag(controller: XRNode3D) -> void:
	end_vertex.held_by = controller
	end_vertex.vertex_moved.connect(_on_box_size_change.unbind(1))
	global_position = controller.global_position
	DebugConsole.log(global_position)

func _on_end_initial_drag() -> void:
	end_vertex.held_by = null
	end_vertex.vertex_moved.disconnect(_on_box_size_change)

func _on_box_size_change() -> void:
	# calculate new sizes and positions
	var min_pos = start_vertex.global_position.min(end_vertex.global_position)
	var size = Vector3(
		abs(start_vertex.global_position.x - end_vertex.global_position.x),
		abs(start_vertex.global_position.y - end_vertex.global_position.y),
		abs(start_vertex.global_position.z - end_vertex.global_position.z),
	)
	# make updates
	update_box_mesh(size, min_pos)

func update_box_mesh(size: Vector3, min_pos: Vector3) -> void:
	%BoxMesh.mesh.size = size
	%BoxMesh.global_position = Vector3(
		min_pos.x + size.x / 2,
		min_pos.y + size.y / 2,
		min_pos.z + size.z / 2,
	)
