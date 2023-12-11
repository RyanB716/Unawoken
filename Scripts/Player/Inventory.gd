extends Node2D
class_name Inventory

@export var Elixirs : Array[Elixir]
@export var Powders : Array[Powder]
@export var Keys : Array[Key]

@onready var CurrentItem : InventoryItem

@onready var ElixirIndex : int = 0
@onready var PowderIndex : int = 0
@onready var KeyIndex : int = 0

@onready var CoinCount : int = 0
@onready var KeyCount : int = 0

@onready var player : Player = get_parent()

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
		
	CurrentItem = Elixirs[0]

func _process(_delta):
	if Input.is_action_just_pressed("UseItem") && get_parent().IsInMenu == false:
		UseCurrentItem()
	
	if Input.is_action_just_pressed("CycleElixir"):
		CycleElixir()

#Adds a new Elixir item to proper inventory
func AddItem(item : InventoryItem):
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			for i in Elixirs.size():
				if Elixirs[i].Name == item.Name:
					print("\nMatches!")
					print("Adding to Number Held")
					Elixirs[i].AmountHeld += 1
					break
				else:
					if i == Elixirs.size() - 1:
						print("\nDoes not match!")
						print("Adding new item")
						var newSlot = Elixir.new()
						newSlot.Item = item
						newSlot.AmountHeld = 1
						Elixirs.append(newSlot)
					if CurrentItem.AmountHeld <= 0:
						CurrentItem = Elixirs[i]
					break
					
			print("\nElixirs Contents:")
			for i in Elixirs.size():
				print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Name) + ", " + str(Elixirs[i].AmountHeld))
			print("\n")
			
		InventoryItem.eItemTypes.Powder:
			pass
		InventoryItem.eItemTypes.Key:
			pass
	
	$InventoryAudio.stream = item.PickupSFX
	$InventoryAudio.play()

#Uses the current item
func UseCurrentItem():
	if CurrentItem.AmountHeld > 0:
		match CurrentItem.ItemType:
			
			InventoryItem.eItemTypes.Elixir:
				if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
					print("Using current exlixir: " + str(CurrentItem.Name))
					$InventoryAudio.stream = CurrentItem.UseSFX
					$InventoryAudio.play()
					CurrentItem.AmountHeld -= 1
					var AmntToAdd : int = int(player.MaxHealth * (CurrentItem.AmountInPercent * 0.01))
					player.RegainHealth(AmntToAdd)
					if CurrentItem.AmountHeld == 0:
						CycleElixir()

			InventoryItem.eItemTypes.Powder:
				pass
				
			InventoryItem.eItemTypes.Key:
				pass

#Cycles the Elixir inventory upward
func CycleElixir():
	if (ElixirIndex + 1) > Elixirs.size() - 1:
			ElixirIndex = 0
	else:
		ElixirIndex += 1
		
	if !CurrentItem is Elixir:
		CurrentItem = Elixirs[ElixirIndex]
	else:
		return

func AddCoin():
	CoinCount += 1
	$CoinAudio.play()
