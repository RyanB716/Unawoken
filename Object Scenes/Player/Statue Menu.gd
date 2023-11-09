extends Panel
class_name Statue_Menu

var CurrentStatue : Statue

func _on_visibility_changed():
	await get_tree().create_timer(0.5).timeout
	$HBoxContainer/Yes.grab_focus()

func _on_yes_pressed():
	get_tree().reload_current_scene()

func _on_no_pressed():
	self.visible = false
