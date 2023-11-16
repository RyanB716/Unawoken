extends State
class_name PlayerDead

@export var PlayerRef : Player

func OnEnter():
	print("YOU ARE DEAD...")
	var XPTween = get_tree().create_tween()
	XPTween.tween_property(PlayerRef, "CurrentXP", 0, 1.5)
	PlayerRef.EnvColl.disabled = true
	PlayerRef.HitColl.disabled = true
