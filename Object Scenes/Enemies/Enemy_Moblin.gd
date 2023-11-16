extends BasicEnemy
class_name Moblin

@onready var sprite = $Sprite2D

@onready var AttackSFX = $AudioStreamPlayer

@onready var HealthBar = $ProgressBar

@onready var EnvironmentCollider = $EnvironmentCollider
@onready var HitBoxCollider = $HitBox/HitCollider
@onready var HurtBoxCollider = $HurtBox/HurtCollider

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	AnimPlayer = $AnimationPlayer
	CurrentDirection = DirectionStates.Down
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
func _process(_delta):
	HealthBar.value = CurrentHealth
	
	if CurrentHealth <= 0 && IsDead == false:
		IsDead = true
		$StateMachine.CurrentState.Transitioned.emit("Dead")

func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() > 0 && IsAttacking == false:
		match CurrentDirection:
			0:
				AnimPlayer.play("Walk/Walk_U")
			1:
				AnimPlayer.play("Walk/Walk_D")
			2:
				AnimPlayer.play("Walk/Walk_L")
			3:
				AnimPlayer.play("Walk/Walk_R")
	else:
		if IsAttacking == false:
			match CurrentDirection:
				0:
					AnimPlayer.play("Idle/Idle_U")
				1:
					AnimPlayer.play("Idle/Idle_D")
				2:
					AnimPlayer.play("Idle/Idle_L")
				3:
					AnimPlayer.play("Idle/Idle_R")
