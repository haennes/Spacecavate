extends VBoxContainer

func _on_ExpandButton_toggled(button_pressed):
	get_node("MarginContainer").visible = !button_pressed
	print("buttontest")
