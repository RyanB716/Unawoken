extends Area2D

@export var ParentRef : BasicEnemy

func TakeDamage(DMG : int):
	ParentRef.CurrentHealth = ParentRef.CurrentHealth - DMG
	print(ParentRef.CurrentHealth)
