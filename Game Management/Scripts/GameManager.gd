extends Node
class_name GameManager

signal HitNewTier(percent : float)

@onready var PlayerRef : Player
@onready var Cam : MC
@onready var Level : LevelController

@onready var Anxiety : float = 0
@onready var FillTween : Tween
@onready var TimeTween : Tween

@export var FillTime : float
@onready var FillTimeInSeconds : float

@onready var SignalTimer : Timer = $"Signal Timer"

var ElapsedTime : float

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
	
	FillTimeInSeconds = snapped((FillTime * 60), 0.01)
	StartFill()
	
func _process(delta):
	Anxiety = snapped(Anxiety, 0.01)
	
	if SignalTimer != null && SignalTimer.is_stopped():
		if Anxiety == 0.25:
			print("Launching signal for 25%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 0.5:
			print("Launching signal for 50%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 0.75:
			print("Launching signal for 75%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 1.00:
			print("Launching signal for 100%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.queue_free()

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
	TimeTween = get_tree().create_tween()
	FillTween = get_tree().create_tween()
	print("\nStarting Anxiety fill: " + str(Anxiety) + " will be 100% in: " + str(FillTimeInSeconds) + " seconds / " + str(snapped(FillTime, 0.01)) + " minutes")
	FillTween.tween_property(self, "Anxiety", 1, FillTimeInSeconds)
	TimeTween.tween_property(self, "FillTimeInSeconds", 0, FillTime)

func RestartAnxietyFill(time : float, amount : float):
	FillTween.stop()
	TimeTween.stop()
	amount *= 0.01
	if Anxiety - amount <= 0.0:
		Anxiety = 0
	else:
		Anxiety -= amount
	print("Anxiety: " + str(Anxiety))
	var FillPercentage : float = snapped((Anxiety / 1.00), 0.01)
	var NewTime : float = FillTime - (FillTime * FillPercentage)
	print("Fill: " + str(FillPercentage) + " // New Time: Seconds: " + str(NewTime * 60) + " Minutes: " + str(NewTime))
	FillTime = NewTime
	FillTimeInSeconds = NewTime * 60
	HitNewTier.emit(Anxiety)
	StartFill()
