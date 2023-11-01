extends Control

@onready var panel = $Panel

@onready var Presents = $Panel/Presents
@onready var Title = $Panel/Title
@onready var Year = $Panel/Year
@onready var PoemBox = $"Panel/Poem Container"
@onready var Book = $"Panel/Book title"
@onready var ContinueBtn = $Panel/Continue

@onready var Poems

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	var Assets = panel.get_children()
	
	for i in range(Assets.size()):
		Assets[i].visible = false
		
	Poems = PoemBox.get_children()
	
	for i in range(Poems.size()):
		Poems[i].label_settings.set_font_color(Color.BLACK)
	
	IntroFX()
	
func _process(delta):
	if ContinueBtn.visible:
		if Input.is_action_just_pressed("Attack") or Input.is_action_just_pressed("Roll") or Input.is_key_pressed(KEY_ENTER):
			get_tree().change_scene_to_file("res://Game Management/GameManager.tscn")
			
func IntroFX():
	await get_tree().create_timer(1.5).timeout
	Presents.visible = true
	await get_tree().create_timer(3.5).timeout
	Presents.visible = false
	await get_tree().create_timer(1.5).timeout
	Title.visible = true
	Year.visible = true
	await get_tree().create_timer(5).timeout
	Title.visible = false
	Year.visible = false
	await get_tree().create_timer(1.5).timeout
	PoemBox.visible = true
	for i in range(Poems.size()):
		var colorTween = get_tree().create_tween()
		colorTween.tween_property(Poems[i].label_settings, "font_color", Color.WHITE, 0.5)
		await get_tree().create_timer(2.5).timeout
	var colorTween = get_tree().create_tween()
	Book.visible = true
	colorTween.tween_property(Book.label_settings, "font_color", Color.WHITE, 0.5)
	await get_tree().create_timer(3).timeout
	ContinueBtn.visible = true
	ContinueBtn.get_node("AnimationPlayer").play("IdleAnim")
