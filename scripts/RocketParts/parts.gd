extends GravityObject
class_name Part



func _ready():
	_register_all_joints(self)
	
func _register_all_joints(node) -> void:
	if node is Joint or ClassDB.is_parent_class(node.get_class(),"Joint"):
		node.add_to_group("Joints")

