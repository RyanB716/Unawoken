extends State
class_name Player_Idle

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer

func Update(delta : float):
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Idle_Up")
		1:
			AnimPlayer.play("Idle_Down")
		2:
			AnimPlayer.play("Idle_Left")
		3:
			AnimPlayer.play("Idle_Right")
			
	if PlayerRef.IsMoving:
		Transitioned.emit(self, "Player_Move")
	
	if Input.is_action_just_pressed("Attack"):
		Transitioned.emit(self, "Player_Attack1")
