extends Camera

var rocket
var tank
var engine
var rcs
var rcs2
var parachute

func _ready():
	rocket = get_parent().get_node("Rocket")
	tank = rocket.get_node("Tank")
	engine = rocket.get_node("Engine")
	rcs = rocket.get_node("RCS")
	rcs2 = rocket.get_node("RCS2")
	parachute = rocket.get_node("Parachute")
	_link_parts()
	
func _link_parts():
	rcs.scale_childs(Vector3(0.2,0.2,0.2))
	rcs2.scale_childs(Vector3(0.2,0.2,0.2))
	tank.add_fuel_auto(50000,"Oxygen")
	tank.add_fuel_auto(100000,"Hydrogen")
	tank.get_node("Joint").set_node_a(tank.get_path())
	tank.get_node("Joint").set_node_b(engine.get_path())
	rcs.get_node("Joint").set_node_a(rcs.get_path())
	rcs.get_node("Joint").set_node_b(engine.get_path())
	rcs2.get_node("Joint").set_node_a(rcs2.get_path())
	rcs2.get_node("Joint").set_node_b(engine.get_path())
	rocket.get_node("Engine").connected_tank = tank
	parachute.get_node("Joint").set_node_a(parachute.get_path())
	parachute.get_node("Joint") .set_node_b(engine.get_path())
	

func _input(event):
	if event.is_action_pressed("fire_engine"):
		engine.toggle_engine()
		print("fire_engine")

	if event.is_action_pressed("parachute_open",true):
		parachute.parachute_open()
	
	if event.is_action_pressed("parachute_cut", true):
		parachute.parachute_cut()
	
	if event.is_action_pressed("parachute_load", true):
		parachute.parachute_load()
			
	if event.is_action_pressed("rcs_backward",true):
		rcs.fire_thrusters_global(Vector3.BACK,1.0)
		rcs2.fire_thrusters_global(Vector3.BACK,1.0)
		print("rcs_backwards")
		
	elif event.is_action_pressed("rcs_forward",true):
		rcs.fire_thrusters_global(Vector3.FORWARD,1.0)
		rcs2.fire_thrusters_global(Vector3.FORWARD,1.0)
		print("rcs_forwards")
		
	elif event.is_action_pressed("rcs_left",true):
		rcs.fire_thrusters_global(Vector3.LEFT,1.0)
		rcs2.fire_thrusters_global(Vector3.RIGHT,1.0)
		print("rcs_left")
			
	elif event.is_action_pressed("rcs_right",true):
		rcs.fire_thrusters_global(Vector3.RIGHT,1.0)
		rcs2.fire_thrusters_global(Vector3.LEFT,1.0)
		print("rcs_right")
		
	elif event.is_action_pressed("rcs_up",true):
		rcs.fire_thrusters_global(Vector3.UP,1.0)
		rcs2.fire_thrusters_global(Vector3.DOWN,1.0)
		print("rcs_up")
	
	elif event.is_action_pressed("rcs_down",true):
		rcs.fire_thrusters_global(Vector3.DOWN,1.0)
		rcs2.fire_thrusters_global(Vector3.UP,1.0)
		print("rcs_down")
		
	else:
		rcs.fire_thrusters_global(Vector3.ZERO,1.0)
		rcs2.fire_thrusters_global(Vector3.ZERO,1.0)
		#print("rcs_reset")
	
		
	

func split_mesh(node, _mass : int):
	var body = Part.new()
	body.mass = _mass
	body.add_child(node)
	rocket.add_child(node)
