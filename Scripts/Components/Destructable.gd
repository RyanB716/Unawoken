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
	call_deferred("DisableColliders")
	RNG.randomize()
	var index = RNG.randi_range(1, BreakSFX.size())
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = BreakSFX[index - 1]
	NewPlayer.play()
	await NewPlayer.finished
	self.get_parent().queue_free()
	
func DisableColliders():
	get_child(0).disabled = true
	get_parent().find_child("CollisionShape2D").disabled = true

func PlayHitSFX():
	RNG.randomize()
	var index = RNG.randi_range(1, HitSFX.size())
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = HitSFX[index - 1]
	NewPlayer.play()
	await NewPlayer.finished
	NewPlayer.queue_free()
