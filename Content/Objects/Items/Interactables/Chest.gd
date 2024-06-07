extends Area2D
class_name Chest

var CanOpen : bool = false

func _process(delta):
	if CanOpen && Input.is_action_just_pressed("Interact"):
		Open()
	
func Check(area):
	if area.get_parent() is Player:
		if area.get_parent().InventoryRef.KeyCount > 0:
			CanOpen = true
		else:
			print("Player has no keys!")

func Disable(area):
	CanOpen = false
	
func Open():
	print("Opening!")
