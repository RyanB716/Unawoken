extends StaticBody2D
class_name Statue

@export var IsCurrent : bool = false

var CanInput = false

@onready var UI = get_tree().get_first_node_in_group("Player").get_node("Player UI")

func _ready():
	$Label.visible = false

func _process(delta):
	if CanInput == true && Input.is_action_just_pressed("Interact"):
		UI.ToggleStatueMenu()
		
func _on_detection_sphere_area_entered(area):
	if area.get_parent() is Player:
		$Label.visible = true
		CanInput = true

func _on_detection_sphere_area_exited(area):
	$Label.visible = false
	CanInput = false
	UI.StatueMenu.visible = false
