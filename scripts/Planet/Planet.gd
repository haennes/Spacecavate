extends RigidBody

##### Declare this in an Autoload later   (from)

var G = 0.6

##### Declare this in an Autoload later   (to)


var atmospherethicknesscurve := Curve2D.new()
var atmospherecolorcurve := Curve2D.new()



func _ready():
	add_to_group("GravityObjects",true)   #persistant option is for saving the scene 



func _integrate_forces(state):
	
	var force = Vector3(0,0,0)
	var GravityObjects = get_tree().get_nodes_in_group("GravityObjects")
	for x in GravityObjects.size():
		var GravityObject : RigidBody = GravityObjects[x]
		if GravityObject == self:
			continue
		var direction = translation.direction_to(GravityObject.translation)
		var squaredistance = translation.distance_squared_to(GravityObject.translation)
		force = direction*G*GravityObject.mass*mass / squaredistance
		print("x : "+String(x)+ "dir : "+String(direction)+"squaredistance : "+String(squaredistance)+ "force : "+String(force))
	add_central_force(force)
