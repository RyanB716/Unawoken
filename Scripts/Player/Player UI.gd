extends CanvasLayer
class_name PlayerUI

@export var player : Player
@export var StatueMenu : Statue_Menu
@export var Shop : ShopMenu
@export var Stamina_Icons : StaminaContainer
@export var AttackIcons : Attack_Indicators
@export var XPLabel : Label
@export var XpAmount : Label
@export var ElixirGUI : ItemGUI
@export var PowderGUI : ItemGUI
@export var CoinLabel : Label

func _ready():
	AttackIcons.SetMaxIcons()
	XpAmount.visible = false
	
func _process(_delta):
	CoinLabel.text = ("$:" + str(player.InventoryRef.CoinCount))
	
	XPLabel.text = ("XP: " + str(player.CurrentXP))
	XpAmount.text = ("+" + str(player.AddedXP))
	
	if player.InventoryRef.Elixirs[player.InventoryRef.ElixirIndex].AmountHeld > 0:
		ElixirGUI.visible = true
		ElixirGUI.DisplayItem(player.InventoryRef.Elixirs[player.InventoryRef.ElixirIndex].Icon, 
		player.InventoryRef.Elixirs[player.InventoryRef.ElixirIndex].AmountHeld)
	else:
		ElixirGUI.visible = false

	if player.InventoryRef.Powders[player.InventoryRef.PowderIndex].AmountHeld > 0:
		PowderGUI.visible = true
		PowderGUI.DisplayItem(player.InventoryRef.Powders[player.InventoryRef.PowderIndex].Icon, 
		player.InventoryRef.Powders[player.InventoryRef.PowderIndex].AmountHeld)
	else:
		PowderGUI.visible = false
		
	if player.InventoryRef.CurrentItem is Elixir:
		ElixirGUI.Border.visible = true
		PowderGUI.Border.visible = false
	else:
		PowderGUI.Border.visible = true
		ElixirGUI.Border.visible = false

#Toggles the visibility of the Statue Menu node
func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true
