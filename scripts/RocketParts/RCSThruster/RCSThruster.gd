class_name RCSThruster
extends Part

export var thruster_force = 10
var fire_threshold = 0

var disabled := false

var connected_tank
var current_config = [["Hydrogen",1]]

var thruster_pos_x_percentage := 0.0 # +x
var thruster_pos_y_percentage := 0.0 # +y
var thruster_neg_y_percentage := 0.0 # -y
var thruster_pos_z_percentage := 0.0 # +z
var thruster_neg_z_percentage := 0.0 # -z

var thruster_pos_x
var thruster_neg_z
var thruster_pos_y
var thruster_neg_y
var thruster_pos_z

func _ready():
	_register_thrusters()

func fire_thrusters_global(dir : Vector3, strength : float):
	var dirnew = dir.rotated(Vector3(1,0,0),rotation.x)
	dirnew = dirnew.rotated(Vector3(0,1,0),rotation.y)
	dirnew = dirnew.rotated(Vector3(0,0,1),rotation.z)
	dirnew = dirnew.normalized()
	fire_thrusters(dir,strength)

func fire_thrusters(dir : Vector3, strength : float):
	print("fired thrusters dir: ",dir, "strength:",strength)
	if dir == Vector3.ZERO:
		thruster_pos_x_percentage = 0
		thruster_pos_y_percentage = 0
		thruster_neg_y_percentage = 0
		thruster_pos_z_percentage = 0
		thruster_neg_z_percentage = 0
	
	if strength > 1: 
		strength = 1
	elif strength < 0:
		strength = 0
	dir = dir.normalized()
	
	if abs(dir.y) >= fire_threshold:
		if dir.y >= 0:
			thruster_pos_y_percentage = dir.y * strength
		else:
			thruster_neg_y_percentage = abs(dir.y) * strength # same as dir.abs()
	
	if abs(dir.z) >= fire_threshold: 
		if dir.z > 0:
			thruster_pos_z_percentage = dir.z * strength # same as dir.abs()
		else:
			thruster_neg_z_percentage = -dir.z * strength # same as dir.abs()

	if abs(dir.x) >= fire_threshold: 
		if dir.x > 0:
			thruster_pos_x_percentage = dir.x * strength


func _physics_process(delta):
	if can_consume_fuel():
		pass
	_integrate_thruster_forces(delta)
	

func _integrate_thruster_forces(_state):
	var thruster_pos_x_force = thruster_force * thruster_pos_x_percentage * thruster_pos_x.global_transform.basis.y.normalized()
	var thruster_pos_y_force = thruster_force * thruster_pos_y_percentage * thruster_pos_y.global_transform.basis.y.normalized()
	var thruster_neg_y_force = thruster_force * thruster_neg_y_percentage *thruster_neg_y.global_transform.basis.y.normalized()
	var thruster_pos_z_force = thruster_force * thruster_pos_z_percentage * thruster_pos_z.global_transform.basis.y.normalized()
	var thruster_neg_z_force = thruster_force * thruster_neg_z_percentage *thruster_neg_z.global_transform.basis.y.normalized()

	
	print(thruster_pos_x_force,thruster_pos_y_force, thruster_neg_y_force,thruster_pos_z_force,thruster_neg_z_force)
	rocket_add_force(thruster_pos_x_force,thruster_pos_x.translation)
	rocket_add_force(thruster_pos_y_force,thruster_pos_y.translation)
	rocket_add_force(thruster_neg_y_force,thruster_neg_y.translation)
	rocket_add_force(thruster_pos_z_force,thruster_pos_z.translation)
	rocket_add_force(thruster_neg_z_force,thruster_neg_z.translation)
	
	get_node("Thruster+x3").emitting = bool(thruster_pos_x_percentage)
	get_node("Thruster+y3").emitting = bool(thruster_pos_y_percentage)
	get_node("Thruster-y3").emitting = bool(thruster_neg_y_percentage)
	get_node("Thruster-z3").emitting = bool(thruster_pos_z_percentage)
	get_node("Thruster+z3").emitting = bool(thruster_neg_z_percentage)

func _register_thrusters():
	thruster_pos_x = get_node("Thruster+x2")
	thruster_pos_y = get_node("Thruster+y2")
	thruster_neg_y = get_node("Thruster-y2")
	thruster_pos_z = get_node("Thruster+z2")
	thruster_neg_z = get_node("Thruster-z2")

func can_consume_fuel():
	var return_values = []
	if connected_tank == null:
		return
	for i in current_config:
		return_values.append(connected_tank.consume_fuel_auto(i[1]*thruster_pos_x_percentage,i[0]))
	
	var one_is_neg = false
	for i in return_values:
		if i < 0:
			one_is_neg = true
			break
	return one_is_neg
