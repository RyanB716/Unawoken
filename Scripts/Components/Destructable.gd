extends Area2D
class_name DestructableObject

@export_category("Data Variables")
@export var NeededHits : int

@export_category("Aesthetic Variables")
@export var HitSFX : AudioStream
@export var BreakSFX : AudioStream

var CurrentHits : int

func _ready():
	CurrentHits = 0

func _process(delta):
	if CurrentHits == NeededHits:
		Destroy()

func Destroy():
	pass

func PlayHitSFX():
	print("Playing Hit")

func PlayBreakSFX():
	print("Playing Break")
