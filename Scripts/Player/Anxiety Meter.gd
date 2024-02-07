extends Control

@onready var Meter : Panel = $Fill
@onready var Percentage : Label = $Percentage

@export var player : Player

@export var MaxFill : float

var GM : GameManager

var WaveSpeed : float = 1

func _ready():
	GM = player.get_parent()

func _process(_delta):
	if GM.Anxiety <= MaxFill:
		Meter.material.set("shader_parameter/progress", GM.Anxiety)
	
	var value = int(GM.Anxiety * 100)
	Percentage.text = (str(value))
	
	AffectWaveSpeed()
	FillSounds()
	
func AffectWaveSpeed():
	if GM.Anxiety >= 0.25:
		WaveSpeed = 1.25
	
	elif GM.Anxiety >= 0.5:
		WaveSpeed = 1.5
	
	elif GM.Anxiety >= 0.75:
		WaveSpeed = 1.75
	
	elif GM.Anxiety >= 1.0:
		WaveSpeed = 2
	
	else:
		WaveSpeed = 1
	
	Meter.material.set("shader_parameter/wave_1_speed", -WaveSpeed)
	Meter.material.set("shader_parameter/wave_2_speed", WaveSpeed)

func FillSounds():
	match GM.Anxiety:
		0.25:
			print("Playing bubbles")
		0.5:
			print("Playing bubbles")
		0.75:
			print("Playing bubbles")
		1.00:
			print("Playing bubbles")
