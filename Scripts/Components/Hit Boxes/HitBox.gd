extends Area2D
class_name HitBox

@export var SelfRef : CharacterBody2D
@export var ImpactSFX  = []

func _ready():
	#Sets Area2D to be active on startup
	if self.get_child(0).disabled == true:
		self.get_child(0).disabled = false

#Instantly reduces health of the target
func TakeDamage(Amnt : int):
	SelfRef.CurrentHealth -= Amnt

#Plays a random sfx upon collision and deletes it upon finishing
func PlaySFX():
	var RNG = RandomNumberGenerator.new()
	var index = RNG.randi_range(0, ImpactSFX.size() - 1)
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = ImpactSFX[index]
	NewPlayer.play()
	await NewPlayer.finished
	NewPlayer.queue_free()
