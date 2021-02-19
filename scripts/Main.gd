extends Spatial



# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	var gravity_emitters = get_tree().get_nodes_in_group("gravity_objects")
	print("processcalled")
	for i in 545:
		for b in gravity_emitters.size():
			gravity_emitters[b].calculate_next_position(0.01)
		for b in gravity_emitters.size():
			gravity_emitters[b].update_posarray(i)
	for b in gravity_emitters.size():
		var curve : Curve3D = gravity_emitters[b].get_node("Path").curve
		var pointsarray = []
		for point in curve.get_point_count():
			pointsarray.append(curve.get_point_position(point))
		print(pointsarray)
	set_physics_process(false)

