extends Node

var IsLaunched : bool = false
var PlayIntro : bool = true

var RespawnPoint : Vector2 = Vector2.ZERO
var CurrentPlayerXP : int
var CurrentCoins : int

var PlayerInventory : Array[InventorySlot]

func UpdateInventory():
	var player = get_tree().get_first_node_in_group("Player")
	if player is Player:
		if PlayerInventory.is_empty() == false:
			print("Clearing global inventory")
			GameSettings.PlayerInventory.clear()
			
		for i in player.InventoryRef.Elixirs.size():
			var newSlot = InventorySlot.new()
			newSlot.Item = player.InventoryRef.Elixirs[i].Item
			newSlot.Amount = player.InventoryRef.Elixirs[i].Amount
			GameSettings.PlayerInventory.append(newSlot)
		
		print("-Inventory set")
		for i in GameSettings.PlayerInventory.size():
			print("-New Slot @ Index " + str(i) + " :" + str(GameSettings.PlayerInventory[i].Item.Name) + ", #: " + str(GameSettings.PlayerInventory[i].Amount))
