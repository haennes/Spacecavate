extends VSplitContainer

signal add_part(button_pressed)
signal Tree_button_pressed(item, column, id)
signal Tree_item_selected()


func _on_AddPartButton_toggled(button_pressed):
	emit_signal("add_part",button_pressed)


func _on_Tree_button_pressed(item, column, id):
	emit_signal("Tree_button_pressed", item, column, id)


func _on_Tree_item_selected():
	emit_signal("Tree_item_selected")
