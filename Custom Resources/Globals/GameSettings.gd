extends Node

var IsLaunched : bool = false
var PlayIntro : bool = true

var RespawnPoint : Vector2 = Vector2.ZERO
var CurrentPlayerXP : int
var CurrentCoins : int

var PlayerElixirs : Array[Elixir]
var PlayerPowders : Array[Powder]
var PlayerKeys : Array[KeyItem]

func UpdateInventory():
	var player = get_tree().get_first_node_in_group("Player")
	
	print("Updating global Inventory!")
	GameSettings.CurrentPlayerXP = player.CurrentXP
	print("-XP set")
	GameSettings.CurrentCoins = player.InventoryRef.CoinCount
	print("-Coins set\n")
	
	#if player is Player:
		#print("Clearing global Elixirs")
		#PlayerElixirs.clear()
			
		#PlayerElixirs = player.InventoryRef.Elixirs
		
		#print("-Inventory set")
		#for i in GameSettings.PlayerElixirs.size():
			#print("-New Slot @ Index " + str(i) + " :" + str(GameSettings.PlayerElixirs[i].Name) + ", #: " + str(GameSettings.PlayerElixirs[i].AmountHeld))
