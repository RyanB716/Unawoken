extends State
class_name Player_Attack1

@export var PlayerRef : Player
@export var AnimPlayer : AnimationPlayer
@export var BodyAudio : AudioPlayer
@export var WeaponAudio : AudioPlayer

func OnEnter():
	BodyAudio.PlaySFX()
	
	await get_tree().create_timer(0.12).timeout
	
	match PlayerRef.CurrentDirection:
		0:
			AnimPlayer.play("Attack_1/Attack_1_Up")
		1:
			AnimPlayer.play("Attack_1/Attack_1_Down")
		2:
			AnimPlayer.play("Attack_1/Attack_1_Left")
		3:
			AnimPlayer.play("Attack_1/Attack_1_Right")
	
	WeaponAudio.PlaySFX()
	await AnimPlayer.animation_finished
	Transitioned.emit(self, "Player_Idle")
