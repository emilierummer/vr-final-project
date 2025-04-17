extends Controller

signal menu_toggle_open
signal menu_up
signal menu_down
signal menu_left
signal menu_right

func handle_ax_click() -> void:
	menu_toggle_open.emit()

func handle_thumbstick_move(direction: String) -> void:
	match direction:
		"up"   : menu_up.emit()
		"down" : menu_down.emit()
		"left" : menu_left.emit()
		"right": menu_right.emit()
