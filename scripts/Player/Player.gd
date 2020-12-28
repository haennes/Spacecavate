extends KinematicBody


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("move_forward"):
		pass
	elif event.is_action("move_backward"):
		pass
