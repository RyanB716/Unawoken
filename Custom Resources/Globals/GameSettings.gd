extends Node

var IsLaunched : bool = false
var PlayIntro : bool = true

var RespawnPoint : Vector2 = Vector2.ZERO
var CurrentPlayerXP : int
var CurrentCoins : int

var PlayerElixirs : Array[Elixir]
var PlayerPowders : Array[Powder]
var PlayerKeys : Array[KeyItem]

@onready var player : Player = get_tree().get_first_node_in_group("Player")
var inventory : Inventory

func _process(delta):
	if player == null:
		player = get_tree().get_first_node_in_group("Player")

func UpdateInventory(globalArray : Array, playerArray : Array, name : String): 
	print("\nUpdating global " + str(name) + "!\n")
	
	globalArray.clear()
	
	for i in playerArray.size():
		print(str(i) + ": " + str(playerArray[i].Name))
		globalArray.append(playerArray[i])
	
	for i in globalArray.size():
		print("- Slot @ Index: " + str(i) + "/" + str(globalArray.size() - 1) + " " + 
		str(globalArray[i].Name) + ", #: " + 
		str(globalArray[i].AmountHeld))
	
	print("\n" + str(name) + " set!\n")

func SaveInventories():
	inventory = player.InventoryRef
	
	UpdateInventory(PlayerElixirs, inventory.Elixirs, "Elixirs")
	UpdateInventory(PlayerPowders, inventory.Powders, "Powders")
	
	CurrentCoins = player.InventoryRef.CoinCount
	print("- Coins set\n")
	#GameSettings.CurrentPlayerXP = player.CurrentXP
	#print("-XP set")
	print("Inventory set!\n")
