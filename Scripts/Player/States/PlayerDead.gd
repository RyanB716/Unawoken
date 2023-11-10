extends State
class_name PlayerDead

@export var PlayerRef : Player

func OnEnter():
	PlayerRef.IsDead = false
	print("Player is dead, reloading...")
