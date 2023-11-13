extends BasicEnemy
class_name Moblin

@onready var AnimPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var AttackSFX = $AudioStreamPlayer

@onready var HealthBar = $ProgressBar

@onready var EnvironmentCollider = $EnvironmentCollider
@onready var HitBoxCollider = $HitBox/HitCollider
@onready var HurtBoxCollider = $HurtBox/HurtCollider

var PlayerTarget : Player

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
func _process(_delta):
	HealthBar.value = CurrentHealth

func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() > 0:
		if velocity.x >= 0.01:
			AnimPlayer.play("Walk_R")
		elif velocity.x <= -0.1:
			AnimPlayer.play("Walk_L")
		elif velocity.y >= 0.1:
			AnimPlayer.play("Walk_D")
		else:
			AnimPlayer.play("Walk_U")
