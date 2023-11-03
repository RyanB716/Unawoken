extends BasicEnemy

@onready var AnimPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D

var PlayerTarget : Player

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta):
	move_and_slide()
	
	if velocity.length() > 0:
		AnimPlayer.play("Skeleton_Walk")
		if velocity.x >= 0.01:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
