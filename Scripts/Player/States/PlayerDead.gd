extends State
class_name PlayerDead

@export var PlayerRef : Player

func OnEnter():
	print("YOU ARE DEAD...")
	GameSettings.UpdateInventory()
	#get_tree().get_first_node_in_group('Cameras').FadeToBlack(true, 5.0)
	PlayerRef.z_index = 3
	get_tree().get_first_node_in_group('Cameras').Spotlight(PlayerRef.position)
	var XPTween = get_tree().create_tween()
	XPTween.tween_property(PlayerRef, "CurrentXP", 0, 1.5)
	PlayerRef.HitColl.set_deferred("disabled", "true")
