extends HBoxContainer
class_name AttackIndicators

@export var Icon : PackedScene
@export var player : Player

func SetMaxIcons():
	for i in player.MaxAttackNumber:
		var newIcon = Icon.instantiate()
		add_child(newIcon)

func TakeAwayIndicators(amount : int):
	for i in amount:
		get_child(i).queue_free()
		
func AddIndicator(amount : int):
	for i in amount:
		var newIcon = Icon.instantiate()
		add_child(newIcon)
