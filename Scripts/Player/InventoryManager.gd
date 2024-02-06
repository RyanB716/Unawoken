extends Node2D
class_name InventoryManager

@export var InventoryData : InventoryResource

var CurrentItem : InventoryItem

var Elixirs : Array[Elixir]
var Powders : Array[Powder]

@onready var ElixirIndex : int = 0
@onready var PowderIndex : int = 0

var Coins : int

@onready var player : Player = get_parent()
@onready var InvSFX : InventoryAudio = $InventoryAudio

func _ready():
	Elixirs = InventoryData.ElixirsArray
	Powders = InventoryData.PowdersArray
	
	if !Elixirs.is_empty():
		for i in Elixirs.size():
			print("Elixir: " + str(i + 1) + "/" + str(Elixirs.size()) + " is: " + str(Elixirs[i].Name))
			
	if !Powders.is_empty():
		for i in Powders.size():
			print("Powder: " + str(i + 1) + "/" + str(Powders.size()) + " is: " + str(Powders[i].Name))

func _process(_delta):
	if Input.is_action_just_pressed("CycleElixir") && !Elixirs.is_empty():
		CycleElixir()
	
	if Input.is_action_just_pressed("CyclePowder") && !Powders.is_empty():
		CyclePowder()
		
	Coins = InventoryData.CoinAmount

#Adds a new item to proper inventory
func AddItem(item : InventoryItem):
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			AddItemDelegate(item, Elixirs, "Elixirs", ElixirIndex)
			if Powders.is_empty():
				CycleElixir()
		InventoryItem.eItemTypes.Powder:
			AddItemDelegate(item, Powders, "Powders", PowderIndex)
			if Elixirs.is_empty():
				CyclePowder()
		InventoryItem.eItemTypes.Key:
			pass
			
	InvSFX.PlaySFX(item.PickupSFX)
	
func AddItemDelegate(_item : InventoryItem, array : Array, arrayName : String, _index : int):
	if array.has(_item):
		print("\n" + str(arrayName) + " has item: " + str(_item.Name) + ", adding to AmountHeld")
		var element = array.find(_item)
		if array[element] is InventoryItem:
			array[element].AmountHeld += 1
		else:
			print('ERROR')
	else:
		print(arrayName + " DOES NOT have item: " + str(_item.Name) + ", appending array")
		_item.AmountHeld = 1
		array.append(_item)
		
	var newIndex = array.find(_item)
	match _item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			ElixirIndex = newIndex
			if CurrentItem == null:
				CurrentItem = array[newIndex]
			
		InventoryItem.eItemTypes.Powder:
			pass
			
		InventoryItem.eItemTypes.Key:
			pass
	
	print("\n" + str(arrayName) + " Contents:")
	for i in array.size():
		print(str(i) + "/" + str(array.size() - 1) + ": " + str(array[i].Name) + ", #" + str(array[i].AmountHeld))
	print("\n")

#Uses the current item
func UseCurrentItem():
	InvSFX.PlaySFX(CurrentItem.UseSFX)
	
	CurrentItem.AmountHeld -= 1
	
	match CurrentItem.ItemType:
		
		InventoryItem.eItemTypes.Elixir:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				print("Using current exlixir: " + str(CurrentItem.Name))
				player.RegainHealth(Elixirs[ElixirIndex].AmountInPercent)
				if CurrentItem.AmountHeld == 0:
					CurrentItem = null
					Elixirs.remove_at(ElixirIndex)
					if !Elixirs.is_empty():
						ElixirIndex = 0
						CycleElixir()
					elif !Powders.is_empty():
						PowderIndex = 0
						CyclePowder()
					else:
						print("No items in inventory; CurrentItem is staying NULL")

		InventoryItem.eItemTypes.Powder:
			print("Using current powder: " + str(CurrentItem.Name))
			if CurrentItem.AmountHeld == 0:
				CurrentItem = null
				Powders.remove_at(PowderIndex)
				if !Powders.is_empty():
					PowderIndex = 0
					CyclePowder()
				elif !Elixirs.is_empty():
					ElixirIndex = 0
					CycleElixir()
				else:
					print("No items in inventory; CurrentItem is staying NULL")
				
		InventoryItem.eItemTypes.Key:
			pass

#Cycles the Elixir inventory upward
func CycleElixir():
	print("Cycling Elixirs...")

	if !CurrentItem is Elixir && Elixirs[ElixirIndex] != null:
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
	print("Cycling Powders...")
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
	InventoryData.CoinAmount += 1
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var newSFX = AudioStreamPlayer.new()
	newSFX.pitch_scale = RNG.randf_range(0.7, 1.15)
	get_tree().current_scene.add_child(newSFX)
	newSFX.play()
	await newSFX.finished
	newSFX.queue_free()
