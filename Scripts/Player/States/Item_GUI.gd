extends Panel
class_name ItemGUI

@onready var image = $TextureRect
@onready var Count = $Label
@onready var Border = $Border

func DisplayItem(icon : Texture, number : int):
	image.texture = icon
	Count.text = str(number)
