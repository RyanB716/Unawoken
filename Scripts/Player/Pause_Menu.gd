extends ColorRect
class_name PauseMenuController

@onready var Music : AudioStreamPlayer = $MusicPlayer

@onready var yMax : int
@onready var xMax : int

func _ready():
	visible = false
	size = Vector2(0, get_viewport().size.y)
	xMax = get_viewport().size.x
	yMax = get_viewport().size.y

func _process(delta):
	if !Music.playing && visible == true:
		Music.play()

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
	var RNG = RandomNumberGenerator.new()
	var playPoint = RNG.randf_range(0.1, Music.stream.get_length())
	Music.pitch_scale = 0.1
	Music.play(playPoint)
	mTween.tween_property(Music, "pitch_scale", 1.0, 0.75)

func StopMusic():
	var mTween = get_tree().create_tween()
	mTween.tween_property(Music, "pitch_scale", 0.1, 0.50)
	await mTween.finished
	Music.stop()
