extends Camera2D

@onready var Target : CharacterBody2D

@export var CamSpeed : float

@onready var IsShaking = false
@onready var RNG = RandomNumberGenerator.new()
@onready var ShakeStrength : float
@onready var ShakeTime : float

func _ready():
	Target = get_tree().get_first_node_in_group("Player")
	position = Target.position

func _physics_process(delta):
	self.position = lerp(self.position, Target.position, CamSpeed * delta)

	if IsShaking:
		ShakeStrength = lerp(ShakeStrength, 0.0, ShakeTime * delta)
		self.offset = GetRandomVector()

func ApplyShake(Strength : float, Duration : float):
	IsShaking = true
	ShakeStrength = Strength
	ShakeTime = Duration
	await get_tree().create_timer(Duration).timeout
	IsShaking = false

func GetRandomVector() -> Vector2:
	var newOffset : Vector2 = Vector2.ZERO
	newOffset.x = RNG.randf_range(-ShakeStrength, ShakeStrength)
	newOffset.y = RNG.randf_range(-ShakeStrength, ShakeStrength)
	return newOffset
