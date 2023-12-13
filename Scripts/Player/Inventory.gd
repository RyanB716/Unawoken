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

func _enter_tree():
	if !GameSettings.PlayerElixirs.is_empty():
		print("\nLoading Elixir Inventory..." + " (" + str(GameSettings.PlayerElixirs.size()) + " items)")
		Elixirs.clear()
		Elixirs = GameSettings.PlayerElixirs
		
		for i in Elixirs.size():
			print("-Index: " + str(i) + ": " + str(Elixirs[i].Name) + ", " + str(Elixirs[i].AmountHeld))
	else:
		print("Global Inventory is not populated")

func _ready():
	CoinCount = GameSettings.CurrentCoins
	CurrentItem = Elixirs[0]

func _process(_delta):
	if Input.is_action_just_pressed("UseItem") && get_parent().IsInMenu == false:
		UseCurrentItem()
	
	if Input.is_action_just_pressed("CycleElixir"):
		CycleElixir()
	
	if Input.is_action_just_pressed("CyclePowder"):
		CyclePowder()
		
	#print("Elixir Index " + str(ElixirIndex) + " is: " + str(Elixirs[ElixirIndex].Name))
	match CurrentItem.ItemType:
		InventoryItem.eItemTypes.Elixir:
			CurrentItem = Elixirs[ElixirIndex]
		InventoryItem.eItemTypes.Powder:
			CurrentItem = Powders[PowderIndex]

#Adds a new item to proper inventory
func AddItem(item : InventoryItem):
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			AddItemDelegate(item, Elixirs, "Elixirs", ElixirIndex)
		InventoryItem.eItemTypes.Powder:
			AddItemDelegate(item, Powders, "Powders", PowderIndex)
		InventoryItem.eItemTypes.Key:
			pass
			
	$InventoryAudio.stream = item.PickupSFX
	$InventoryAudio.play()
	
func AddItemDelegate(item : InventoryItem, array : Array, arrayName : String, index : int):
	if array.has(item):
		print(arrayName + " has item: " + str(item.Name) + ", adding to AmountHeld")
		var element = array.find(item)
		if array[element] is InventoryItem:
			array[element].AmountHeld += 1
		else:
			print('ERROR')
	else:
		print(arrayName + " DOES NOT have item: " + str(item.Name) + ", appending array")
		item.AmountHeld = 1
		array.append(item)
		
	var newIndex = array.find(item)
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			ElixirIndex = newIndex
			
		InventoryItem.eItemTypes.Powder:
			pass
			
		InventoryItem.eItemTypes.Key:
			pass
	
	print("\n" + str(arrayName) + " Contents:")
	for i in array.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Name) + ", #" + str(Elixirs[i].AmountHeld))
	print("\n")

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
	if CurrentItem is Elixir:
		if Elixirs[ElixirIndex].AmountHeld >= 1:
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
		if Powders[PowderIndex].AmountHeld >= 1:
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
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var newSFX = AudioStreamPlayer.new()
	newSFX.stream = load("res://Audio/SFX/Object/Coin_Hit.mp3")
	newSFX.pitch_scale = RNG.randf_range(0.7, 1.15)
	get_tree().current_scene.add_child(newSFX)
	newSFX.play()
	await newSFX.finished
	newSFX.queue_free()
