extends HBoxContainer
class_name AttackIndicators

@export var Icon : PackedScene
@export var player : Player

func SetMaxIcons():
	for i in self.get_child_count():
		get_child(i).queue_free()
		
	for i in player.MaxAttackNumber:
		var newIcon = Icon.instantiate()
		add_child(newIcon)

func TakeAwayIndicators(amount : int):
	for i in amount:
		get_child(i).queue_free()
