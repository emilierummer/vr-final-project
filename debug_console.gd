extends Node

const MAX_LINES = 25

var label: Label3D = null

func _ready() -> void:
	label = Label3D.new()
	add_child(label)
	#label.text = "Debug Console:"
	## Repurpose the debug console for the tutorial
	label.text = \
	"Welcome to Furniture Visualizer!\n" + \
	"Create your first piece of furniture by\n" + \
	"click and dragging with either hand's trigger.\n" + \
	"Adjust the size by dragging each face.\n" + \
	"When you're done you can move it around with\n" + \
	"the grab trigger.\n" + \
	"After it's sized and placed where you want it,\n" + \
	"press the X button to open the furniture menu.\n" + \
	"Use the left joystick to choose an object, then\n" + \
	"press A to select it.\n" + \
	"You can rotate it with the right joystick.\n" + \
	"Once it's in the rotation you want, use the\n" + \
	"trigger to apply it to a box.\n" + \
	"If you're done with this tutorial, press B\n" + \
	"to clear it."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	label.global_position = Vector3(0, 2, -5)

var num_lines: int = 1

func log(msg) -> void:
	print(msg)
	msg = stringify(msg)
	if label:
		num_lines += 1
		if num_lines >= MAX_LINES:
			# remove the top line (not "Debug Console" label)
			var split_text = label.text.split("\n", true, 2)
			label.text = split_text[0] + "\n" + split_text[2]
		label.text = label.text + "\n" + msg

func clear() -> void:
	num_lines = 1
	#var split_text = label.text.split("\n", true, 1)
	#label.text = split_text[0]
	label.text = ""

func stringify(msg) -> String:
	if msg is String: 
		return msg
	elif msg is Vector3:
		return "(" + str(snappedf(msg.x, 0.001)) + ", " + str(snappedf(msg.y, 0.001)) + ", " + str(snappedf(msg.z, 0.001)) + ")"
	elif msg is int or msg is float:
		return str(snappedf(msg, 0.001))
	elif msg is Transform3D:
		return "Origin: (" + stringify(msg.origin) + ")\nBasis: (" + str(msg.basis) + ")"
	elif msg is Face:
		return "Face controlling " + msg.controls
	elif msg is Vertex:
		return "Vertex at " + stringify(msg.global_position)
	elif msg is Controller:
		return "Controller " + msg.tracker
	else: 
		return str(msg)
