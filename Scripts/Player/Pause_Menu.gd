extends ColorRect
class_name PauseMenuController

@onready var Music : AudioStreamPlayer = $MusicPlayer

@onready var yMax : int
@onready var xMax : int

var nextPoint : float

func _ready():
	visible = false
	size = Vector2(0, get_viewport().size.y)
	xMax = get_viewport().size.x
	yMax = get_viewport().size.y
	GetNextPoint()

func _process(delta):
	if !Music.playing && visible == true:
		Music.play()

func GetNextPoint():
	var RNG = RandomNumberGenerator.new()
	nextPoint = RNG.randf_range(0.1, Music.stream.get_length())
	
func EnableChildren():
	for i in get_child_count():
		if get_child(i).has_signal("visibility_changed"):
			get_child(i).visible = true

func DisableChildren():
	for i in get_child_count():
		if get_child(i).has_signal("visibility_changed"):
			get_child(i).visible = false
		
func StartMusic():
	var mTween = get_tree().create_tween()
	var vTween = get_tree().create_tween()
	Music.pitch_scale = 0.1
	Music.volume_db = -50
	Music.play(nextPoint)
	mTween.tween_property(Music, "pitch_scale", 1.0, 0.75)
	vTween.tween_property(Music, "volume_db", -10, 0.25)

func StopMusic():
	var mTween = get_tree().create_tween()
	var vTween = get_tree().create_tween()
	mTween.tween_property(Music, "pitch_scale", 0.1, 0.50)
	vTween.tween_property(Music, "volume_db", -50, 0.50)
	await mTween.finished
	Music.stop()
	GetNextPoint()
