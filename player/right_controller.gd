extends Controller

const FURNITURE_SIZE = Vector3(0.1, 0.1, 0.1)

signal menu_select

func handle_ax_click() -> void:
	menu_select.emit()

func handle_select_furniture(furniture: PackedScene) -> void:
	selected_furniture = furniture
	# add furniture scene as child
	if selected_furniture_node: selected_furniture_node.call_deferred("queue_free")
	selected_furniture_node = furniture.instantiate()
	add_child(selected_furniture_node)
	selected_furniture_size = selected_furniture_node.get_child(0).mesh.get_aabb().size
	selected_furniture_node.transform = selected_furniture_node.transform.scaled(FURNITURE_SIZE / selected_furniture_size)

## Rotates the selected furniture node in the controller
func handle_thumbstick_move(direction: String) -> void:
	match direction:
		"up": 
			selected_furniture_rotation.x -= 90
			if selected_furniture_rotation.x > 360: selected_furniture_rotation.x -= 360
			elif selected_furniture_rotation.x < 0: selected_furniture_rotation.x += 360
		"down": 
			selected_furniture_rotation.x += 90
			if selected_furniture_rotation.x > 360: selected_furniture_rotation.x -= 360
			elif selected_furniture_rotation.x < 0: selected_furniture_rotation.x += 360
		"left": 
			selected_furniture_rotation.z += 90
			if selected_furniture_rotation.z > 360: selected_furniture_rotation.z -= 360
			elif selected_furniture_rotation.z < 0: selected_furniture_rotation.z += 360
		"right": 
			selected_furniture_rotation.z -= 90
			if selected_furniture_rotation.z > 360: selected_furniture_rotation.z -= 360
			elif selected_furniture_rotation.z < 0: selected_furniture_rotation.z += 360
	selected_furniture_node.rotation_degrees = selected_furniture_rotation
