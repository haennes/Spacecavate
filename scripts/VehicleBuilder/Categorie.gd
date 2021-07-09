extends VBoxContainer

func _on_Categorie_toggled(button_pressed):
	get_node("VBoxContainer").visible = !button_pressed
