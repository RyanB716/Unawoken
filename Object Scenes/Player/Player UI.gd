extends CanvasLayer

@export var player : Player
@export var StatueMenu : Statue_Menu

func _ready():
	pass
	
func _process(delta):
	if player.InventoryRef.CurrentElixir.NumberHeld > 0:
		$CurrentItem/TextureRect.texture = player.InventoryRef.CurrentElixir.Icon
		$CurrentItem/Label.text = str(player.InventoryRef.CurrentElixir.NumberHeld)
	else:
		$CurrentItem/TextureRect.texture = null
		$CurrentItem/Label.text = ""


func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true
