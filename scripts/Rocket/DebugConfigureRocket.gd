extends Camera

var rocket
func _ready():
	_link_parts()
	
func _link_parts():
	rocket = get_parent().get_parent()
	var tank = rocket.get_node("Tank")
	tank.add_fuel(50000,"Oxygen")
	tank.add_fuel(50000,"Hydrogen")
	tank.get_node("Joint").set_node_a(tank.get_path())
	tank.get_node("Joint").set_node_b(rocket.get_node("Engine").get_path())
	rocket.get_node("Engine").connected_tank = tank


func _input(event):
	if event.is_action_pressed("fire_engine"):
		rocket.get_node("Engine").toggle_engine()
