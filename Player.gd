extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down")
	print(direction)
	if direction != Vector2(0,0):
		velocity = direction * SPEED
	else:
		velocity = Vector2(0, 0)

	move_and_slide()
	
	match direction:
		Vector2(0, 0):
			$AnimatedSprite2D.animation
