extends Node2D

func _ready():
	pass

func _process(_delta):
	if !$"Audio/Ambient Audio 1".playing:
		$"Audio/Ambient Audio 1".play()
		
	if !$"Audio/Ambient Audio 2".playing:
		$"Audio/Ambient Audio 2".play()
