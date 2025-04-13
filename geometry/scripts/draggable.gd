class_name Draggable extends Area3D

var held_by: Controller
var grab_offset: Vector3
var disabled: bool

func grab(controller: Controller, use_offset: bool = true) -> void:
	if disabled:
		DebugConsole.log("Tried to grab but it was disabled...")
		return
	DebugConsole.log("Grab!")
	held_by = controller
	if use_offset: grab_offset = controller.global_position - self.global_position
	else: grab_offset = Vector3.ZERO

func drop() -> void:
	DebugConsole.log("Drop!")
	held_by = null

func disable() -> void:
	disabled = true

func enable() -> void:
	disabled = false

func _process(_delta: float) -> void:
	if held_by:
		self.global_position = held_by.global_position - grab_offset
