extends ProgressBar
class_name AttackBarController

@onready var Particles : CPUParticles2D = $Partciles
@onready var IndexLabel : Label = $"Index Label"
#@onready var pStartingPos : Vector2 = Vector2(240, 10)

func _ready():
	IndexLabel.text = "Combo"
	Particles.emitting = false
	#Particles.position = pStartingPos
