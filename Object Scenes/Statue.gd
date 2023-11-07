extends StaticBody2D
class_name Statue

@export var IsCurrent : bool = false

func _ready():
	$Label.visible = false

func _process(delta):
	if $Label.visible == true && Input.is_action_just_pressed("Interact"):
		Respawn()

func _on_detection_sphere_area_entered(area):
	$Label.visible = true

func _on_detection_sphere_area_exited(area):
	$Label.visible = false

func Respawn():
	GameSettings.RespawnPoint = Vector2(self.global_position.x, self.global_position.y + 25)
