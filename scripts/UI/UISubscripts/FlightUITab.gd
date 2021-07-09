extends Tabs


export var Mesh_to_rotate : NodePath
var Mesh_to_rotate_path

# Called when the node enters the scene tree for the first time.
func _ready():
	Mesh_to_rotate_path = get_node(Mesh_to_rotate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	pass
