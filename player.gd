extends XROrigin3D

const TRIGGER_THRESHOLD = 0.5
const TRIGGER_DEBOUNCE = 2
const PACKED_GEOMETRY = preload("res://geometry/scenes/geometry.tscn")

@onready var LeftHand: XRNode3D = $LeftHand
@onready var RightHand: XRNode3D = $RightHand

@onready var LeftHandCollider: Area3D = $LeftHand/LeftHandCollider
@onready var RightHandCollider: Area3D = $RightHand/RightHandCollider

## The furniture menu node
@onready var menu: Menu = $Menu

## The parent node that all geometry should be created as children of
@export var geometry_parent: Node

## The geometry that is currently being created/edited by the left controller
var current_left_geometry: Geometry = null
## The geometry that is currently being created/edited by the right controller
var current_right_geometry: Geometry = null

## Makes sure the thumbstick movement event is not handled too many times by 
## waiting before handling more input
@onready var trigger_timer: Timer = $TriggerTimer
## Keeps track of what direction the trigger was in during the event before
## to make it so we only debounce events for the same direction multiple times
var prev_trigger_direction: String

################# HAND BUTTON HANDLING ####################

## Triggered when a button is pressed on the left controller
func _on_left_hand_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click": 
		current_left_geometry = _handle_trigger(LeftHand, LeftHandCollider, current_left_geometry, true)
	elif button_name == "grip_click":
		pass
	elif button_name == "ax_button":
		menu.global_position = $Camera.global_position
		menu.global_rotation_degrees.y = $Camera.global_rotation_degrees.y
		menu.toggle_open()

## Triggered when a button is released on the left controller
func _on_left_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		current_left_geometry = _handle_trigger(LeftHand, LeftHandCollider, current_left_geometry, false)
	elif button_name == "grip_click":
		pass

## Triggered when the thumbstick is moved on the left controller
func _on_left_hand_thumbstick_changed(name: String, value: Vector2) -> void:
	# thumbstick only controls the menu (no menu, no thumbstick control calculation)
	if not menu.is_open: return
	# first we detect which direction the trigger is in
	var trigger_direction: String
	if value.x >= TRIGGER_THRESHOLD and abs(value.y) < TRIGGER_THRESHOLD:
		trigger_direction = "right"
	elif -value.x >= TRIGGER_THRESHOLD and abs(value.y) < TRIGGER_THRESHOLD:
		trigger_direction = "left"
	elif value.y >= TRIGGER_THRESHOLD and abs(value.x) < TRIGGER_THRESHOLD:
		trigger_direction = "up"
	elif -value.y >= TRIGGER_THRESHOLD and abs(value.x) < TRIGGER_THRESHOLD:
		trigger_direction = "down"
	else: # no direction, so reset timer and return early
		trigger_timer.stop()
	# check if the direction is the same as last time, and if it is then we debounce it
	if prev_trigger_direction == trigger_direction:
		# don't handle anything if the input timer is not done
		if trigger_timer.time_left > 0: return
	prev_trigger_direction = trigger_direction
	# handle input
	match trigger_direction:
		"right": menu.handle_right()
		"left": menu.handle_left()
		"up": menu.handle_up()
		"down": menu.handle_down()
	# start timer until debounce is over
	trigger_timer.start(TRIGGER_DEBOUNCE)

## Triggered when a button is pressed on the right controller
func _on_right_hand_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click":
		current_right_geometry = _handle_trigger(RightHand, RightHandCollider, current_right_geometry, true)
	elif button_name == "grip_click":
		pass
	elif button_name == "ax_button":
		pass

## Triggered when a button is released on the right controller
func _on_right_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		current_right_geometry = _handle_trigger(RightHand, RightHandCollider, current_right_geometry, false)
	elif button_name == "grip_click":
		pass

## Generic handler for trigger click or release events (to avoid code duplication)
func _handle_trigger(hand: XRNode3D, collider: Area3D, current_geom: Geometry, click: bool) -> Geometry:
	var overlapping_faces = collider.get_overlapping_areas().filter(func filter(area): return area is Face)
	if click:
		# handle click of trigger
		if overlapping_faces.size() == 0:
			return start_creating_geometry(hand)
		else:
			overlapping_faces[0].held_by = hand
			return overlapping_faces[0].geometry
	else:
		# handle release of trigger
		for face in current_geom.get_faces():
			face.held_by = null
		finish_creating_geometry(hand, current_geom)
		return null

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
