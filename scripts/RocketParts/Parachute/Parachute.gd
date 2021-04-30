class_name Parachute
extends Part 

enum ParachuteState { READY, DEPLOYED = 2, EXPLOYED  = 3,  }
export(NodePath) var housing
export(NodePath) var parachute 
export(NodePath) var cap
export(NodePath) var parachute_animation
export(NodePath) var offset
export var air_thickness = 3
var parachute_state
var density = 1.23
var drag_coefficient = 0.5
var parachute_area = 1
var force_length = 1
var cw = 2.1


func parachute_open():
	if parachute_state == ParachuteState.READY:
		parachute.visible = true
		housing.visible = false
		cap.visible = false
		parachute_animation.play("parachute_open")
		parachute_state = ParachuteState.DEPLOYED
		parachute_area = parachute.scale.x * parachute.scale.z * PI
	else: print("Parachute not available")

func parachute_cut():
	if parachute_state == ParachuteState.DEPLOYED:
		parachute_state = ParachuteState.EXPLOYED
	else: print("Parachute Cut is not available")

func parachute_load():
	if parachute_state == ParachuteState.EXPLOYED:
		parachute_state = ParachuteState.DEPLOYED
	else: print("No parachute to load")

func _ready():
	housing  = get_node(housing)
	parachute = get_node(parachute)
	cap = get_node(cap)
	parachute_animation = get_node(parachute_animation)
	offset = get_node(offset)
	parachute.visible = false
	parachute_state = ParachuteState.READY

func _integrate_forces(state):
	_integrate_parachute_forces(state)
	
func _integrate_parachute_forces(state):
	if parachute_state == ParachuteState.DEPLOYED:
		var v = linear_velocity.length()
		var forceMagnitude = 0.5 * drag_coefficient * parachute_area * v * v
		var forceDirection = -linear_velocity.normalized()
		var forceAppliedLocation = offset.translation
		add_force(forceMagnitude * forceDirection, forceAppliedLocation)

