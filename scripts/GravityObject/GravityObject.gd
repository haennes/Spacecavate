extends RigidBody

##### Declare this in an Autoload later   (from)

var G := 6.0 # this is nonsense rn sorry

##### Declare this in an Autoload later   (to)

### positions ###
var posn : Vector3 = Vector3.ZERO  # the next position
var position_array : Array = []

### velocity ###
var velocity : Vector3 = Vector3.ZERO
export var starting_velocity := Vector3(0,0,0)

### Debug ###


export var affected_by_gravity := true
var atmosphere_thickness_curve := Curve2D.new()
var atmosphere_color_curve := Curve2D.new()


func _ready():
	print(0.000000667)
	add_to_group("gravity_objects")
	set_velocity(starting_velocity)
	if !affected_by_gravity:
		mode = MODE_STATIC
	position_array.append(self.translation)




func _integrate_forces(state) -> void :
	_integrate_gravity(state)


func set_velocity(velocity : Vector3) -> void :
	apply_central_impulse(mass*velocity)
	self.velocity = velocity


func _physics_process(delta):
	pass


func _integrate_gravity(state) -> void :
	if mode != MODE_STATIC:
		var force = Vector3.ZERO
		var gravity_objects = get_tree().get_nodes_in_group("gravity_objects")
		for x in gravity_objects.size():
			var gravity_object : RigidBody = gravity_objects[x]
			if gravity_object == self:
				continue
			var direction = translation.direction_to(gravity_object.translation)
			var squaredistance = translation.distance_squared_to(gravity_object.translation)
			force += direction * G * gravity_object.mass * mass / squaredistance
			#print("x : %s dir : %s squaredistance : %s force : %s" % [x, direction, squaredistance, force])
		add_central_force(force)



func calculate_next_position(delta : float) -> void:
	var stringToPrint : String = ""
	if mode != MODE_STATIC:
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
	if mode != MODE_STATIC:
		position_array.append(posn)
		
		$Path.curve.add_point(posn)
		
		var multimeshinstance = get_parent().get_node("MultiMeshInstance")
		var trans = Transform(Basis(Vector3.UP,0),posn)
		multimeshinstance.multimesh.set_instance_transform(i,trans)
		
func is_closed(pos1 : Vector3, pos2 : Vector3, pos_to_check : Vector3 , distance_threshold : float, angle_threshold : Vector3):
	var direction = pos1.direction_to(pos2)
	if (direction - pos1.direction_to(pos_to_check)).abs() <= angle_threshold:
		var distance_pos1_pos2 = pos1.distance_to(pos2)                 #distance
		var distance_postochek_pos1 = pos_to_check.distance_to(pos2)    #distance2
		var distance_postocheck_pos2 = pos_to_check.distance_to(pos2)   #distance3
		if distance_postochek_pos1 <= distance_pos1_pos2 + distance_threshold && distance_postocheck_pos2 <= distance_pos1_pos2 + distance_threshold:
			return true
