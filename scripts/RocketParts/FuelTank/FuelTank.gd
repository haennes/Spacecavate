extends Part

var fuels : Dictionary

func consume_fuel(amount : float, fuel_name : String):
	if fuels.has(fuel_name):
		fuels[fuel_name] -= amount
	else:
		return "Failed to look up key in the tanks dicitionary"
