extends CanvasLayer
class_name UI

@onready var player : Player

@export var HealthBar : ProgressBar
@export var AttackIndicatorBox : Attack_Indicators

func _ready():
	player = get_parent()
	HealthBar.max_value = player.MaxHealth
	player.UpdateIcons.connect(AttackIndicatorBox.UpdateIcons)

func _process(delta):
	HealthBar.value = player.CurrentHealth
