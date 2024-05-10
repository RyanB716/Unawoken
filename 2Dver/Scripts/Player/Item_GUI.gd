extends ColorRect
class_name ItemGUI

@onready var image = $TextureRect
@onready var Count = $Label
@onready var Border = $Border

func DisplayItem(item : InventoryItem):
	if self.visible == false:
		self.visible = true
	image.texture = item.Icon
	Count.text = str(item.AmountHeld)
