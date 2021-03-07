class_name Tank
extends Part
# maybe consider making an enum like thing (Probably Dictionary) for Error message: negativ constants (line )

var fuels : Dictionary
var max_different_fuels = 2
var max_capacity : int = 100000

func _ready():
	add_fuel(50000,"Oxygen")
	add_fuel(50000,"Hydrogen")

func consume_fuel(amount : int, fuel_name : String):
	if amount < 0:
		return "amount smaller than 0, NOTE: you cant add fuel by that use add_fuel(amount,fuel_name) instead"
	if fuels.has(fuel_name):
		if fuels[fuel_name] > amount:
			fuels[fuel_name] -= amount
			print(fuels[fuel_name])
		else:
			amount -= fuels[fuel_name]  
			fuels[fuel_name] = 0
			return amount
	else:
		return "Failed to look up key in the tanks dicitionary"


func add_fuel(amount : int, fuel_name : String):
	if amount < 0:
		return "amount smaller than 0, NOTE: you cant remove/consume fuel by that use consume(amount,fuel_name) instead"
	if fuels.has(fuel_name):
		if get_total_fuel_level() + amount < max_capacity:
			fuels[fuel_name] += amount
			return 0
		else:
			fuels[fuel_name] += max_capacity - fuels[fuel_name]
			return max_capacity - fuels[fuel_name]

func get_total_fuel_level() -> int:
	var total_amount : int = 0
	for i in fuels.keys():
		total_amount += fuels[i]
	return total_amount
