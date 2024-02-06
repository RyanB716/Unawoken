extends StaticBody2D
class_name Statue

var CanInput = false

@onready var PlayerRef : Player = get_tree().get_first_node_in_group("Player")

signal OpenMenu

func _ready():
	$Label.visible = false

func _process(_delta):
	if CanInput == true && Input.is_action_just_pressed("Interact"):
		print("Spawn Point UPDATED!!!")
		GameSettings.RespawnPoint = self.global_position
		print(GameSettings.RespawnPoint)
		PlayerRef.UI.ToggleMenu(PlayerRef.UI.StatueMenu, true)
		
func _on_detection_sphere_area_entered(area):
	if area.get_parent() is Player:
		$Label.visible = true
		CanInput = true

func _on_detection_sphere_area_exited(_area):
	$Label.visible = false
	CanInput = false
