class_name Stage
extends Resource

var rocket
var name : String
var fuels :={}
var deltav := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate_deltav() -> float:
	var parts = get_parts()
	var dry_mass = 0
	var engines = []
	var tanks = []
	var thrust = 0
	var fuel_mass_per_second = 0
	for part in parts:
		if ClassDB.is_parent_class("Engine", part.get_class()):
			engines.append(part)
		if ClassDB.is_parent_class("FuelTank", part.get_class()):
			tanks.append(part)
		dry_mass += part.mass
	if engines.size() > 0:
		var efficiency = 0
		for i in engines:
			efficiency += i.get_efficiency(i.get_most_efficient_thrust_percentage(),i.get_most_efficient_height())
			thrust += i.thrust_total * i.get_most_efficient_thrust_percentage()
			fuel_mass_per_second += i.get_mass_propellant()
		efficiency /= engines.size()
	var fuel_mass = 0
	if tanks.size() > 0:
		for fuel_tank in tanks:
			for tank in fuel_tank.tanks:
				fuel_mass += tank.get_current_fuel_mass()
	var exhaust_velocity = thrust / fuel_mass_per_second
	return exhaust_velocity*log((fuel_mass+dry_mass)/dry_mass)

func get_parts() -> Array:
	var rocket_parts = rocket.get_tree().get_nodes_in_group(rocket.name)
	var parts = []
	for i in rocket_parts:
		if i.is_in_group(name):
			parts.append(i)
	return parts
