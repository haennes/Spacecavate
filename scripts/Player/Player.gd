class_name Player
extends KinematicBody

# move_and_slide parameters
const UP_VECTOR := Vector3.UP
const STOP_ON_SLOPE := true
const MAX_SLIDES := 4
const FLOOR_MAX_ANGLE := deg2rad(45)
const INF_INERTIA := false

const MAX_CAMERA_TILT := 90

# Data from this resource will be used for implementation of third person camera
#export(Resource) var camera_data = camera_data as CameraData

export(float, 0, 5) var walk_speed := 10.0
export(float, 0, 500) var walk_acceleration := 250.0
export(float, 0, 10) var run_speed := 30.0
export(float, 0, 1000) var run_acceleration := 400.0
export(float, 0, 100) var gravity_force := 9.8
export(float, 0, 1000) var jump_force := 150.0
export(float, 0, 2) var mouse_sensitivity := 1.0 	# This will be later moved to game settings

onready var camera := $Camera

var _current_move_speed := walk_speed
var _current_acceleration := walk_acceleration
var _linear_velocity := Vector3.ZERO


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		_linear_velocity += Vector3.DOWN * gravity_force
	else:
		move(delta)
	
	_linear_velocity = move_and_slide(_linear_velocity, UP_VECTOR, STOP_ON_SLOPE, MAX_SLIDES, FLOOR_MAX_ANGLE, INF_INERTIA)


func move(delta: float) -> void:
	var forward_movement := transform.basis.z * (Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	var sideways_movement := transform.basis.x * (Input.get_action_strength("strafe_right") - Input.get_action_strength("strafe_left"))
	var direction_vector := (forward_movement + sideways_movement).normalized()
	_linear_velocity = _linear_velocity.move_toward(direction_vector * _current_move_speed, _current_acceleration * delta)


func _unhandled_input(event: InputEvent) -> void:
	get_mouse_input(event)
	jump(event)
	run(event)


func get_mouse_input(event: InputEvent) -> void:
	var mouse_motion_event := event as InputEventMouseMotion
	if mouse_motion_event:
		rotation_degrees.y -= mouse_motion_event.relative.x * mouse_sensitivity
		var camera_tilt: float = camera.rotation_degrees.x
		camera_tilt -= mouse_motion_event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera_tilt, -MAX_CAMERA_TILT, MAX_CAMERA_TILT)


func jump(event: InputEvent) -> void:
	if event.is_action("jump") && is_on_floor():
		_linear_velocity += transform.basis.y * jump_force


func run(event: InputEvent) -> void:
	if event.is_action_pressed("run"):
		_current_move_speed = run_speed
		_current_acceleration = run_acceleration
	elif event.is_action_released("run"):
		_current_move_speed = walk_speed
		_current_acceleration = walk_acceleration
