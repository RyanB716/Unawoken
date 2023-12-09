extends CanvasLayer
class_name PlayerUI

@export var player : Player
@export var StatueMenu : Statue_Menu
@export var Shop : ShopMenu
@export var AttackIcons : AttackIndicators

func _ready():
	AttackIcons.SetMaxIcons()
	
func _process(_delta):
	if player.InventoryRef.CurrentElixir.Amount > 0:
		$CurrentItem.visible = true
		$CurrentItem/TextureRect.texture = player.InventoryRef.CurrentElixir.Item.Icon
		$CurrentItem/Label.text = str(player.InventoryRef.CurrentElixir.Amount)
	else:
		$CurrentItem.visible = false
		$CurrentItem/TextureRect.texture = null
		$CurrentItem/Label.text = ""
		
	$"Coin Amount".text = ("$:" + str(player.InventoryRef.CoinCount))

#Toggles the visibility of the Statue Menu node
func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true
