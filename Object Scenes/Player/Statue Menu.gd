extends Panel
class_name Statue_Menu

var CurrentStatue : Statue

@export var InSFX : AudioStream
@export var OutSFX : AudioStream
@export var Click : AudioStream

func _on_visibility_changed():
	if visible == true:
		$AudioStreamPlayer.stream = InSFX
		$AudioStreamPlayer.play()
		await get_tree().create_timer(0.25).timeout
		$HBoxContainer/Yes.grab_focus()

func _on_yes_pressed():
	pass

func _on_no_pressed():
	self.visible = false
	$AudioStreamPlayer.stream = OutSFX
	$AudioStreamPlayer.play()

func PlayClick():
	$AudioStreamPlayer.stream = Click
	$AudioStreamPlayer.play()
