extends ColorRect
class_name PauseMenuController

@onready var Music : AudioStreamPlayer = $MusicPlayer
@onready var SFX : AudioStreamPlayer = $SFX
@onready var ButtonSFX : AudioStreamPlayer = $ButtonSFX
@onready var Title : Label = $Title
@onready var Location : HBoxContainer = $Location

@onready var UI : PlayerUI = get_parent()

@onready var yMax : int
@onready var xMax : int

@onready var PromptMessage : String
@onready var PromptField : Label = $Prompt

@onready var RNG = RandomNumberGenerator.new()

@onready var ButtonBox : HBoxContainer = $Buttons

@onready var ButtonArray : Array[Button]

@export var NameSFX : AudioStream
@export var WriteSFX : AudioStream
@export var HighlightSFX : AudioStream

var nextPoint : float

func _ready():
	visible = false
	self.set_deferred("size", Vector2(0, get_viewport().size.y))
	xMax = get_viewport().size.x
	yMax = get_viewport().size.y
	DeleteName()
	GetNextPoint()
	PromptField.visible_characters = 0
	
	ButtonArray.append($Resume)
	$Resume.visible = false
	for i in ButtonBox.get_child_count():
		ButtonArray.append(ButtonBox.get_child(i))
		ButtonBox.get_child(i).visible = false

func _process(delta):
	if !Music.playing && visible == true:
		Music.play()
		
	PromptMessage = GameSettings.CurrentPrompt
	PromptField.text = PromptMessage

func GetNextPoint():
	var RNG = RandomNumberGenerator.new()
	nextPoint = RNG.randf_range(0.1, Music.stream.get_length() - 1.0)
	
func EnableChildren():
	PromptField.visible_characters = 0
	SFX.volume_db = 0
	ButtonSFX.volume_db = 0
	
	for i in get_child_count():
		if get_child(i).has_signal("visibility_changed"):
			get_child(i).visible = true
			
	$Resume.visible = false
	for i in ButtonBox.get_child_count():
		ButtonBox.get_child(i).visible = false

func DisableChildren():
	SFX.volume_db = -50
	ButtonSFX.volume_db = -50
	
	$Resume.visible = false
	
	for i in ButtonBox.get_child_count():
		ButtonBox.get_child(i).visible = false
	
	for i in get_child_count():
		if get_child(i).has_signal("visibility_changed"):
			get_child(i).visible = false
			
	PromptField.visible_characters = 0

func StartMusic():
	var mTween = get_tree().create_tween()
	mTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	Music.pitch_scale = 0.1
	Music.play(nextPoint)
	mTween.tween_property(Music, "pitch_scale", 1.0, 1)

func StopMusic():
	var mTween = get_tree().create_tween()
	mTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	mTween.tween_property(Music, "pitch_scale", 0.1, 0.50)
	await mTween.finished
	Music.stop()
	GetNextPoint()

func DrawLocationName(location : String):
	#print("Location Name is: " + str(location))
	var NumOfChar : int = location.length()
	#print("It has: " + str(NumOfChar) + " characters!")
	
	SFX.stream = NameSFX
	
	var CharArray : Array[String]
	for i in NumOfChar:
		CharArray.append(location[i])
		var newLabel = Label.new()
		newLabel.label_settings = load("res://Content/Objects/UI/Pause_Menu_NameSettings.tres")
		Location.add_child(newLabel)
	
	#print("Location now has: " + str(Location.get_child_count()) + " children!")
	#print("CharArray now has: " + str(CharArray.size()) + " elements!")
	#print(CharArray)

	RNG.randomize()
	
	for i in CharArray.size():
		if !visible:
			return
		Location.get_child(i).text = CharArray[i]
		SFX.pitch_scale = RNG.randf_range(0.25, 1.5)
		SFX.play()
		await get_tree().create_timer(RNG.randf_range(0.05, 0.1)).timeout
		SFX.stop()
	
	await get_tree().create_timer(0.25).timeout
	SFX.stream = HighlightSFX
	SFX.pitch_scale = 0.75
	for i in ButtonBox.get_child_count():
		if !visible:
			return
		ButtonBox.get_child(i).visible = true
		SFX.pitch_scale += 0.15
		SFX.play()
		await get_tree().create_timer(0.25).timeout
	
	if visible:
		await get_tree().create_timer(0.35).timeout
		$Resume.visible = true
		$Resume.grab_focus()
	
		await get_tree().create_timer(0.25).timeout
		DrawPrompt()

func DrawPrompt():
	SFX.stream = WriteSFX
	SFX.pitch_scale = 1.0
	SFX.volume_db = 5.0
	
	for i in PromptMessage.length():
		if visible:
			PromptField.visible_characters += 1
			SFX.play(RNG.randf_range(0.5, WriteSFX.get_length() - 0.5))
			await get_tree().create_timer(RNG.randf_range(0.025, 0.05)).timeout
			SFX.stop()
		
	SFX.stop()
	SFX.volume_db = 0
	
func PlayHighlightSFX():
	ButtonSFX.play()

func DeleteName():
	for i in Location.get_child_count():
		Location.get_child(i).queue_free()

func ResumeGame():
	self.get_parent().TogglePauseMenu()

func QuitToMenu():
	self.get_parent().TogglePauseMenu()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Game Management/Scenes/Menus/MainMenu.tscn")

func ToCollection():
	print("Bringing up Collection Menu")
	await UI.Transition.PlayTransition()
	UI.Collection.Open()
