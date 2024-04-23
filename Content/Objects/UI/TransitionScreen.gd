extends ColorRect
class_name TransitionController

@export var EffectTime : float

@onready var Static : ColorRect = $FilmGrain
@onready var SFX : AudioStreamPlayer = $SFX

@onready var CanTransition : bool = true

func _ready():
	visible = false
	Static.material.set_shader_parameter("Strength", 0)
	
func PlayTransition():
	#print("Starting transition..")
	CanTransition = false
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	color.a = 1
	Static.material.set("shader_parameter/strength", 175)
	visible = true
	await get_tree().create_timer(0.25).timeout
	var aTween = create_tween()
	aTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	SFX.play(RNG.randf_range(0.1, SFX.stream.get_length() - 3.0))
	var Mat : Material = Static.material
	aTween.tween_property(self, "color", Color(0, 0, 0, 0), EffectTime)
	await aTween.finished
	var eTween = create_tween()
	eTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	eTween.tween_property(Mat, "shader_parameter/strength", 0, 0.15)
	await eTween.finished
	SFX.stop()
	CanTransition = true
