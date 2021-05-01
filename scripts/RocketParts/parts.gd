extends GravityObject
class_name Part



func _ready():
	_register_all_joints(self)
	remove_from_group("gravity_objects")
	
func _register_all_joints(node) -> void:
	if node is Joint or ClassDB.is_parent_class(node.get_class(),"Joint"):
		node.add_to_group("Joints")

func scale_childs(scale : Vector3) -> void:
	for i in get_child_count():
		get_child(i).scale = scale
		get_child(i).translation *= scale

#func split_mesh(node, _mass : int):
	#var body = Part.new()
	#body.mass = _mass
	#body.add_child(node)
	#get_parrent().add_child(node)
	
