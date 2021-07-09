class_name Rocket
extends GravityObject

# parts will be sorted into groups ie: superlargetank1 is in the "Tank" group
export var ROCKET_NAME := "Untiteled"
var queued_forces = []
var stages := []
enum HEIGHT_MODE{TERRAIN,CENTER}

signal velocity_changed(velocity)
signal height_changed(height)
signal deltav_changed(deltav_complete)
signal name_changed(name) # add later might break things
signal stage_property_change(property,new_value)

##### Declare this in an Autoload later   (from)
var part_categories := ["Engine","Tank"] # and so on 

##### Declare this in an Autoload later   (to)
func _process(delta):
	emit_signal("velocity_changed",velocity)
	emit_signal("height_changed",get_height(HEIGHT_MODE.CENTER)) # implement button to switch mode
	emit_signal("deltav_changed",get_deltav())

func get_deltav():
	for i in stages:
		pass
	return 0


func get_height(mode):
	if mode == HEIGHT_MODE.CENTER:
		self.global_translation.distance_to(get_nearest_planet_distance())

func get_nearest_planet_distance():
	var planets_positions:=[]
	for i in get_tree().get_nodes_in_group("Planet"):
		planets_positions.append(i.global_translation.distance_to(self.global_translation))
	print("planetdistances_not_sorted",planets_positions)
	planets_positions.sort()
	print("planetdistances_yes_sorted",planets_positions)

func _integrate_forces(state):
	_integrate_queued_forces(state)

func _integrate_queued_forces(state):
	for i in queued_forces:
		add_force(i[0],i[1])
		print("added force rocket")
	queued_forces = []

func _register_all_parts():
	for i in part_categories.size():
		_register_all_parts_from_category(part_categories[i],self)


func _delete_parts_in_group(part_group_name : String):
	var parts = get_tree().get_nodes_in_group(part_group_name)
	for i in parts:
		parts[i].remove_from_group(part_group_name)


func _register_all_parts_from_category(part_category : String, node):
	if node.get_class() == part_category:
		node.add_to_group(part_category + ROCKET_NAME)
		node.add_to_group(ROCKET_NAME)
	for child in node.get_children():
		_register_all_parts_from_category(part_category, child)

func queue_force(force : Vector3, offset : Vector3):
	queued_forces.append([force,offset])
