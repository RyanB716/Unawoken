extends State
class_name Roll

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer
@export var BodyAudio : AudioPlayer

func OnEnter():
	await get_tree().create_timer(0.12).timeout
	
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
	Transitioned.emit(self, "Player_Idle")
