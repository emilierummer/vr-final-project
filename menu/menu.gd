class_name Menu extends Node3D

var is_open: bool = false

func open() -> void:
	is_open = true

func close() -> void:
	is_open = false

func toggle_open() -> void:
	if is_open: close()
	else: open()

func handle_up() -> void:
	if not is_open: return
	#TODO

func handle_down() -> void:
	if not is_open: return
	#TODO

func handle_left() -> void:
	if not is_open: return
	#TODO

func handle_right() -> void:
	if not is_open: return
	#TODO

func handle_select() -> void:
	if not is_open: return
	#TODO
