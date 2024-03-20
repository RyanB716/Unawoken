extends Node2D
class_name InventoryManager

@export var InventoryData : InventoryResource

var CurrentItem : InventoryItem

#var Elixirs : Array[Elixir]
#var Powders : Array[Powder]

@onready var Elixirs : int = 0
@onready var Powders : int = 0
@onready var inventoyMap : Dictionary
var Coins : int

@onready var player : Player = get_parent()
@onready var InvSFX : InventoryAudio = $InventoryAudio


func _ready():
	inventoyMap = InventoryData.InventoryStorage
	inventoyMap = {InventoryItem.eItemTypes.Elixir :
		 {"Lite Elixir" : load("res://Content/Resources/Usable Items/LiteElixir.tres").duplicate() , "Mild Elixir" : load("res://Content/Resources/Usable Items/MedElixir.tres").duplicate()} ,
		 InventoryItem.eItemTypes.Powder : {"Azalea Powder" : load("res://Content/Resources/Usable Items/BluePowder.tres").duplicate()}
	}	

func _process(_delta):
	if Input.is_action_just_pressed("CycleElixir") && Elixirs > 0:
		CycleElixir()
	
	if Input.is_action_just_pressed("CyclePowder") && Powders > 0:
		CyclePowder()
		
	Coins = InventoryData.CoinAmount
#Adds a new item to proper inventory
func AddItem(item : InventoryItem, amount : int):
	#Key : InventoryItem Name   Value : InventoryItem Object
	
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if !item.Heal.is_connected(player.RegainHealth):
				item.Heal.connect(player.RegainHealth)
			AddItemDelegate(item, amount)
			if Powders <= 0:
				CycleElixir()
				
		InventoryItem.eItemTypes.Powder:
			if !item.UpdateAnxiety.is_connected(player.GM.RestartAnxietyFill):
				item.UpdateAnxiety.connect(player.GM.RestartAnxietyFill)
			AddItemDelegate(item, amount)
			print("AddItemDelegate" + str(inventoyMap[item.ItemType]))
			if Elixirs <= 0:
				CyclePowder()
				
		InventoryItem.eItemTypes.Key:
			pass
			
	InvSFX.PlaySFX(item.PickupSFX)
	
func AddItemDelegate(_item : InventoryItem,  amount : int):
	
	inventoyMap[_item.ItemType][_item.Name].AmountHeld += amount
	if _item.ItemType == InventoryItem.eItemTypes.Elixir :
		Elixirs += amount
	else:
		Powders += amount
		
	if CurrentItem == null:
		CurrentItem = _item
#Uses the current item
func UseCurrentItem():
	match CurrentItem.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				CurrentItem.UseItem()
				Elixirs += -1
				InvSFX.PlaySFX(CurrentItem.UseSFX)
				
				if CurrentItem.AmountHeld <= 0:
					RemoveItem(CurrentItem)
		
		InventoryItem.eItemTypes.Powder:
			CurrentItem.UseItem()
			Powders += -1
			InvSFX.PlaySFX(CurrentItem.UseSFX)
			
			if CurrentItem.AmountHeld <= 0:
				RemoveItem(CurrentItem)
	
func RemoveItem(item : InventoryItem):
	# check amount of consumables, manages item UI
	# change for scalability
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if Elixirs > 0:
				for i in inventoyMap[InventoryItem.eItemTypes.Elixir]:
					if i.AmountHeld > 0:
						CurrentItem = i
						break
			elif Powders > 0:
				for i in inventoyMap[InventoryItem.eItemTypes.Powder]:
					if i.AmountHeld > 0:
						CurrentItem = i
						break
			else:
				CurrentItem = null
				
		InventoryItem.eItemTypes.Powder:
			if Elixirs > 0 && Powders <= 0:
				for i in inventoyMap[InventoryItem.eItemTypes.Elixir]:
					if i.AmountHeld > 0:
						CurrentItem = i
						break
			else:
				CurrentItem = null

#Cycles the Elixir inventory upward
func CycleElixir():
	
	if !CurrentItem is Elixir: #&& Elixirs >= 1: 
		print("Equipping Elixir!")		
		var temp = FirstHeld(inventoyMap[InventoryItem.eItemTypes.Elixir])
		CurrentItem = temp
		
	else:
		print("Cycling Elixirs...")
		match CurrentItem.Name:
			"Lite Elixir":
				#ElixirIndex = newIndex
				CurrentItem = inventoyMap[CurrentItem.ItemType]["Mild Elixir"]
			
			"Mild Elixir":
				#PowderIndex = newIndex
				CurrentItem = inventoyMap[CurrentItem.ItemType]["Lite Elixir"]
		
	
	#if !CurrentItem is Elixir && inventoyMap.values().has(Elixir): #!= null:
	#	
	#	#if inventoyMap.get(Elixir) >= 1:
	#		print("Equipping Elixir!")
	#		CurrentItem = inventoyMap.get(inventoyMap.find_key(Elixir))
	#else:
		
		#print("Cycling Elixirs...")
		#if (ElixirIndex + 1) > Elixirs.size() - 1:
		#	ElixirIndex = 0
		#else:
		#	ElixirIndex += 1
		#CurrentItem = Elixirs[ElixirIndex]
	#print('Setting Current Item to: ' + str(CurrentItem.Name))
		
func CyclePowder():
	
		if !CurrentItem is Powder: #&& Powders >= 1:
			print("Equipping Powder!")
			CurrentItem = inventoyMap[InventoryItem.eItemTypes.Powder]["Azalea Powder"]
		else:
			print("Cycling Powders...")
			#TODO: actually make it cycle whem more powders are created
	
	#if !CurrentItem is Powder:
	#	if Powders[PowderIndex].AmountHeld >= 1:
	#		print("Equipping Powder!")
	#		CurrentItem = Powders[PowderIndex]
	#else:
	#	print("Cycling Powders...")
	#	if (PowderIndex + 1) > Powders.size() - 1:
	#		PowderIndex = 0
	#	else:
	#		PowderIndex += 1
	#	CurrentItem = Powders[PowderIndex]
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
	
func FirstHeld (d : Dictionary):
	for i in d:
		if  d[i].AmountHeld > 0:
			return d[i]
