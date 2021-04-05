class_name Engine
extends Part

var thrust_total = 30  #maximum thrust in Newtons
var thrust_percentage := 0.9
var on := false
var connected_tank
var fuel_configs = [] # for example: [   [  ["Hydrogen", 2],["Oxygen",1],Curve_consumption  ], next option    ]  save this in a resource later
var current_config = [["Hydrogen",2],["Oxygen",1],Curve.new()] # one of the fuel configs from fuel configs

func _integrate_engine_thrust(state) -> void:
	var force : Vector3 = thrust_total * thrust_percentage * global_transform.basis.y * float(on)
	var offset : Vector3 = get_node("offset").translation
	add_force(force,offset)

func _consume_fuel():
	var consumption = current_config.pop_back()
	var fuels = current_config

	for i in fuels:
		connected_tank.consume_fuel(i[1]*curve_consuption.interpolate_baked(thrust_percentage),i[0]) # wont work


func _integrate_forces(state):
	_integrate_engine_thrust(state)
	
func connect_tank(tank):
	connected_tank = tank

func toggle_engine():
	on = !on

func ignite_engine(percentage):
	on = true
	thrust_percentage = percentage

func cutoff_engine():
	on = false
