extends Panel
class_name Current_Item

@export var Controller : PlayerUI
@export var image : TextureRect
@export var Count : Label

func _process(delta):
	if Controller.player.InventoryRef.CurrentElixir.Amount > 0:
		self.visible = true
		image.texture = Controller.player.InventoryRef.CurrentElixir.Item.Icon
		Count.text = str(Controller.player.InventoryRef.CurrentElixir.Amount)
	else:
		self.visible = false
		image.texture = null
		Count.text = ""
