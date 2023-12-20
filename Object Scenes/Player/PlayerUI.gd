extends CanvasLayer
class_name PlayerUI

@onready var player : Player

@export var HealthBar : ProgressBar
@export var AttackIndicatorBox : IndicatorBox
@export var StaminaIndicatorBox : IndicatorBox

func _ready():
	player = get_parent()
	HealthBar.max_value = player.MaxHealth

func _process(delta):
	HealthBar.value = player.CurrentHealth
	
func UpdateAttackIcons(Amount : int):
	for i in AttackIndicatorBox.get_child_count():
		AttackIndicatorBox.get_child(i).queue_free()
	
	for i in Amount:
		var newIcon = AttackIndicatorBox.Icon.instantiate()
		AttackIndicatorBox.add_child(newIcon)
		
func SetStaminaIcons(Amount : int):
	for i in StaminaIndicatorBox.get_child_count():
		StaminaIndicatorBox.get_child(i).queue_free()
	
	for i in Amount:
		var newIcon = StaminaIndicatorBox.Icon.instantiate()
		StaminaIndicatorBox.add_child(newIcon)

func UpdateStaminaIcons(Amount : int):
	var icons = StaminaIndicatorBox.get_children()
	
	for i in icons.size():
		if i > Amount - 1:
			icons[i].IsFilled = false
			
func RefillStaminaIcons(Amount : int):
	for i in Amount:
		if StaminaIndicatorBox.get_child(i).IsFilled == false:
			StaminaIndicatorBox.get_child(i).IsFilled = true
