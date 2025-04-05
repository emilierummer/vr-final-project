extends XROrigin3D

const PACKED_GEOMETRY = preload("res://geometry/scenes/geometry.tscn")

@onready var LeftHand: XRNode3D = $LeftHand
@onready var RightHand: XRNode3D = $RightHand

## The parent node that all geometry should be created as children of
@export var geometry_parent: Node

## The geometry that is currently being created/edited by the left controller
var current_left_geometry: Geometry = null
## The geometry that is currently being created/edited by the right controller
var current_right_geometry: Geometry = null

################# HAND BUTTON HANDLING ####################

## Triggered when a button is pressed on the left controller
func _on_left_hand_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click": 
		DebugConsole.log("=======================")
		DebugConsole.log("Start Drag:")
		DebugConsole.log(LeftHand.global_position)
		current_left_geometry = start_creating_geometry(LeftHand)
	elif button_name == "grip_click":
		pass

## Triggered when a button is released on the left controller
func _on_left_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		DebugConsole.log("End Drag:")
		DebugConsole.log(LeftHand.global_position)
		finish_creating_geometry(LeftHand, current_left_geometry)
		current_left_geometry = null
	elif button_name == "grip_click":
		pass

## Triggered when a button is pressed on the right controller
func _on_right_hand_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click":
		current_right_geometry = start_creating_geometry(RightHand)
	elif button_name == "grip_click":
		pass

## Triggered when a button is released on the right controller
func _on_right_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		finish_creating_geometry(RightHand, current_right_geometry)
		current_right_geometry = null
	elif button_name == "grip_click":
		pass

##################### EVERYTHING ELSE #####################

func start_creating_geometry(controller: XRNode3D) -> Geometry:
	var new_geometry = PACKED_GEOMETRY.instantiate()
	geometry_parent.add_child(new_geometry)
	new_geometry._on_start_initial_drag(controller)
	return new_geometry

func finish_creating_geometry(controller: XRNode3D, geometry: Geometry) -> void:
	if not geometry: return
	# make sure the geometry is big enough before actually creating it
	var start_pos = geometry.start_vertex.global_position
	var end_pos = geometry.end_vertex.global_position
	if abs(start_pos.x - end_pos.x) < Geometry.MIN_SIDE_LENGTH \
	or abs(start_pos.y - end_pos.y) < Geometry.MIN_SIDE_LENGTH \
	or abs(start_pos.z - end_pos.z) < Geometry.MIN_SIDE_LENGTH:
		geometry.call_deferred("queue_free")
	else:
		geometry._on_end_initial_drag()
