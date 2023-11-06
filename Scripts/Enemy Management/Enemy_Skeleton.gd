extends BasicEnemy

@onready var AnimPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

@onready var AttackSFX = $AudioStreamPlayer

var PlayerTarget : Player

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	
	CurrentHealth = MaxHealth

func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() > 0:
		if velocity.x >= 0.01:
			AnimPlayer.play("Skeleton_Walk_R")
		else:
			AnimPlayer.play("Skeleton_Walk_L")
