extends Control
var current_scene
export(NodePath) var tree
export(NodePath) var root_spatial
export (NodePath) var camera

func _ready():
	tree = get_node(tree)
	root_spatial = get_node(root_spatial)
	_open_scene("res://scenes/Rocket/Rocket.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _open_scene(path : String):
	current_scene = load(path)
	var current_node = current_scene.instance()
	root_spatial.add_child(current_node)
	tree.create_item()
	_add_childs_to_tree(root_spatial.get_child(0))

func _add_childs_to_tree(parent):
	for i in parent.get_children():
		if "RigidBody" == i.get_class(): # I think this should be done using a group
			var item = tree.create_item(parent)
			item.set_text(0,i.name)




func _input(event):
	print("Input")
	if event is InputEventMouse:
		get_node(camera)._input_pass_through(event)
