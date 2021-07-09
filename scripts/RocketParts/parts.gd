extends Spatial
class_name Part
var rocket


func _ready():
	rocket = get_parent()
	_register_all_joints(self)
	remove_from_group("gravity_objects")
	move_collisonshapes_out()
	
func _register_all_joints(node) -> void:
	if node is Joint or ClassDB.is_parent_class(node.get_class(),"Joint"):
		node.add_to_group("Joints")

func scale_childs(scale : Vector3) -> void:
	for i in get_child_count():
		get_child(i).scale = scale
		get_child(i).translation *= scale


func rocket_add_force(force : Vector3 , offset : Vector3):
	if force == Vector3.ZERO:
		return
	print("adding force" + String(force) + String(rocket.get_path()))
	rocket.queue_force(force,(global_transform.origin + offset) - rocket.global_transform.origin)

func rocket_add_central_force(force : Vector3):
	rocket_add_force(force, Vector3.ZERO)

func move_collisonshapes_out():
	for i in get_children():
		if i is CollisionShape or i is CollisionPolygon:
			i.name += self.name
			remove_child(i)
			rocket.call_deferred("add_child",i)

func get_pressure():
	return 100000 # debug change this later pressure is always messured in pascal

#func split_mesh(node, _mass : int):
	#var body = Part.new()
	#body.mass = _mass
	#body.add_child(node)
	#get_parrent().add_child(node)

