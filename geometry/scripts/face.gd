class_name Face extends Draggable

@export_enum("x", "y", "z") var axis: String
@export var controlling_vertex: Vertex

@onready var mesh_material: ShaderMaterial = %Mesh.mesh.material

var is_hovered: bool = false

func _process(_delta: float) -> void:
	# Detect hover and change face color
	var overlapping_controllers = get_overlapping_areas().filter(func filter(area): return area.is_in_group("ControllerColliders"))
	set_is_hovered(overlapping_controllers.size() > 0)
	# Handle dragging (overrides Draggable)
	if held_by:
		var new_position = held_by.global_position - grab_offset
		self.global_position[axis] = new_position[axis]
		controlling_vertex.move_axis(axis, new_position[axis])

## This function sets the is_hovered value and the shader parameter
## It runs as its own function to avoid unnecessary changes to the shader parameters
func set_is_hovered(new_value: bool) -> void:
	if is_hovered != new_value:
		is_hovered = new_value
		mesh_material.set_shader_parameter("is_hovered", is_hovered)

func update_size(size: Vector2, pos: Vector3) -> void:
	# size
	%Collider.shape.size.x = size.x
	%Collider.shape.size.y = size.y
	%Mesh.mesh.size.x = size.x
	%Mesh.mesh.size.y = size.y
	# position
	global_position = pos
	global_position[axis] = controlling_vertex.global_position[axis]
	# offset
	%Collider.position = Vector3(%Collider.shape.size.x / 2, %Collider.shape.size.y / 2, 0)
	%Mesh.position = Vector3(%Mesh.mesh.size.x / 2, %Mesh.mesh.size.y / 2, 0)

func set_has_furniture_mesh(has_mesh: bool) -> void:
	mesh_material.set_shader_parameter("has_furniture", has_mesh)
