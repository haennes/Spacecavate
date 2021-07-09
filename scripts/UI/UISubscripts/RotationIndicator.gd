extends ViewportContainer


export(NodePath) var mesh 

func _ready():
	mesh = get_node(mesh)
	
func rotation_changed(rotation : Vector3): #in radians
	mesh.rotation = rotation
