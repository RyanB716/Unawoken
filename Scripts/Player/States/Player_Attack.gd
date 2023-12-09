extends State
class_name Player_Attack

@export var PlayerRef : Player

func OnEnter():
	#print("Index: " + str(PlayerRef.CurrentAttackIndex))
	#print("Index after attack: " + str(PlayerRef.CurrentAttackIndex + 1))
	
	if !PlayerRef.AttackTimer.is_stopped():
			PlayerRef.AttackTimer.stop()
			
	PlayerRef.BodyAudio.PlaySFX()
	
	await get_tree().create_timer(PlayerRef.InputBufferAmnt).timeout
	var PreviousSpeed = PlayerRef.TopSpeed
	PlayerRef.TopSpeed = PlayerRef.TopSpeed * 0.5
	
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
	
	PlayerRef.WeaponAudio.PlaySFX()
	await PlayerRef.AnimPlayer.animation_finished
	
	PlayerRef.TopSpeed = PreviousSpeed
	
	if PlayerRef.CurrentAttackIndex == PlayerRef.MaxAttackNumber:
		PlayerRef.AttackCooldown()
		PlayerRef.ReduceStamina(1)
		PlayerRef.ResetStamina(1)
	
	elif PlayerRef.CurrentAttackIndex < PlayerRef.MaxAttackNumber:
		PlayerRef.AttackTimer.start(PlayerRef.AttackTime)
		
	PlayerRef.UI.AttackIcons.TakeAwayIndicators(1)
	
	PlayerRef.CurrentAttackIndex += 1
	Transitioned.emit("Player_Idle")
