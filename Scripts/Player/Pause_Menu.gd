extends ColorRect
class_name PauseMenuController

@onready var Music : AudioStreamPlayer = $MusicPlayer
@onready var Title : Label = $Title

@onready var yMax : int
@onready var xMax : int

var nextPoint : float

func _ready():
	visible = false
	self.set_deferred("size", Vector2(0, get_viewport().size.y))
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
	mTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	Music.pitch_scale = 0.1
	Music.play(nextPoint)
	mTween.tween_property(Music, "pitch_scale", 1.0, 1)

func StopMusic():
	var mTween = get_tree().create_tween()
	mTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	mTween.tween_property(Music, "pitch_scale", 0.1, 0.50)
	await mTween.finished
	Music.stop()
	GetNextPoint()
