extends Control

@onready var Meter : Panel = $Fill

@export var player : Player

var GM : GameManager

func _ready():
	GM = player.get_parent()

func _process(delta):
	#print(Meter.material)
	Meter.material.set("shader_parameter/progress", (GM.Anxiety * 0.01))
