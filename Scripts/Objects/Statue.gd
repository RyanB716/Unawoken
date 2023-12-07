extends StaticBody2D
class_name Statue

var CanInput = false

@onready var PlayerRef = get_tree().get_first_node_in_group("Player")
@onready var UI = get_tree().get_first_node_in_group("Player").get_node("Player UI")

func _ready():
	$Label.visible = false

func _process(_delta):
	if CanInput == true && Input.is_action_just_pressed("Interact"):
		print("\nSpawn Point UPDATED!!!\n")
		GameSettings.RespawnPoint = self.global_position
		print(GameSettings.RespawnPoint)
		UI.ToggleStatueMenu()
		
func _on_detection_sphere_area_entered(area):
	if area.get_parent() is Player:
		$Label.visible = true
		CanInput = true

func _on_detection_sphere_area_exited(_area):
	$Label.visible = false
	CanInput = false
	UI.StatueMenu.visible = false
