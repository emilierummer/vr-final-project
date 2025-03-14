extends Label3D

var num_lines: int = 1

func log(msg: String) -> void:
	print_debug(msg)
	num_lines += 1
	if num_lines >= 10:
		# remove the top line (not "Debug Console" label)
		var split_text = text.split("\n", true, 2)
		text = split_text[0] + "\n" + split_text[2]
	text = text + "\n" + msg
