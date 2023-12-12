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
	
	if player is Player:
		if PlayerElixirs.is_empty() == false:
			print("Clearing global Elixirs")
			PlayerElixirs.clear()
			
		for i in player.InventoryRef.Elixirs.size():
			var newSlot = InventorySlot.new()
			newSlot.Item = player.InventoryRef.Elixirs[i].Item
			newSlot.Amount = player.InventoryRef.Elixirs[i].Amount
			GameSettings.PlayerInventory.append(newSlot)
		
		print("-Inventory set")
		for i in GameSettings.PlayerInventory.size():
			print("-New Slot @ Index " + str(i) + " :" + str(GameSettings.PlayerInventory[i].Item.Name) + ", #: " + str(GameSettings.PlayerInventory[i].Amount))
