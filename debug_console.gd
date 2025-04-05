extends Node

var label: Label3D = null

func _ready() -> void:
	label = Label3D.new()
	add_child(label)
	label.global_position = Vector3(0, 2, -5)

var num_lines: int = 1

func log(msg) -> void:
	# convert messages to strings
	if msg is Vector3:
		msg = "(" + str(snappedf(msg.x, 0.001)) + ", " + str(snappedf(msg.y, 0.001)) + ", " + str(snappedf(msg.z, 0.001)) + ")"
	# output message
	print(msg)
	if label:
		num_lines += 1
		if num_lines >= 10:
			# remove the top line (not "Debug Console" label)
			var split_text = label.text.split("\n", true, 2)
			label.text = split_text[0] + "\n" + split_text[2]
		label.text = label.text + "\n" + msg
