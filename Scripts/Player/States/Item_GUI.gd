extends Panel
class_name ItemGUI

@export var Controller : PlayerUI
@export var image : TextureRect
@export var Count : Label

func _process(delta):
	if Controller.player.InventoryRef.Elixirs[0].AmountHeld >= 1:
		self.visible = true
		image.texture = Controller.player.InventoryRef.CurrentItem.Icon
		Count.text = str(Controller.player.InventoryRef.CurrentItem.AmountHeld)
	else:
		self.visible = false
		image.texture = null
		Count.text = ""
