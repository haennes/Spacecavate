extends Control
export(NodePath) var tree
export(NodePath) var root_spatial
export (NodePath) var camera
export (Texture) var eye_texture
var root_item
var current_selected_item
var current_node_selected
enum select_mode  {LOAD_ROCKET, LOAD_PART}
var current_select_mode = select_mode.LOAD_PART


func _ready():
	tree = get_node(tree)
	current_node_selected = get_node(root_spatial)
	root_spatial = get_node(root_spatial)
	#open_rocket("res://scenes/Rocket/Rocket.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_node("WindowDialog").popup_centered_clamped(Vector2(500,500))
	root_item = tree.create_item()
	root_item.set_text(0,"Rocket")
	#item = get_node("HSplitContainer/HSplitContainer/PanelRight/VBoxContainer/VBoxContainer/VBoxContainer/MarginContainer/PanelContainer")
	#item.add_child(load("res://scenes/VehicleBuilder/TreeItemExpand.tscn").instance())

func open_rocket(path : String):
	var current_scene = load(path)
	var current_node = current_scene.instance()
	root_spatial.add_child(current_node)
	tree.create_item()
	_add_childs_to_tree(root_spatial.get_child(0))

func open_part(path : String, parent):
	var current_scene = load(path)
	var current_node = current_scene.instance()
	parent.add_child(current_node)
	current_node.mode = RigidBody.MODE_STATIC
	#print(current_node.mode)
	var item = tree.create_item(current_selected_item)
	item.set_text(0,current_node.name)
	item.add_button(0,eye_texture)


func _add_childs_to_tree(parent):
	for i in parent.get_children():
		if "RigidBody" == i.get_class(): # I think this should be done using a group
			var item = tree.create_item(parent)
			item.set_text(0,i.name)
			item.add_button(0,eye_texture)
			i.set_mode(RigidBody.MODE_STATIC)



func _input(event):
	#print("Input")
	if event is InputEventMouse:
		get_node(camera)._input_pass_through(event)
	if event.is_action_pressed("ESC"):
		change_mouse_mode()

func change_mouse_mode():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		


func _on_Tree_item_selected():
	current_selected_item = tree.get_selected()
	current_node_selected = root_spatial.get_node(get_path_to_node(current_selected_item,""))
	print(current_node_selected)

func _on_FileDialog_file_selected(path):
	if current_select_mode == select_mode.LOAD_ROCKET:
		print("loading rocket")
		open_rocket(path)
	elif current_select_mode == select_mode.LOAD_PART:
		open_part(path, current_node_selected)
		print("loading part")


func _on_PanelLeft_add_part(button_pressed):
	get_node("WindowDialog").popup_centered_clamped(Vector2(500,500))


func _on_PanelLeft_Tree_button_pressed(item, column, id):
	var path = get_path_to_node(item,"")
	print(path)
	var node = root_spatial.get_node("Rocket").get_node(path)
	node.visible = !node.visible
	
func get_path_to_node(item,current_path):
	var parent = item.get_parent()
	current_path = item.get_text(0) + "/" + current_path
	if parent == TreeItem:
		get_path_to_node(parent,current_path)
	else:
		return current_path.rstrip("/")
