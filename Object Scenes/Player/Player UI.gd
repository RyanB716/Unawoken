extends CanvasLayer

@export var player : Player
@export var StatueMenu : Statue_Menu

func _ready():
	pass
	
func _process(delta):
	if player.InventoryRef.CurrentElixir:
		$CurrentItem.visible = true
		$CurrentItem/TextureRect.texture = player.InventoryRef.CurrentElixir.Item.Icon
		$CurrentItem/Label.text = str(player.InventoryRef.CurrentElixir.Amount)
	else:
		$CurrentItem.visible = false
		$CurrentItem/TextureRect.texture = null
		$CurrentItem/Label.text = ""
		
	$"Coin Amount".text = ("$:" + str(player.InventoryRef.CoinCount))


func ToggleStatueMenu():
	if StatueMenu.visible == true:
		StatueMenu.visible = false
	else:
		StatueMenu.visible = true
