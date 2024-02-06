extends Node
class_name GameManager

@onready var PlayerRef : Player
@onready var Cam : MC
@onready var Level : LevelController

@onready var Anxiety : float = 0
@onready var FillTween : Tween
@export var FillTimeInMinutes : float

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	PlayerRef = $Player
	Cam = $MainCamera
	
	PlayerRef.PlayerDied.connect(PlayerDeath)
	PlayerRef.PlayerHit.connect(HitStop)
	
	if get_child(0) is LevelController:
		Level = get_child(0)
	
	if GameSettings.RespawnPoint != Vector2.ZERO:
		PlayerRef.position = Vector2(GameSettings.RespawnPoint.x, (GameSettings.RespawnPoint.y + 25))
		print("Spawn Position: " + str(PlayerRef.position))
		get_tree().get_first_node_in_group("Cameras").position = PlayerRef.position
		
	for i in Level.Destructables.size():
		Level.Destructables[i].CallScreenShake.connect(Cam.ApplyShake)
		
	StartFill()

func HitStop(EffectTime : float):
	get_tree().paused = true
	Cam.ApplyShake(1, EffectTime)
	await get_tree().create_timer(EffectTime).timeout
	get_tree().paused = false
	
func CamShake(intensity : float, duration : float):
	Cam.ApplyShake(intensity, duration)

func PlayerDeath(location : Vector2):
	Cam.Spotlight(location)
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()

func StartFill():
	FillTween = get_tree().create_tween()
	var TimeTween = get_tree().create_tween()
	var realTime = FillTimeInMinutes * 60
	print("Starting Anxiety fill: " + str(Anxiety) + " will be 100 in: " + str(realTime) + " seconds / " + str(FillTimeInMinutes) + " minutes")
	FillTween.tween_property(self, "Anxiety", 100.0, realTime)
	TimeTween.tween_property(self, "FillTimeInMinutes", 0, realTime)

func RestartAnxietyFill(time : float, amount : float):
	FillTween.stop()
	FillTimeInMinutes += time
	
	var newValue : float
	if Anxiety - amount <= 0.00:
		newValue = 0
	else:
		newValue = Anxiety - amount
		
	var newValueTween = get_tree().create_tween()
	newValueTween.tween_property(self, "Anxiety", newValue, 0.5)
	await newValueTween.finished
	StartFill()
