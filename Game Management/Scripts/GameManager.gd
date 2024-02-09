extends Node
class_name GameManager

signal AnxietyUpdate(percent : float)

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
	
	if get_child(0) is LevelController:
		Level = get_child(0)
	
	if GameSettings.RespawnPoint != Vector2.ZERO:
		PlayerRef.position = Vector2(GameSettings.RespawnPoint.x, (GameSettings.RespawnPoint.y + 25))
		print("Spawn Position: " + str(PlayerRef.position))
		get_tree().get_first_node_in_group("Cameras").position = PlayerRef.position
		
	for i in Level.Destructables.size():
		Level.Destructables[i].CallScreenShake.connect(Cam.ApplyShake)
		
	PlayerRef.PlayerDied.connect(PlayerDeath)
	PlayerRef.PlayerHit.connect(HitStop)
	AnxietyUpdate.connect(PlayerRef.AnxietyEffects)
	Level.AllowFill.connect(StartFill)
	
	FillTimeInSeconds = FillTime * 60
	
	if GameSettings.ShouldFillAnxiety == true:
		StartFill()
	
func _process(delta):
	var snappedAnxiety = snapped(Anxiety, 0.01)
	AnxietyUpdate.emit(snappedAnxiety)

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
	var newSFX = AudioStreamPlayer.new()
	newSFX.stream = load("res://Aesthetics/Audio/SFX/UI/AnxietyRelease.mp3")
	newSFX.volume_db = -10
	add_child(newSFX)
	newSFX.play()
	
	ElapsedTime = 0
	FillTimeInSeconds = FillTime * 60
	FillTween = get_tree().create_tween()
	print("\nStarting Anxiety fill: " + str(Anxiety) + " will be 100% in: " + str(FillTimeInSeconds) + " seconds / " + str(FillTime) + " minutes")
	$Timer.start(1.0)
	FillTween.tween_property(self, "Anxiety", 1.00, FillTimeInSeconds)
	await newSFX.finished
	newSFX.queue_free()

func RestartAnxietyFill(time : float, amount : float):
	$Timer.stop()
	FillTween.stop()
	
	amount *= 0.01
	if Anxiety - amount <= 0.0:
		Anxiety = 0
	else:
		Anxiety -= amount
		
		var newTime : float = FillTime * (1.0 - Anxiety)
		FillTime = newTime
		
	AnxietyUpdate.emit(Anxiety)
	StartFill()

func _on_timer_timeout():
	ElapsedTime += 1
