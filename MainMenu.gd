extends Control

@onready var TitleBox = $"Title Container"

@onready var TitleLetters = TitleBox.get_children()

func _ready():
	for i in range(TitleLetters.size()):
		TitleLetters[i].label_settings.set_font_color(Color.BLACK)
	
	await get_tree().create_timer(3).timeout
	TitleFX()

func _process(delta):
	pass

func TitleFX():
	for i in range(TitleLetters.size()):
		var colorTween = get_tree().create_tween()
		colorTween.tween_property(TitleLetters[i].label_settings, "font_color", Color.WHITE, 0.5)
		await get_tree().create_timer(0.15).timeout
