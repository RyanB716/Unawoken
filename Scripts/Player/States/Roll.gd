extends State
class_name Roll

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer
@export var BodyAudio : BodyAudioPlayer

func OnEnter():
	await get_tree().create_timer(PlayerRef.InputBufferAmnt).timeout
	PlayerRef.IsRolling = true
	BodyAudio.PlaySFX()
	PlayerRef.ReduceStamina(1)
	
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Roll")
		1:
			AnimPlayer.play("Roll")
		2:
			AnimPlayer.play("Roll")
		3:
			AnimPlayer.play("Roll")
			
	await AnimPlayer.animation_finished
	PlayerRef.IsRolling = false
	PlayerRef.ResetStamina(1)
	Transitioned.emit("Player_Idle")
