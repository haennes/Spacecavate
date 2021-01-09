extends Spatial


var orbit_animation : Animation
var time : float = 0
export var seemslikeorbit : bool = false
export var AnimationPlayerchild = "AnimationPlayer"
var GravityObjects

##### Declare this in an Autoload later   (from)

var G = 0.6
var DISTANCE_THRESHHOLD : float = 2
var ANGLE_THRESHHOLD : Vector3 = Vector3(1,1,1)

##### Declare this in an Autoload later   (to)

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_init()
	update_GravityObjects()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func predict_till_closed_orbit(maxsteps : int, delta : float) -> void:
	var all_seem_closed : bool = false
	var steps : int = 0
	while !all_seem_closed && steps < maxsteps:
		steps += 1
		for i in GravityObjects.size():
			var a = Vector3.ZERO
			var GravityObject_i : Sattelite = GravityObjects[i]
			var pos_i : Vector3 = GravityObject_i.position_array[-1]
			var v_i : Vector3 = GravityObject_i.velocity
			for ii in GravityObjects.size():
				var GravityObject_ii : Sattelite = GravityObjects[ii]
				var pos_ii : Vector3 = GravityObject_ii.position_array[-1]
				var direction = pos_i.direction_to(pos_ii)
				a+= G*GravityObject_ii.mass / pos_i.distance_squared_to(pos_ii) * direction
			GravityObject_i.posn = pos_i + a/2 * delta *delta + v_i * delta
			GravityObject_i.velocity = a * delta
		for i in GravityObjects.size():
			var GravityObject_i : Sattelite = GravityObjects[i]
			GravityObject_i.position_array.append(GravityObject_i.posn)
			var pos_i_first : Vector3 = GravityObject_i.position_array[0]
			var pos_i_now : Vector3 = GravityObject_i.position_array[-1]
			var pos_i_last : Vector3 = GravityObject_i.position_array[-2]
			is_closed(pos_i_first,pos_i_last,pos_i_now,DISTANCE_THRESHHOLD,ANGLE_THRESHHOLD)
			


func is_closed(pos1 : Vector3, pos2 : Vector3, pos_to_check : Vector3 , distance_threshold : float, angle_threshold : Vector3):
	var direction = pos1.direction_to(pos2)
	if (direction - pos1.direction_to(pos_to_check)).abs() <= angle_threshold:
		var distance_pos1_pos2 = pos1.distance_to(pos2)                 #distance
		var distance_postochek_pos1 = pos_to_check.distance_to(pos2)    #distance2
		var distance_postocheck_pos2 = pos_to_check.distance_to(pos2)   #distance3
		if distance_postochek_pos1 <= distance_pos1_pos2 + distance_threshold && distance_postocheck_pos2 <= distance_pos1_pos2 + distance_threshold:
			return true


func add_key_to_animation() -> void :
	for i in GravityObjects.size():
		var GravityObject : RigidBody = GravityObjects[i]
		for ii in GravityObjects.size():
			if ii == i:
				continue
			var GravityObject2 : RigidBody = GravityObjects[ii]
			var translation_difference := GravityObject.translation - GravityObject2.translation
			orbit_animation.track_insert_key(i,time,translation_difference)
			


func animation_init() -> void:
	orbit_animation = Animation.new()
	$AnimationPlayer.add_animation("orbit_animation",orbit_animation)
	update_tracks_GravityObjects()
	

func update_tracks_GravityObjects() -> void:
	update_GravityObjects()
	for i in GravityObjects.size():
		var GravityObject : RigidBody = GravityObjects[i]
		if orbit_animation.find_track(GravityObject.get_path()) == -1: # returns -1 if track cant be found
			orbit_animation.add_track(Animation.TYPE_TRANSFORM,i)
			orbit_animation.track_set_enabled(i,false)
			orbit_animation.track_set_path(i,String(get_path_to(GravityObject))+":translation")
			print("updated orbitanimation GravityObjects sucessfully Track count: %s"%orbit_animation.get_track_count())


func update_GravityObjects() -> void:
	GravityObjects = get_tree().get_nodes_in_group("GravityEmitter")
