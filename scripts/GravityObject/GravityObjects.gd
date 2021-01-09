extends RigidBody

##### Declare this in an Autoload later   (from)

var G = 0.6

##### Declare this in an Autoload later   (to)

export var starting_velocity := Vector3(0,0,0)
var atmosphere_thickness_curve := Curve2D.new()
var atmosphere_color_curve := Curve2D.new()


func _ready():
	add_to_group("GravityEmitter")
	set_velocity(starting_velocity)
	




func _integrate_forces(state) -> void :
		_integrate_gravity(state)


func set_velocity(velocity : Vector3) -> void :
	apply_central_impulse(mass*velocity)
	
	
func _physics_process(delta):
	pass

func _integrate_gravity(state) -> void :
	var force = Vector3.ZERO
	var GravityObjects = get_tree().get_nodes_in_group("GravityEmitter")
	for x in GravityObjects.size():
		var GravityObject : RigidBody = GravityObjects[x]
		if GravityObject == self:
			continue
		var direction = translation.direction_to(GravityObject.translation)
		var squaredistance = translation.distance_squared_to(GravityObject.translation)
		force = direction * G * GravityObject.mass * mass / squaredistance
		print("x : %s dir : %s squaredistance : %s force : %s" % [x,direction,squaredistance,force])
	add_central_force(force)



