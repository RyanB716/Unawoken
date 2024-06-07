extends Node

@export var Target : Node

@export var RandomStrength : float = 30.0
@export var ShakeFade : float = 5.0

var RNG = RandomNumberGenerator.new()

var ShakeStrength : float = 0.0

func ApplyShake():
	ShakeStrength = RandomStrength

func _process(delta):
	if ShakeStrength > 0:
		ShakeStrength = lerp(ShakeStrength, 0.0, ShakeFade * delta)
	
	if Target:
		ApplyShake()
		var newOffset = GetRandomOffset()
		Target.position = Vector2(Target.position.x + newOffset.x, Target.position.y + newOffset.y)

func GetRandomOffset() -> Vector2:
	return Vector2(RNG.randf_range(-ShakeStrength, ShakeStrength), RNG.randf_range(-ShakeStrength, ShakeStrength))
