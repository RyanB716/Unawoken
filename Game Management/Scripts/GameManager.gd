extends Node

@onready var PlayerRef : Player

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PlayerRef = get_tree().get_first_node_in_group("Player")
	
	var newPos = Vector2(GameSettings.CurrentStatue.global_position.x, GameSettings.CurrentStatue.global_position.y + 25)
	PlayerRef.global_position = newPos
	print(GameSettings.CurrentStatue.global_position)

func _process(_delta):
	if PlayerRef.CurrentHealth <= 0:
		get_tree().reload_current_scene()

