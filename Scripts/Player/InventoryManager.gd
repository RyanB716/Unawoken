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
func AddItem(item : InventoryItem, amount : int):
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if !item.Heal.is_connected(player.RegainHealth):
				item.Heal.connect(player.RegainHealth)
			AddItemDelegate(item, Elixirs, "Elixirs", ElixirIndex, amount)
			if Powders.is_empty():
				CycleElixir()
		InventoryItem.eItemTypes.Powder:
			if !item.UpdateAnxiety.is_connected(player.GM.RestartAnxietyFill):
				item.UpdateAnxiety.connect(player.GM.RestartAnxietyFill)
			AddItemDelegate(item, Powders, "Powders", PowderIndex, amount)
			if Elixirs.is_empty():
				CyclePowder()
		InventoryItem.eItemTypes.Key:
			pass
			
	InvSFX.PlaySFX(item.PickupSFX)
	
func AddItemDelegate(_item : InventoryItem, array : Array, arrayName : String, _index : int, amount : int):
	if array.has(_item):
		print("\n" + str(arrayName) + " has item: " + str(_item.Name) + ", adding to AmountHeld")
		var element = array.find(_item)
		if array[element] is InventoryItem:
			array[element].AmountHeld += amount
		else:
			print('ERROR')
	else:
		print(arrayName + " DOES NOT have item: " + str(_item.Name) + ", appending array")
		_item.AmountHeld = amount
		array.append(_item)
		
	var newIndex = array.find(_item)
	
	match _item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			ElixirIndex = newIndex
			if CurrentItem == null:
				CurrentItem = array[newIndex]
			
		InventoryItem.eItemTypes.Powder:
			PowderIndex = newIndex
			if CurrentItem == null:
				CurrentItem = array[newIndex]
	
	print("\n" + str(arrayName) + " Contents:")
	for i in array.size():
		print(str(i) + "/" + str(array.size() - 1) + ": " + str(array[i].Name) + ", #" + str(array[i].AmountHeld))
	print("\n")

#Uses the current item
func UseCurrentItem():
	match CurrentItem.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				CurrentItem.UseItem()
				InvSFX.PlaySFX(CurrentItem.UseSFX)
				
			if CurrentItem.AmountHeld <= 0:
				RemoveItem(CurrentItem, Elixirs, ElixirIndex, Powders)
		
		InventoryItem.eItemTypes.Powder:
			CurrentItem.UseItem()
			InvSFX.PlaySFX(CurrentItem.UseSFX)
			
			if CurrentItem.AmountHeld <= 0:
				RemoveItem(CurrentItem, Powders, PowderIndex, Elixirs)
	
func RemoveItem(item : InventoryItem, ItemArray : Array, Index : int, OtherArray : Array):
	if ItemArray[Index] == CurrentItem:
		CurrentItem = null
		ItemArray.remove_at(Index)
		
		if ItemArray.is_empty():
			if !OtherArray.is_empty():
				CurrentItem = OtherArray[0]
		else:
			CurrentItem = ItemArray[0]

#Cycles the Elixir inventory upward
func CycleElixir():
	if !CurrentItem is Elixir && Elixirs[ElixirIndex] != null:
		if Elixirs[ElixirIndex].AmountHeld >= 1:
			print("Equipping Elixir!")
			CurrentItem = Elixirs[ElixirIndex]
	else:
		print("Cycling Elixirs...")
		if (ElixirIndex + 1) > Elixirs.size() - 1:
			ElixirIndex = 0
		else:
			ElixirIndex += 1
		CurrentItem = Elixirs[ElixirIndex]
	#print('Setting Current Item to: ' + str(CurrentItem.Name))
		
func CyclePowder():
	if !CurrentItem is Powder:
		if Powders[PowderIndex].AmountHeld >= 1:
			print("Equipping Powder!")
			CurrentItem = Powders[PowderIndex]
	else:
		print("Cycling Powders...")
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
	newSFX.stream = load("res://Aesthetics/Audio/SFX/Item/Misc/Coin_Hit.mp3")
	newSFX.pitch_scale = RNG.randf_range(0.7, 1.15)
	get_tree().current_scene.add_child(newSFX)
	newSFX.play()
	await newSFX.finished
	newSFX.queue_free()
