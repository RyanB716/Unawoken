extends Control
class_name Ware_Slot

@export var BuyButton : Button

@onready var playerInventory = get_tree().get_first_node_in_group("Player").InventoryRef

var item : WareSlotData

var controller : ShopMenu

func AssignData(slot : WareSlotData):
	item = slot
	$Name.text = item.Item.Name
	$TextureRect.texture = item.Item.Icon
	$Description.text = item.Item.Description
	$Cost.text = ("Cost: " + str(item.Cost))
	
func BuyItem():
	print('Purchasing: ' + str(item.Item.Name))
	if playerInventory is Inventory:
		controller.ChooseDialogue(controller.NPC.PurchaseLines, controller.NPC.SpokenPurchaseLines)
		playerInventory.CoinCount -= item.Cost
		playerInventory.AddItem(item.Item)
		
func _on_button_pressed():
	if playerInventory.CoinCount >= item.Cost:
		BuyItem()
	else:
		controller.ChooseDialogue(controller.NPC.FailLines, controller.NPC.SpokenFailLines)
