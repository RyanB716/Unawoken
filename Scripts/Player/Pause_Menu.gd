extends ColorRect
class_name PauseMenuController

@onready var Music : AudioStreamPlayer = $MusicPlayer
@onready var SFX : AudioStreamPlayer = $SFX
@onready var Title : Label = $Title
@onready var Location : HBoxContainer = $Location

@onready var yMax : int
@onready var xMax : int

var nextPoint : float

func _ready():
	visible = false
	self.set_deferred("size", Vector2(0, get_viewport().size.y))
	xMax = get_viewport().size.x
	yMax = get_viewport().size.y
	DeleteName()
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

func DrawLocationName(location : String):
	print("Location Name is: " + str(location))
	var NumOfChar : int = location.length()
	print("It has: " + str(NumOfChar) + " characters!")
	
	var CharArray : Array[String]
	for i in NumOfChar:
		CharArray.append(location[i])
		var newLabel = Label.new()
		newLabel.label_settings = load("res://Content/Objects/UI/Pause_Menu_NameSettings.tres")
		Location.add_child(newLabel)
	
	print("Location now has: " + str(Location.get_child_count()) + " children!")
	print("CharArray now has: " + str(CharArray.size()) + " elements!")
	print(CharArray)
	
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	
	for i in CharArray.size():
		if visible:
			Location.get_child(i).text = CharArray[i]
			SFX.pitch_scale = RNG.randf_range(0.25, 1.5)
			SFX.play()
			await get_tree().create_timer(RNG.randf_range(0.05, 0.25)).timeout

func DeleteName():
	for i in Location.get_child_count():
		Location.get_child(i).queue_free()
