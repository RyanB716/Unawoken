extends Node

@onready var PlayerRef : Player

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PlayerRef = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	if PlayerRef.CurrentHealth <= 0:
		get_tree().reload_current_scene()

func HitStop(EffectTime : float):
	get_tree().paused = true
	await get_tree().create_timer(EffectTime).timeout
	get_tree().paused = false
