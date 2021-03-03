class_name Rocket
extends Spatial

# parts will be sorted into groups ie: superlargetank1 is in the "Tank" group
export var ROCKET_NAME := "Untiteled"
var velocity : Vector3 = Vector3.ZERO
var posn : Vector3 = Vector3.ZERO  # the next position
var position_array : Array = []
export var starting_velocity := Vector3(0,0,0)

##### Declare this in an Autoload later   (from)

var G := 6.0 # this is nonsense rn sorry
var part_categories := ["Engine","Tank"] # and so on 

##### Declare this in an Autoload later   (to)

func _ready():
	add_to_group("gravity_objects")
	set_velocity(starting_velocity)
	position_array.append(self.translation)


func set_velocity(_velocity : Vector3) -> void:
	velocity = _velocity

func _register_all_parts():
	for i in part_categories.size():
		_register_all_parts_from_category(part_categories[i],self)

func _integrate_engine_forces():
	var engines = get_tree().get_nodes_in_group("Engine" + ROCKET_NAME)
	for i in engines.size():
		var engine : Engine = engines[i]
		Engine.integrate_thrust()


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

func calculate_next_position(delta : float) -> void:
	var stringToPrint : String = ""
	var acceleration = Vector3.ZERO
	var gravity_objects = get_tree().get_nodes_in_group("gravity_objects")
	for x in gravity_objects.size():
		var gravity_object : RigidBody = gravity_objects[x]
		if gravity_object == self:
			continue
		var direction = position_array[-1].direction_to(gravity_object.position_array[-1])
		var squaredistance = position_array[-1].distance_squared_to(gravity_object.position_array[-1])
		stringToPrint += "dir: " + String(direction) + "squaredistance: " + String(squaredistance)
		acceleration += direction*G*gravity_object.mass / squaredistance
	velocity += acceleration * delta
	posn = position_array[-1] + velocity * delta
	stringToPrint += "acceleration: " + String(acceleration) + "posn: " + String(posn) + "lastpos: " + String(position_array[-1]) + "pos_array_lenght" + String(position_array.size())
	#print(stringToPrint)
	
func update_posarray(i : int) -> void:
	print("update_posarray() called")
	position_array.append(posn)
	$Path.curve.add_point(posn)
#	var multimeshinstance = get_parent().get_node("MultiMeshInstance")
#	var trans = Transform(Basis(Vector3.UP,0),posn)
#	multimeshinstance.multimesh.set_instance_transform(i,trans)
