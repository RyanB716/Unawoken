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

enum DirectionStates {Up, Down, Left, Right}
var CurrentDirection : int

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	CurrentDirection = DirectionStates.Down
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
func _process(_delta):
	HealthBar.value = CurrentHealth

func _physics_process(_delta):
	move_and_slide()
	
	if $Raycasts/RayTimer.is_stopped():
		$Raycasts.SendRaycasts()
	
	if velocity.length() > 0:
		match CurrentDirection:
			0:
				AnimPlayer.play("Walk_U")
			1:
				AnimPlayer.play("Walk_D")
			2:
				AnimPlayer.play("Walk_L")
			3:
				AnimPlayer.play("Walk_R")
