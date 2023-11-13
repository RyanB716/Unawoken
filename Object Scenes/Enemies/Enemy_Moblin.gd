extends BasicEnemy
class_name Moblin

@onready var AnimPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

#@onready var AttackSFX = $AudioStreamPlayer

#@onready var HealthBar = $ProgressBar

@onready var EnvironmentCollider = $EnvironmentCollider
#@onready var HitBoxCollider = $HitBox/HitCollider
#@onready var HurtBoxCollider = $HurtBox/HurtCollider

var PlayerTarget : Player

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	
	CurrentHealth = MaxHealth
	#HealthBar.max_value = MaxHealth
	
func _process(_delta):
	pass
	#HealthBar.value = CurrentHealth

func _physics_process(_delta):
	move_and_slide()
