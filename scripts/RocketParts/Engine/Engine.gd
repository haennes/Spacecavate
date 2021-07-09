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
var current_config = [{"fuel_name": "Hydrogen","amount": 2},{"fuel_name": "Oxygen","amount": 1}] # one of the fuel configs from fuel configs
var consumption_curve : Curve
var efficiency_cure : Curve

func _ready():

	offset_node = get_node(offset_node)
	consumption_curve = Curve.new()
	consumption_curve.add_point(Vector2(0,0))
	consumption_curve.add_point(Vector2(100,100))
	efficiency_cure = Curve.new()
	efficiency_cure.add_point(Vector2(100,0))
	efficiency_cure.add_point(Vector2(0,100))

func _integrate_engine_thrust(_state) -> void:
	var force : Vector3 = thrust_total * thrust_percentage * efficiency_cure.interpolate_baked(get_pressure())/100* offset_node.global_transform.basis.y * float(on)
	var offset : Vector3 = offset_node.translation
	if on:
		rocket_add_force(force,offset)
		_consume_fuel()
	#print(on)

func _consume_fuel():
	var return_values = []
	if connected_tank == null:
		return
	for i in current_config:
		return_values.append(connected_tank.consume_fuel_auto(i["amount"]*consumption_curve.interpolate_baked(thrust_percentage * float(on)),i["fuel_name"]))
	
	var one_is_neg = false
	for i in return_values:
		if i <= 0:
			one_is_neg = true
			break
	if on and (not one_is_neg):
		cutoff_engine()
	

func _physics_process(delta):
	_integrate_engine_thrust(delta)

	
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

func get_efficiency(_thrust_percentage) -> float:
	var fuels_volume = 0
	for i in current_config:
		fuels_volume += i["amount"]
	var efficiency = _thrust_percentage * thrust_total / fuels_volume
	return efficiency

func get_most_efficient_thrust_percentage() -> int:
	return 80
	
func get_most_efficient_ambient_pressure() -> int:
	return 10000

func get_mass_propellant() -> int:
	var prop_mass = 0
	for i in current_config:
		prop_mass += i["amount"]*consumption_curve.interpolate_baked(thrust_percentage)
	return prop_mass
