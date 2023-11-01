extends Control

@onready var TitleBox = $"Title Container"
@onready var ButtonBox = $"Button Container"

@onready var TitleLetters = TitleBox.get_children()
@onready var ButtonList = ButtonBox.get_children()

func _ready():
	for i in range(TitleLetters.size()):
		TitleLetters[i].label_settings.set_font_color(Color.BLACK)
	
	for i in range(ButtonList.size()):
		ButtonList[i].visible = false
		ButtonList[i].mouse_filter = MOUSE_FILTER_IGNORE
	
	await get_tree().create_timer(1.5).timeout
	TitleFX()

func _process(delta):
	pass

func TitleFX():
	for i in range(TitleLetters.size()):
		var colorTween = get_tree().create_tween()
		colorTween.tween_property(TitleLetters[i].label_settings, "font_color", Color.WHITE, 0.5)
		await get_tree().create_timer(0.15).timeout
		
	for i in range(ButtonList.size()):
		ButtonList[i].visible = true
		ButtonList[i].mouse_filter = MOUSE_FILTER_STOP
		
		await get_tree().create_timer(0.25).timeout

func NewGame():
	print("Starting new game...")
	get_tree().change_scene_to_file("res://Game Management/GameManager.tscn")
	
func QuitGame():
	get_tree().quit()
