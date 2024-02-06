extends Control

@onready var Meter : Panel = $Fill
@onready var Percentage : Label = $Fill/Percentage

@export var player : Player

var GM : GameManager

func _ready():
	GM = player.get_parent()

func _process(_delta):
	Meter.material.set("shader_parameter/progress", GM.Anxiety)
	var value : int = int(GM.Anxiety * 10)
	Percentage.text = (str(value) + "0%")
