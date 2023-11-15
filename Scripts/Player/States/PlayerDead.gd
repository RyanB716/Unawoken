extends State
class_name PlayerDead

@export var PlayerRef : Player

func OnEnter():
	print("YOU ARE DEAD...")
	PlayerRef.EnvColl.disabled = true
	PlayerRef.HitColl.disabled = true
