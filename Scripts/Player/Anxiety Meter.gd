extends Control

@onready var Meter : Panel = $Fill
@onready var Percentage : Label = $Percentage

@export var player : Player

var GM : GameManager

func _ready():
	GM = player.get_parent()

func _process(_delta):
	Meter.material.set("shader_parameter/progress", (GM.Anxiety) - 0.05)
	var value = int(GM.Anxiety * 100)
	Percentage.text = (str(value) + "%")
