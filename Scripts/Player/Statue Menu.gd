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
@onready var game : GameManager = get_tree().get_first_node_in_group('GameManager')

func OpenMenu():
	if visible:
		player.CurrentState = player.eStates.InMenu
		Audio.stream = InSFX
		Audio.play()
		await get_tree().create_timer(0.25).timeout
		YesBtn.grab_focus()

func _on_yes_pressed():
	var camera : Node = get_tree().get_first_node_in_group('Cameras')
	camera.FadeToBlack(true, 3.0)
	await get_tree().create_timer(3.0).timeout
	#emit reload current level
	#emit_signal()
	#get_tree().reload_current_scene()
	game.reload_level()
	player.UI.ToggleMenu(player.UI.StatueMenu, false)
	camera.FadeToBlack(false, 3.0)

func _on_no_pressed():
	player.CurrentState = player.eStates.NoAction
	self.visible = false
	Audio.stream = OutSFX
	Audio.play()

func PlayClick():
	Audio.stream = Click
	Audio.play()
