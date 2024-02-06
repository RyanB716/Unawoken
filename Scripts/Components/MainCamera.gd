extends Camera2D
class_name MC

@onready var Target : CharacterBody2D

@export var CamSpeed : float

@onready var Curtain = $CanvasLayer/Curtain
@onready var SpotLight = $CanvasLayer/Spotlight

@onready var IsShaking = false
@onready var RNG = RandomNumberGenerator.new()
@onready var ShakeStrength : float
@onready var ShakeTime : float

func _ready():
	$CanvasLayer/HBoxContainer/DeathPrompt1.visible = false
	$CanvasLayer/HBoxContainer/DeathPrompt2.visible = false
	SpotLight.visible = false
	Target = get_tree().get_first_node_in_group("Player")
	Curtain.color = Color.BLACK
	FadeToBlack(false, 3.0)

func _physics_process(delta):
	self.position = lerp(self.position, Target.position, CamSpeed * delta)

	if IsShaking:
		ShakeStrength = lerp(ShakeStrength, 0.0, ShakeTime * delta)
		self.offset = GetRandomVector()

#Applies variables to create shake effect
func ApplyShake(Strength : float, Duration : float):
	IsShaking = true
	ShakeStrength = Strength
	ShakeTime = Duration
	await get_tree().create_timer(Duration).timeout
	IsShaking = false

#Generates a random Vector2
func GetRandomVector() -> Vector2:
	var newOffset : Vector2 = Vector2.ZERO
	newOffset.x = RNG.randf_range(-ShakeStrength, ShakeStrength)
	newOffset.y = RNG.randf_range(-ShakeStrength, ShakeStrength)
	return newOffset

func FadeToBlack(yes : bool, duration : float):
	if yes:
		Curtain.color = Color(0, 0, 0, 0)
		var newColor = Color(0, 0, 0, 1)
		var newTween = get_tree().create_tween()
		newTween.tween_property(Curtain, "color", newColor, duration)
	else:
		Curtain.color = Color(0, 0, 0, 1)
		var newColor = Color(0, 0, 0, 0)
		var newTween = get_tree().create_tween()
		newTween.tween_property(Curtain, "color", newColor, duration)

func Spotlight(_location : Vector2):
	$CanvasLayer/HBoxContainer/DeathPrompt1.visible = true
	$CanvasLayer/HBoxContainer/DeathPrompt2.visible = true
	Curtain.visible = false
	SpotLight.visible = true
	var firstTween = get_tree().create_tween()
	firstTween.tween_property($CanvasLayer/HBoxContainer/DeathPrompt1.label_settings, "font_color", Color.WHITE, 1)
	var secondTween = get_tree().create_tween()
	secondTween.tween_property($CanvasLayer/HBoxContainer/DeathPrompt2.label_settings, "font_color", Color.WHITE, 1)
	await secondTween.finished
	var thirdTween = get_tree().create_tween()
	thirdTween.tween_property($CanvasLayer/HBoxContainer/DeathPrompt2.label_settings, "font_color",Color.RED, 4.0)
	await thirdTween.finished
