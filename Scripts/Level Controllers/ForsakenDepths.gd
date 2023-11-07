extends Node2D

func _ready():
	if GameSettings.RespawnPoint == Vector2.ZERO:
		GameSettings.RespawnPoint = Vector2($Statue.global_position.x, $Statue.global_position.y + 25)

func _process(_delta):
	if !$"Audio/Ambient Audio 1".playing:
		$"Audio/Ambient Audio 1".play()
		
	if !$"Audio/Ambient Audio 2".playing:
		$"Audio/Ambient Audio 2".play()
