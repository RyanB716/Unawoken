extends Panel
class_name Statue_Menu

var CurrentStatue : Statue

@export_category("Audio")
@export var Audio : AudioStreamPlayer

@export var InSFX : AudioStream
@export var OutSFX : AudioStream
@export var Click : AudioStream

@export_category("Buttons")
@export var YesBtn : Button
@export var NoBtn : Button

@onready var player : Player = get_tree().get_first_node_in_group('Player')
func _on_visibility_changed():
	if visible == true:
		Audio.stream = InSFX
		Audio.play()
		await get_tree().create_timer(0.25).timeout
		YesBtn.grab_focus()

func _on_yes_pressed():
	get_tree().get_first_node_in_group('Cameras').FadeToBlack(true, 3.0)
	print("Beginning respawn!")
	GameSettings.CurrentPlayerXP = player.CurrentXP
	print("-XP set")
	
	GameSettings.UpdateInventory()
	
	await get_tree().create_timer(3.0).timeout
	
	get_tree().get_first_node_in_group('Player').RegainFULLHealth()
	get_tree().reload_current_scene()

func _on_no_pressed():
	self.visible = false
	Audio.stream = OutSFX
	Audio.play()

func PlayClick():
	Audio.stream = Click
	Audio.play()
