class_name RCSThruster
extends Spatial

var thruster_1_percentage := 0.0 # +x
var thruster_2_percentage := 0.0 # -x
var thruster_3_percentage := 0.0 # +y
var thruster_4_percentage := 0.0 # -y
var thruster_5_percentage := 0.0 # +z

var thruster_1
var thruster_2
var thruster_3
var thruster_4
var thruster_5

func fire_thrusters(dir : Vector3, strenght : float)  -> void:
	dir = dir.normalized()
	if dir.x != 0: 
		if dir.x > 0:
			thruster_1_percentage = dir.x
		else: # x < 0
			thruster_2_percentage = -dir.x # same as dir.abs()
	
	if dir.y != 0: 
		if dir.y > 0:
			thruster_3_percentage = dir.y
		else: # y < 0
			thruster_4_percentage = -dir.y # same as dir.abs()
	
	if dir.z > 0:
		thruster_5_percentage = dir.z
	update_engines()


func register_engines() -> void:
	var childs =  get_children()
	var engines : Array = []
	
	for i in childs.size():
		var child = childs[i]
		if child.get_class() == "Engine" or (ClassDB.is_parent_class(child.get_class(),"Engine")): #WTF
			engines.append(childs[i])
	if engines.size() > 5:
		printerr("TO MANY ENGINES FOR A RCSTHRUSTER")
	else:
		for i in engines.size():
			if engines[i].rotation_degrees == Vector3(0,0,90):
				thruster_1 = engines[i]
			elif engines[i].rotation_degrees == Vector3(0,0,-90):
				thruster_2 = engines[i]
			elif engines[i].rotation_degrees == Vector3(0,0,180):
				thruster_3 = engines[i]
			elif engines[i].rotation_degrees == Vector3(0,0,0):
				thruster_4 = engines[i]
			elif engines[i].rotation_degrees == Vector3(0,90,-90):
				thruster_5 = engines[i]
				
func update_engines() -> void:
	thruster_1.thrust_percentage = thruster_1_percentage
	thruster_2.thrust_percentage = thruster_2_percentage
	thruster_3.thrust_percentage = thruster_3_percentage
	thruster_4.thrust_percentage = thruster_4_percentage
	thruster_5.thrust_percentage = thruster_5_percentage
	
