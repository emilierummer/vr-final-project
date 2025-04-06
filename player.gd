extends XROrigin3D

const PACKED_GEOMETRY = preload("res://geometry/scenes/geometry.tscn")

@onready var LeftHand: XRNode3D = $LeftHand
@onready var RightHand: XRNode3D = $RightHand

@onready var LeftHandCollider: Area3D = $LeftHand/LeftHandCollider
@onready var RightHandCollider: Area3D = $RightHand/RightHandCollider

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
		current_left_geometry = _handle_trigger(LeftHand, LeftHandCollider, current_left_geometry, true)
	elif button_name == "grip_click":
		pass

## Triggered when a button is released on the left controller
func _on_left_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		current_left_geometry = _handle_trigger(LeftHand, LeftHandCollider, current_left_geometry, false)
	elif button_name == "grip_click":
		pass

## Triggered when a button is pressed on the right controller
func _on_right_hand_button_pressed(button_name: String) -> void:
	if button_name == "trigger_click":
		current_right_geometry = _handle_trigger(RightHand, RightHandCollider, current_right_geometry, true)
	elif button_name == "grip_click":
		pass

## Triggered when a button is released on the right controller
func _on_right_hand_button_released(button_name: String) -> void:
	if button_name == "trigger_click":
		current_right_geometry = _handle_trigger(RightHand, RightHandCollider, current_right_geometry, false)
	elif button_name == "grip_click":
		pass

## Generic handler for trigger click or release events (to avoid code duplication). 
## Returns either a Geometry object or void/null, depending on what the effect of the trigger is
func _handle_trigger(hand: XRNode3D, collider: Area3D, current_geom: Geometry, click: bool):
	var overlapping_faces = collider.get_overlapping_areas().filter(func filter(area): return area is Face)
	if click:
		# handle click of trigger
		if overlapping_faces.size() == 0:
			return start_creating_geometry(hand)
		else:
			overlapping_faces[0].held_by = hand
	else:
		# handle release of trigger
		for face in overlapping_faces.filter(func filter(face): return face.held_by == hand):
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
