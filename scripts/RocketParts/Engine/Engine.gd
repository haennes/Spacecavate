class_name Engine
extends Part

export var thrust_total = 300  #maximum thrust in Newtons
export var max_tilt := Vector2(20,20)
export var min_tilt := Vector2(-20,-20)
export(NodePath) var offset_node
var thrust_percentage := 0.9
var on := false
var connected_tank
var fuel_configs = [] # for example: [   [  ["Hydrogen", 2],["Oxygen",1],Curve_consumption  ], next option    ]  save this in a resource later
var current_config = [["Hydrogen",2],["Oxygen",1]] # one of the fuel configs from fuel configs
var consumption_curve

func _ready():
	offset_node = get_node(offset_node)
	consumption_curve = Curve.new()
	consumption_curve.add_point(Vector2(0,0))
	consumption_curve.add_point(Vector2(100,100))

func _integrate_engine_thrust(_state) -> void:
	var force : Vector3 = thrust_total * thrust_percentage * offset_node.global_transform.basis.y * float(on)
	var offset : Vector3 = offset_node.translation
	add_force(force,offset)
	_consume_fuel()
	#print(on)

func _consume_fuel():
	var return_values = []
	if connected_tank == null:
		return
	for i in current_config:
		return_values.append(connected_tank.consume_fuel_auto(i[1]*consumption_curve.interpolate_baked(thrust_percentage * float(on)),i[0]))
	
	var one_is_neg = false
	for i in return_values:
		if i < 0:
			one_is_neg = true
			break
	if on and one_is_neg:
		cutoff_engine()
	

func _integrate_forces(state):
	_integrate_engine_thrust(state)
	add_central_force(Vector3.DOWN*2)
	
func tilt_enine(direction : Vector2):
	var rotation_clamped_x = clamp(rotation_degrees.x + direction.x,min_tilt.x,max_tilt.x)
	var rotation_clamped_y = clamp(rotation_degrees.z + direction.y,min_tilt.y,max_tilt.y)
	print("tilting "+ String(rotation_clamped_x) +"     "+ String(rotation_clamped_y)+"current_tilt"+String(rotation_degrees.x)+"   "+String(rotation_degrees.z))
	offset_node.set_rotation_degrees(Vector3(rotation_clamped_x , get_rotation_degrees().y,rotation_clamped_y)) #x #z
	get_node("MeshInstance").set_rotation_degrees(Vector3(rotation_clamped_x , get_rotation_degrees().y,rotation_clamped_y)) #x #z

func connect_tank(tank):
	connected_tank = tank

func toggle_engine():
	on = !on

func ignite_engine(percentage):
	on = true
	thrust_percentage = percentage

func cutoff_engine():
	on = false
