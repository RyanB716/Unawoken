extends Node
class_name GameManager

@onready var PlayerRef : Player
@onready var Cam : MC
@onready var Level : LevelController

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	PlayerRef = $Player
	Cam = $MainCamera
	
	if get_child(0) is LevelController:
		Level = get_child(0)
	
	if GameSettings.RespawnPoint != Vector2.ZERO:
		PlayerRef.position = Vector2(GameSettings.RespawnPoint.x, (GameSettings.RespawnPoint.y + 25))
		print("Spawn Position: " + str(PlayerRef.position))
		get_tree().get_first_node_in_group("Cameras").position = PlayerRef.position
		
	for i in Level.Destructables.size():
		Level.Destructables[i].CallScreenShake.connect(Cam.ApplyShake)

func HitStop(EffectTime : float):
	get_tree().paused = true
	await get_tree().create_timer(EffectTime).timeout
	get_tree().paused = false
