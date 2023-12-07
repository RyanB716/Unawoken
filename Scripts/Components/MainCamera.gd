extends Camera2D

@onready var Target : CharacterBody2D

@export var CamSpeed : float

@onready var IsShaking = false
@onready var RNG = RandomNumberGenerator.new()
@onready var ShakeStrength : float
@onready var ShakeTime : float

func _ready():
	Target = get_tree().get_first_node_in_group("Player")
	$CanvasLayer/ColorRect.color = Color.BLACK
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
		$CanvasLayer/ColorRect.color = Color(0, 0, 0, 0)
		var newColor = Color(0, 0, 0, 1)
		var newTween = get_tree().create_tween()
		newTween.tween_property($CanvasLayer/ColorRect, "color", newColor, duration)
	else:
		$CanvasLayer/ColorRect.color = Color(0, 0, 0, 1)
		var newColor = Color(0, 0, 0, 0)
		var newTween = get_tree().create_tween()
		newTween.tween_property($CanvasLayer/ColorRect, "color", newColor, duration)
