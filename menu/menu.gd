class_name Menu extends Node3D

signal furniture_selected(furniture: PackedScene)

@export var Camera: Camera3D

@onready var options: Array = %OptionGrid.get_children()

var is_open: bool = false

## The index of which menu item is focused. If the close button is focused, its value is -1
var focused_option: int = 0

func set_focus(value: int) -> void:
	if focused_option == -1:
		%CloseButton.release_focus()
	else:
		options[focused_option].release_focus()
	if value == -1:
		%CloseButton.grab_focus()
	else:
		options[value].grab_focus()
	focused_option = value

func open() -> void:
	global_position = Camera.global_position
	global_rotation_degrees.y = Camera.global_rotation_degrees.y
	visible = true
	set_focus(0)
	is_open = true

func close() -> void:
	visible = false
	is_open = false

func toggle_open() -> void:
	if is_open: close()
	else: open()

func handle_up() -> void:
	if not is_open: return
	if focused_option - 2 < 0: set_focus(-1)
	else: set_focus(focused_option - 2)

func handle_down() -> void:
	if not is_open: return
	if focused_option == -1: 
		set_focus(0)
	elif focused_option + 2 < options.size():
		set_focus(focused_option + 2)

func handle_left() -> void:
	if not is_open: return
	if focused_option % 2 != 0:
		set_focus(focused_option - 1)

func handle_right() -> void:
	if not is_open: return
	if focused_option % 2 != 1:
		set_focus(focused_option + 1)

func handle_select() -> void:
	if not is_open: return
	if focused_option == -1:
		close()
	else:
		furniture_selected.emit(options[focused_option].furniture_scene)
