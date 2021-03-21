class_name Engine
extends Part

var thrust_total = 30  #maximum thrust in Newtons
var thrust_percentage := 0.9
var on := false
var connected_tank

func _integrate_engine_thrust(state) -> void:
	var force : Vector3 = thrust_total * thrust_percentage * global_transform.basis.y * float(on)
	var offset : Vector3 = get_node("offset").translation
	add_force(force,offset)


func _integrate_forces(state):
	_integrate_engine_thrust(state)
	
func connect_tank(tank):
	connected_tank = tank

func toggle_engine():
	on = !on

func ignite_engine(percentage):
	on = true
	thrust_percentage = percentage

func cutoff_engine():
	on = false
