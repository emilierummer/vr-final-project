extends XROrigin3D

@onready var LeftHand = $LeftHand
@onready var RightHand = $RightHand

@onready var DebugConsole = get_parent().get_node("DebugConsole")

################# HAND BUTTON HANDLING ####################

## Triggered when a button is pressed on the left controller
func _on_left_hand_button_pressed(name: String) -> void:
	DebugConsole.log("Left hand button pressed: " + name)

## Triggered when a button is released on the left controller
func _on_left_hand_button_released(name: String) -> void:
	DebugConsole.log("Left hand button released: " + name)

## Triggered when a button is pressed on the right controller
func _on_right_hand_button_pressed(name: String) -> void:
	DebugConsole.log("Right hand button pressed: " + name)

## Triggered when a button is released on the right controller
func _on_right_hand_button_released(name: String) -> void:
	DebugConsole.log("Right hand button released: " + name)

##################### EVERYTHING ELSE #####################
