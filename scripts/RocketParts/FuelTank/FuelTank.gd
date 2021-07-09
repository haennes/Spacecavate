class_name FuelTank
extends Part
# maybe consider making an enum like thing (Probably Dictionary) for Error message: negativ constants

var max_different_fuels = 2
var max_capacity : int = 100000 #cm3
var tanks = []

func _ready(): # fix gets called to late
	var tank1 = Tank.new()
	var tank2 = Tank.new()
	print(tank1, tank2)
	tank2.possible_fuels = ["Oxygen"]
	tanks.append(tank1)
	tanks.append(tank2)

func add_fuel_auto(amount: int, fuel_name: String):
	var perfect_tanks = [] # already have the right fuel in them
	var good_tanks = [] # dont have any fuel in them
	for i in tanks:
		if i.can_hold_fuel(fuel_name):
			print("can hold "+ fuel_name)
			if i.get_current_fuel()== fuel_name and not i.is_full(amount):
				perfect_tanks.append(i)
			elif i.get_current_fuel() == "":
				good_tanks.append(i)
	if perfect_tanks.size() != 0:
		Tank.get_most_filled_tank(perfect_tanks).add_fuel(amount, fuel_name)
	elif good_tanks.size()!= 0:
		Tank.get_biggest_tank(good_tanks).add_fuel(amount, fuel_name)
	else:
		print("cant autofill"+ fuel_name)
		return "cant autofill"

func consume_fuel_auto(amount : int, fuel_name: String):
	var drainable_tanks = Tank.get_drainable_tanks(tanks,fuel_name)
	if drainable_tanks.size() != 0:
		return Tank.get_most_filled_tank(drainable_tanks).consume_fuel(amount)
	return 0
		
func consume_fuel(amount : int, fuel_name : String,tank : Tank):
	if tank.get_current_fuel() == fuel_name:
		return tank.consume_fuel(amount)
	else:
		return "tank hasnt" + fuel_name + "in it"

func can_consume_fuel(amount : int, fuel_name : String):
	var drainable_tanks = Tank.get_drainable_tanks(tanks,fuel_name)
	for i in drainable_tanks:
		if i.can_consume_fuel(amount):
			return true
	return false
