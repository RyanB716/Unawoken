extends State
class_name Player_Move

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer

func Update(_delta : float):
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Run_Up")
		1:
			AnimPlayer.play("Run_Down")
		2:
			AnimPlayer.play("Run_Left")
		3:
			AnimPlayer.play("Run_Right")
			
	
	if PlayerRef.SFXtime.time_left <= 0 && PlayerRef.velocity.length() > 0.01:
			PlayerRef.BodyAudio.PlayStep()
			PlayerRef.SFXtime.start(0.45)

	if !PlayerRef.IsMoving:
		Transitioned.emit("Player_Idle")
	
	if Input.is_action_just_pressed("Attack") && PlayerRef.CooldownTimer.is_stopped():
		Transitioned.emit("Player_Attack")
		
	if Input.is_action_just_pressed("Roll") && (PlayerRef.CurrentStaminaActions - 2 >= 0):
		Transitioned.emit("Roll")
