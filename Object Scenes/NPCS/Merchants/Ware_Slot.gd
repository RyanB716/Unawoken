extends Control
class_name Ware_Slot

@export var BuyButton : Button

var item : WareSlot

func AssignData(slot : WareSlot):
	item = slot
	$Name.text = item.Item.Name
	$TextureRect.texture = item.Item.Icon
	$Description.text = item.Item.Description
	$Cost.text = ("Cost: " + str(item.Cost))
	
func BuyItem():
	print('Purchasing: ' + str(item.Item.Name))
	var playerInventory = get_tree().get_first_node_in_group("Player").InventoryRef
	if playerInventory is Inventory:
		print('Success')
		playerInventory.CoinCount -= item.Cost
		item.Amount -= 1
		playerInventory.AddElixir(item.Item)

func _on_button_pressed():
	BuyItem()
