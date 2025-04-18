class_name Controller extends XRNode3D

const TRIGGER_THRESHOLD = 0.5
var PACKED_GEOMETRY = preload("res://geometry/scenes/geometry.tscn")

signal geometry_created(geometry: Geometry)

## Makes sure the thumbstick movement event is not handled too many times by 
## waiting before handling more input
@onready var trigger_timer: Timer = $TriggerTimer
## Keeps track of what direction the trigger was in during the event before
## to make it so we only debounce events for the same direction multiple times
var prev_trigger_direction: String

## The geometry that is currently being edited/moved by this controller
var current_geometry: Geometry

## The selected furniture scene
var selected_furniture: PackedScene
## The size of the selected furniture
var selected_furniture_size: Vector3 = Vector3(1, 1, 1)
## The rotation of the selected furniture (this is the rotation 
## while being held by the controller)
var selected_furniture_rotation: Vector3 = Vector3(0, 0, 0)
## The selected furniture node (so that it can be removed when a 
## new one is selected)
var selected_furniture_node: Node = null

############################## INPUT PROCESSING ###############################

func _handle_button_click(button: String) -> void:
	if button == "trigger_click": 
		handle_trigger_click()
	elif button == "grip_click":
		handle_grab_click()
	elif button == "ax_button":
		handle_ax_click()
	elif button == "by_button":
		DebugConsole.clear()

func _handle_button_release(button: String) -> void:
	if button == "trigger_click":
		handle_trigger_release()
	elif button == "grip_click":
		handle_grab_release()

func _handle_trigger_input(_button: String, value: Vector2) -> void:
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
		%TriggerTimer.stop()
	# check if the direction is the same as last time, and if it is then we debounce it
	if prev_trigger_direction == trigger_direction:
		# don't handle anything if the input timer is not done
		if %TriggerTimer.time_left > 0: return
	prev_trigger_direction = trigger_direction
	# handle input
	handle_thumbstick_move(trigger_direction)
	# start timer until debounce is over
	%TriggerTimer.start()

################################ INPUT HANDLING ###############################

func handle_trigger_click() -> void:
	var overlapping_geometry = %Collider.get_overlapping_areas().filter(func filter(area): return area is Geometry)
	var clear_selected_furniture = func(): 
		if selected_furniture_node:
			selected_furniture_node.call_deferred("queue_free")
			selected_furniture_node = null
		selected_furniture_rotation = Vector3(0, 0, 0)
		selected_furniture = null
			
	if overlapping_geometry.size() == 0:
		# start creating geometry
		clear_selected_furniture.call()
		var new_geometry = PACKED_GEOMETRY.instantiate()
		current_geometry = new_geometry
		new_geometry.connect("ready", new_geometry.start_create.bind(self), ConnectFlags.CONNECT_ONE_SHOT)
		geometry_created.emit(new_geometry)
		return
	
	current_geometry = overlapping_geometry[0]
	if selected_furniture:
		# place furniture on geometry
		current_geometry.set_furniture(selected_furniture, selected_furniture_size, selected_furniture_rotation, self)
		clear_selected_furniture.call()
		current_geometry = null
		return
	
	var all_overlapping_faces = %Collider.get_overlapping_areas().filter(func filter(area): return area is Face)
	var overlapping_faces = current_geometry.faces.filter(func filter(face): return face.is_hovered)
	if overlapping_faces.size() > 0:
		# grab face that's overlapped
		for face in overlapping_faces:
			face.grab(self)
		return

func handle_trigger_release() -> void:
	# drop all faces and finish creating geometry
	if current_geometry:
		for face in current_geometry.faces:
			face.drop()
		current_geometry.end_create()

func handle_grab_click() -> void:
	var overlapping_geometry = %Collider.get_overlapping_areas().filter(func filter(area): return area is Geometry)
	if overlapping_geometry.size() > 0:
		# start moving the overlapping geometry
		current_geometry = overlapping_geometry[0]
		current_geometry.grab(self)

func handle_grab_release() -> void:
	# drop the geometry that is being held
	current_geometry.drop()

func handle_ax_click() -> void:
	pass

func handle_thumbstick_move(direction: String) -> void:
	pass
