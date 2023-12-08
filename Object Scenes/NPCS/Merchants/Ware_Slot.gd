extends Control
class_name Ware_Slot

@export var BuyButton : Button

func AssignData(slot : WareSlot):
	$Name.text = slot.Item.Name
	$TextureRect.texture = slot.Item.Icon
	$Description.text = slot.Item.Description
	$Cost.text = ("Cost: " + str(slot.Cost))
