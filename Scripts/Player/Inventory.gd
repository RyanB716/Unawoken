extends Node2D
class_name Inventory

@export var Elixirs : Array[InventorySlot]

@onready var CurrentElixir : InventorySlot
@onready var ElixirIndex : int = 0

@onready var CoinCount : int = 0

func _ready():
	CoinCount = GameSettings.CurrentCoins
	
	if !GameSettings.PlayerInventory.is_empty():
		print("\nLoading Inventory..." + " (" + str(GameSettings.PlayerInventory.size()) + " items)")
		Elixirs.clear()
		for i in GameSettings.PlayerInventory.size():
			#print("-Index: " + str(i) + "/" + str(GameSettings.PlayerInventory.size()) + " is: " + str(GameSettings.PlayerInventory[i].Item.Name) + " #:" + str(GameSettings.PlayerInventory[i].Amount))
			var newSlot = InventorySlot.new()
			newSlot.Item = GameSettings.PlayerInventory[i].Item
			newSlot.Amount = GameSettings.PlayerInventory[i].Amount
			Elixirs.append(newSlot)
			print("-Index: " + str(i) + ": " + str(Elixirs[i].Item.Name) + ", " + str(Elixirs[i].Amount))
			print("\n")
	else:
		print("Global Inventory is not populated")

func _process(_delta):
	CurrentElixir = Elixirs[ElixirIndex]
	
	if Input.is_action_just_pressed("UseItem") && get_parent().IsInMenu == false:
		UseCurrentItem()
	
	if Input.is_action_just_pressed("CycleElixir"):
		CycleElixir()

#Adds a new Elixir item to proper inventory
func AddElixir(item : UsableItemResource):
	$InventoryAudio.stream = item.PickupSFX
	$InventoryAudio.play()
	for i in Elixirs.size():
		if Elixirs[i].Item.Name == item.Name:
			print("\nMatches!")
			print("Adding to Number Held")
			Elixirs[i].Amount += 1
			break
		else:
			if i == Elixirs.size() - 1:
				print("\nDoes not match!")
				print("Adding new item")
				var newSlot = InventorySlot.new()
				newSlot.Item = item
				newSlot.Amount = 1
				Elixirs.append(newSlot)
				if CurrentElixir.Amount == 0:
					CurrentElixir = Elixirs[i]
				break
		
	print("\nElixirs Contents:")
	for i in Elixirs.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Item.Name) + ", " + str(Elixirs[i].Amount))
	print("\n")

#Uses the current item
func UseCurrentItem():
	if CurrentElixir.Amount> 0:
		var player = get_parent()
		if player is Player:
			if CurrentElixir.Item.StatType == CurrentElixir.Item.StatTypes.Health:
				if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
					$InventoryAudio.stream = CurrentElixir.Item.UseSFX
					$InventoryAudio.play()
					CurrentElixir.Amount -= 1
					var AmntToAdd : int = int(player.MaxHealth * (CurrentElixir.Item.AmountInPercent * 0.01))
					player.RegainHealth(AmntToAdd)
					if CurrentElixir.Amount == 0:
						CycleElixir()

#Cycles the Elixir inventory upward
func CycleElixir():
	if (ElixirIndex + 1) > Elixirs.size() - 1:
			ElixirIndex = 0
	else:
		ElixirIndex += 1

func AddCoin():
	CoinCount += 1
	$CoinAudio.play()
