extends ColorRect
class_name TransitionController

@onready var Static : ColorRect = $FilmGrain
@onready var SFX : AudioStreamPlayer = $SFX

func _ready():
	visible = false
	Static.material.set_shader_parameter("Strength", 0)
	
func PlayTransition():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	Static.material.set("shader_parameter/strength", 275)
	visible = true
	#await get_tree().create_timer(1.0).timeout
	var eTween = get_tree().create_tween()
	eTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	SFX.play(RNG.randf_range(0.1, SFX.stream.get_length() - 3.0))
	var Mat : Material = Static.material
	eTween.tween_property(Mat, "shader_parameter/strength", 0, 2)
	await eTween.finished
	SFX.stop()
	visible = false
	return
