extends Camera


export(NodePath) onready var target_body = get_node(target_body) as KinematicBody
export(float, 0, 2) var mouse_sensitivity := 1.0


func _unhandled_input(event: InputEvent) -> void:
