extends State
class_name Roll

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer
@export var BodyAudio : AudioPlayer

func OnEnter():
	await get_tree().create_timer(PlayerRef.InputBufferAmnt).timeout
	
	BodyAudio.PlaySFX()
	PlayerRef.ReduceStamina(2)
	
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
	
	PlayerRef.ResetStamina(2)
	Transitioned.emit(self, "Player_Idle")
