extends CanvasLayer
class_name PlayerUI

@export var player : Player
@export var StatueMenu : Statue_Menu
@export var Shop : ShopMenu
@export var AttackIcons : AttackIndicators
@export var XPLabel : Label
@export var XpAmount : Label
@export var CurrentItem : Current_Item
@export var CoinLabel : Label

func _ready():
	AttackIcons.SetMaxIcons()
	
func _process(_delta):
	CoinLabel.text = ("$:" + str(player.InventoryRef.CoinCount))

#Toggles the visibility of the Statue Menu node
func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true
