extends Controller

signal menu_select

func handle_ax_click() -> void:
	menu_select.emit()

func handle_select_furniture(furniture: PackedScene) -> void:
	DebugConsole.log("Furniture chosen")
	selected_furniture = furniture
