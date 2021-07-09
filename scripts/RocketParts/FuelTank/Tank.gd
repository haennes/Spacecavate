class_name Tank
extends Resource

export var possible_fuels = ["Hydrogen"]
export var max_capacity = 50000
export var transfer_rate = 20
var current_fuel_name = ""
var current_fuel_amount = 0


func add_fuel(amount : int, fuel_name : String):
	if can_currently_hold_fuel(fuel_name):
			set_current_fuel(fuel_name)
	else:
		return "you cant store " + fuel_name + "in this tank"
	if amount < 0:
		return "amount smaller than 0, NOTE: you cant remove/consume fuel by that use consume(amount,fuel_name) instead"
	if amount + current_fuel_amount < max_capacity:
		_add_fuel_unsafe(amount)
		return 0
	else:
		var fuel_left = -(max_capacity - current_fuel_amount - amount)
		_add_fuel_unsafe(amount-fuel_left)
		return fuel_left #retuns how much fuel couldnt be added

func _add_fuel_unsafe(amount : int):
	current_fuel_amount += amount
	pass

	
func consume_fuel(amount : int):
	#print("consumed fuel current fuel"+ current_fuel_name+ "amount:"+ String(current_fuel_amount))
	if amount < 0:
		return "amount smaller than 0, NOTE: you cant add fuel by that use add_fuel(amount,fuel_name) instead"
	if amount > current_fuel_amount:
		_consume_fuel_unsafe(current_fuel_amount)
		return current_fuel_amount - amount #returns how much fuel couldnt be withdrawn (negative)
	else:
		_consume_fuel_unsafe(amount)
		return 0

func _consume_fuel_unsafe(amount : int):
	current_fuel_amount -= amount


func can_hold_fuel(fuel_name : String):
	if fuel_name in possible_fuels:
		return true
	return false

func can_currently_hold_fuel(fuel_name : String):
	return can_hold_fuel(fuel_name) and (get_current_fuel() == "" or get_current_fuel() == fuel_name)

func can_consume_fuel(amount) -> bool:
	return amount >= current_fuel_amount

func get_possible_fuels():
	return possible_fuels

func get_current_fuel():
	return current_fuel_name
	
func get_current_fuel_mass():
	return current_fuel_name * 10 # replace as soon as the Autoload for fuel is added

func set_current_fuel(name: String):
	if can_hold_fuel(name):
		current_fuel_name = name
	else:
		return "This tank cant hold " + name

func is_full(with = 0) -> bool:
	return current_fuel_amount + with >= max_capacity

static func get_most_filled_tank(tanks_array):
	var current_max = tanks_array[0]
	for i in tanks_array:
		if current_max.current_fuel_amount < i.current_fuel_amount:
			current_max = i
	return current_max

		
static func get_biggest_tank(tanks_array):
	var current_max = tanks_array[0]
	for i in tanks_array:
		if current_max.max_capacity < i.max_capacity:
			current_max = i
	return current_max
	
static func get_drainable_tanks(tanks_array,fuel_name : String):
	var drainable_tanks = []
	for i in tanks_array:
		if i.get_current_rules() == fuel_name:
			drainable_tanks.append(i)
	return drainable_tanks
