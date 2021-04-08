class_name PersonCamera
extends SpringArm
#used for 3rd as well as first person

enum CameraMode { FIRST_PERSON , _3RD_PERSON = 2 } # _ is needed other wise it gets confused

var scroll_speed = 0.1 #move this to CameraData

var spring_length_last = spring_length
var current_camera_mode = CameraMode.FIRST_PERSON



func set_mode(mode):
	current_camera_mode = mode
	update_camera()

func get_mode():
	return current_camera_mode

func change_mode():
	print("change_mode")
	if current_camera_mode == CameraMode._3RD_PERSON:
		current_camera_mode = CameraMode.FIRST_PERSON
	else:
		current_camera_mode = CameraMode._3RD_PERSON
	update_camera()

func update_camera():
	if current_camera_mode == CameraMode.FIRST_PERSON:
		spring_length = 0
	elif current_camera_mode == CameraMode._3RD_PERSON:
		spring_length = spring_length_last

func _input_pass_through(event : InputEventMouse):

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y*0.1,-90,90)
			rotation_degrees.y -= event.relative.x*0.1
		else:
			if event.is_action_pressed("scroll_in"):
				spring_length -= scroll_speed
			elif event.is_action_pressed("scroll_out"):
				spring_length += scroll_speed
				spring_length_last = spring_length

	
