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
	
	if Input.is_action_just_pressed("CyclePowder"):
		CyclePowder()
		
	#if CurrentItem.AmountHeld >= 1:
		#print("Current Item is: " + str(CurrentItem.Name))

#Adds a new Elixir item to proper inventory
func AddItem(item : InventoryItem):
	var array : Array
	var arrayName : String
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			array = Elixirs
			arrayName = "Elixirs"
		InventoryItem.eItemTypes.Powder:
			array = Powders
			arrayName = "Powders"
		InventoryItem.eItemTypes.Key:
			pass
	
	for i in array.size():
				if array[i].Name == item.Name:
					print("\nMatches!")
					print("Adding to Number Held")
					array[i].AmountHeld += 1
					break
				else:
					if i == array.size() - 1:
						print("\nDoes not match!")
						print("Adding new item")
						var newItem : InventoryItem
						match item.ItemType:
							InventoryItem.eItemTypes.Elixir:
								newItem = Elixir.new()
								newItem.AmountInPercent = item.AmountInPercent
							InventoryItem.eItemTypes.Powder:
								newItem = Powder.new()
								newItem.OverrideTime = item.OverrideTime
							InventoryItem.eItemTypes.Key:
								newItem = KeyItem.new()
						newItem.Name = item.Name
						newItem.Icon = item.Icon
						newItem.AmountHeld = 1
						array.append(newItem)
					if CurrentItem.AmountHeld <= 0:
						CurrentItem = array[i]
					break
					
	print("\n" + str(arrayName) + " Contents:")
	for i in array.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Name) + ", " + str(Elixirs[i].AmountHeld))
	print("\n")
	
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
				print("Using current powder: " + str(CurrentItem.Name))
				CurrentItem.AmountHeld -= 1
				
			InventoryItem.eItemTypes.Key:
				pass

#Cycles the Elixir inventory upward
func CycleElixir():
	if !CurrentItem is Elixir:
		CurrentItem = Elixirs[ElixirIndex]
	else:
		#print('Attempting to switch Elixir')
		if (ElixirIndex + 1) > Elixirs.size() - 1:
			ElixirIndex = 0
		else:
			ElixirIndex += 1
		CurrentItem = Elixirs[ElixirIndex]
	#print('Setting Current Item to: ' + str(CurrentItem.Name))
		
func CyclePowder():
	if !CurrentItem is Powder:
		CurrentItem = Powders[PowderIndex]
	else:
		#print('Attempting to switch Powder')
		if (PowderIndex + 1) > Powders.size() - 1:
			PowderIndex = 0
		else:
			PowderIndex += 1
		CurrentItem = Powders[PowderIndex]
	#print('Setting Current Item to: ' + str(CurrentItem.Name))

func AddCoin():
	CoinCount += 1
	$CoinAudio.play()
