extends Area2D
class_name DestructableObject

@export_category("Data Variables")
@export var NeededHits : int

@export_category("Aesthetic Variables")
@export var HitSFX = []
@export var BreakSFX = []

var CurrentHits : int

@onready var RNG = RandomNumberGenerator.new()

func _ready():
	CurrentHits = 0

func Destroy():
	self.get_parent().visible = false
	self.get_parent().get_node("CollisionShape2D").queue_free()
	RNG.randomize()
	var index = RNG.randi_range(0, BreakSFX.size() - 1)
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = BreakSFX[index]
	NewPlayer.play()
	await NewPlayer.finished
	self.get_parent().queue_free()

func PlayHitSFX():
	print("Playing hit")
	RNG.randomize()
	var index = RNG.randi_range(0, HitSFX.size() - 1)
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = HitSFX[index]
	NewPlayer.play()
	await NewPlayer.finished
	NewPlayer.queue_free()
