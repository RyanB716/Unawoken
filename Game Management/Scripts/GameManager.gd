extends Node
class_name GameManager

@onready var PlayerRef : Player

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PlayerRef = get_tree().get_first_node_in_group("Player")
	
	if GameSettings.RespawnPoint != Vector2.ZERO:
		PlayerRef.position = Vector2(GameSettings.RespawnPoint.x, (GameSettings.RespawnPoint.y + 25))
		get_tree().get_first_node_in_group("Cameras").position = PlayerRef.position

func HitStop(EffectTime : float):
	get_tree().paused = true
	await get_tree().create_timer(EffectTime).timeout
	get_tree().paused = false
