extends State
class_name Player_Attack

@export var PlayerRef : Player

func OnEnter():
	PlayerRef.BodyAudio.PlaySFX()
	
	await get_tree().create_timer(PlayerRef.InputBufferAmnt).timeout
	
	if PlayerRef.CurrentAttackIndex <= 1 && PlayerRef.AttackTimer.is_stopped():
		match PlayerRef.CurrentDirection:
			0:
				PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Up")
			1:
				PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Down")
			2:
				PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Left")
			3:
				PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Right")
		
		PlayerRef.CurrentAttackIndex = 2
		
	else:
		
		match PlayerRef.CurrentAttackIndex:
			2:
				match PlayerRef.CurrentDirection:
					0:
						PlayerRef.AnimPlayer.play("Attack_2/Attack_2_Up")
					1:
						PlayerRef.AnimPlayer.play("Attack_2/Attack_2_Down")
					2:
						PlayerRef.AnimPlayer.play("Attack_2/Attack_2_Left")
					3:
						PlayerRef.AnimPlayer.play("Attack_2/Attack_2_Right")
						
				PlayerRef.CurrentAttackIndex = 3
			
			3:
				match PlayerRef.CurrentDirection:
					0:
						PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Up")
					1:
						PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Down")
					2:
						PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Left")
					3:
						PlayerRef.AnimPlayer.play("Attack_1/Attack_1_Right")
						
				PlayerRef.AttackCooldown()
				PlayerRef.ReduceStamina(1)
				PlayerRef.ResetStamina(1)
	
	
	PlayerRef.WeaponAudio.PlaySFX()
	await PlayerRef.AnimPlayer.animation_finished
	
	if PlayerRef.CurrentAttackIndex < 3:
		PlayerRef.AttackTimer.start(PlayerRef.AttackTime)
	
	Transitioned.emit(self, "Player_Idle")
