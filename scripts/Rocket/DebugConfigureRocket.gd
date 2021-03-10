extends Camera

var rocket
var tank
var engine
var rcs

func _ready():
	rocket = get_parent()
	tank = rocket.get_node("Tank")
	engine = rocket.get_node("Engine")
	rcs = rocket.get_node("RCS")
	_link_parts()
	
func _link_parts():
	tank.add_fuel(50000,"Oxygen")
	tank.add_fuel(50000,"Hydrogen")
	tank.get_node("Joint").set_node_a(tank.get_path())
	tank.get_node("Joint").set_node_b(rocket.get_node("Engine").get_path())
	rocket.get_node("Engine").connected_tank = tank


func _input(event):
	if event.is_action_pressed("fire_engine"):
		engine.toggle_engine()
		
	if event.is_action_pressed("rcs_backward"):
		pass
		
	if event.is_action_pressed("rcs_backward"):
		pass
		
	if event.is_action_pressed("rcs_backward"):
		pass
		
	if event.is_action_pressed("rcs_backward"):
		pass
		
