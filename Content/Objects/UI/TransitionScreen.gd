extends ColorRect
class_name TransitionController

@export var EffectTime : float

@onready var Static : ColorRect = $FilmGrain
@onready var SFX : AudioStreamPlayer = $SFX

func _ready():
	visible = false
	Static.material.set_shader_parameter("Strength", 0)
	
func PlayTransition():
	#print("Starting transition..")
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	Static.material.set("shader_parameter/strength", 175)
	visible = true
	var eTween = create_tween()
	eTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	SFX.play(RNG.randf_range(0.1, SFX.stream.get_length() - 3.0))
	var Mat : Material = Static.material
	eTween.tween_property(Mat, "shader_parameter/strength", 0, EffectTime)
	await eTween.finished
	SFX.stop()
	visible = false
