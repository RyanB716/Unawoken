extends Control
class_name Ware_Slot

@export var BuyButton : Button

@onready var playerInventory : InventoryManager = get_tree().get_first_node_in_group("Player").InventoryRef

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
	if playerInventory is InventoryManager:
		controller.ChooseDialogue(controller.NPC.PurchaseLines, controller.NPC.SpokenPurchaseLines)
		playerInventory.InventoryData.CoinAmount -= item.Cost
		playerInventory.AddItem(item.Item)
		
func _on_button_pressed():
	if playerInventory.InventoryData.CoinAmount >= item.Cost:
		BuyItem()
	else:
		controller.ChooseDialogue(controller.NPC.FailLines, controller.NPC.SpokenFailLines)
