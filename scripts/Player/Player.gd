extends KinematicBody


export var _move_speed := 30.0
export(float, 0, 2) var mouse_sensitivity := 1.0

onready var camera := $Camera

var direction_vector := Vector3.ZERO
Area

func _physics_process(delta: float) -> void:
	var forward_movement := Vector3.ZERO
	var sideways_movement := Vector3.ZERO
	move_and_slide(direction_vector * _move_speed)


func _unhandled_input(event: InputEvent) -> void:
	direction_vector = Vector3(
			event.get_action_strength("strafe_right") - event.get_action_strength("strafe_left"),
			0,
			event.get_action_strength("move_backward") - event.get_action_strength("move_forward")
		).normalized()
	
	var mouse_motion_event := event as InputEventMouseMotion
	if mouse_motion_event:
		rotation_degrees.y -= mouse_motion_event.relative.x * mouse_sensitivity
		var camera_tilt: float = camera.rotation_degrees.x
		camera_tilt -= mouse_motion_event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera_tilt, -90, 90)
