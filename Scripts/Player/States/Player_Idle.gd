extends State
class_name Player_Idle

@export var PlayerRef : Player

func Update(_delta : float):
	match PlayerRef.CurrentDirection:
		0:
			PlayerRef.AnimPlayer.play("Idle_Up")
		1:
			PlayerRef.AnimPlayer.play("Idle_Down")
		2:
			PlayerRef.AnimPlayer.play("Idle_Left")
		3:
			PlayerRef.AnimPlayer.play("Idle_Right")
	
	if PlayerRef.IsDead == false:
		if PlayerRef.IsMoving:
			Transitioned.emit("Player_Move")
	
		if Input.is_action_just_pressed("Attack") && PlayerRef.CooldownTimer.is_stopped():
			Transitioned.emit("Player_Attack")
