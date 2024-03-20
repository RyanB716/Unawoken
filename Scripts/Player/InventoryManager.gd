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

@export var ElixerEquiped : Elixir
@export var PowerEquiped : Powder

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
	
	match inventoyMap[item.ItemType][item.Name].ItemType:
		InventoryItem.eItemTypes.Elixir:
			if !inventoyMap[item.ItemType][item.Name].Heal.is_connected(player.RegainHealth):
				inventoyMap[item.ItemType][item.Name].Heal.connect(player.RegainHealth)
			AddItemDelegate(inventoyMap[item.ItemType][item.Name], amount)
			#if Powders <= 0:
				#CycleElixir()
				
		InventoryItem.eItemTypes.Powder:
			if !inventoyMap[item.ItemType][item.Name].UpdateAnxiety.is_connected(player.GM.RestartAnxietyFill):
				inventoyMap[item.ItemType][item.Name].UpdateAnxiety.connect(player.GM.RestartAnxietyFill)
			AddItemDelegate(inventoyMap[item.ItemType][item.Name], amount)
			print("AddItemDelegate" + str(inventoyMap[item.ItemType]))
			#if Elixirs <= 0:
				#CyclePowder()
				
		InventoryItem.eItemTypes.Key:
			pass
			
	InvSFX.PlaySFX(item.PickupSFX)
	
func AddItemDelegate(_item : InventoryItem,  amount : int):
	
	inventoyMap[_item.ItemType][_item.Name].AmountHeld += amount
	match _item.ItemType:
		InventoryItem.eItemTypes.Elixir :
			Elixirs += amount
			
			if CurrentItem == null: 
				CurrentItem = inventoyMap[_item.ItemType][_item.Name]
			if ElixerEquiped == null:
				ElixerEquiped = inventoyMap[_item.ItemType][_item.Name]
		InventoryItem.eItemTypes.Powder :
			Powders += amount
			
			if CurrentItem == null:
				CurrentItem = inventoyMap[_item.ItemType][_item.Name]
			if PowerEquiped == null:
				PowerEquiped = inventoyMap[_item.ItemType][_item.Name]
	
#Uses the current item
func UseCurrentItem():
	match CurrentItem.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				CurrentItem.UseItem()
				Elixirs -= 1
				InvSFX.PlaySFX(CurrentItem.UseSFX)
				
				if CurrentItem.AmountHeld <= 0:
					RemoveItem(CurrentItem)
		
		InventoryItem.eItemTypes.Powder:
			CurrentItem.UseItem()
			Powders -= 1
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
					if inventoyMap[InventoryItem.eItemTypes.Elixir][i].AmountHeld > 0:
						CurrentItem = inventoyMap[InventoryItem.eItemTypes.Elixir][i]
						ElixerEquiped = CurrentItem
						break
			elif Powders > 0:
				for i in inventoyMap[InventoryItem.eItemTypes.Powder]:
					if inventoyMap[InventoryItem.eItemTypes.Powder][i].AmountHeld > 0:
						CurrentItem = inventoyMap[InventoryItem.eItemTypes.Powder][i]
						ElixerEquiped = null
						PowerEquiped = CurrentItem
						break
			else:
				CurrentItem = null
				ElixerEquiped = null
				
		InventoryItem.eItemTypes.Powder:
			if Elixirs > 0 && Powders <= 0:
				for i in inventoyMap[InventoryItem.eItemTypes.Elixir]:
					if i.AmountHeld > 0:
						CurrentItem = inventoyMap[InventoryItem.eItemTypes.Elixir][i]
						ElixerEquiped = CurrentItem
						break
			else:
				ElixerEquiped = null
				PowerEquiped = null
				CurrentItem = null

#Cycles the Elixir inventory upward
func CycleElixir():
	
	if !CurrentItem is Elixir: #&& Elixirs >= 1: 
		print("Equipping Elixir!")		
		var temp = FirstHeld(inventoyMap[InventoryItem.eItemTypes.Elixir])
		CurrentItem = temp
		ElixerEquiped = CurrentItem
		
	else:
		
		match CurrentItem.Name:
			"Lite Elixir":
				#ElixirIndex = newIndex
				if inventoyMap[InventoryItem.eItemTypes.Elixir]["Mild Elixir"].AmountHeld > 0:
					print("Cycling Elixirs...")
					CurrentItem = inventoyMap[InventoryItem.eItemTypes.Elixir]["Mild Elixir"]
					ElixerEquiped = CurrentItem
			"Mild Elixir":
				#PowderIndex = newIndex
				if inventoyMap[InventoryItem.eItemTypes.Elixir]["Lite Elixir"].AmountHeld > 0:
					print("Cycling Elixirs...")
					CurrentItem = inventoyMap[InventoryItem.eItemTypes.Elixir]["Lite Elixir"]
					ElixerEquiped = CurrentItem
	
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
			PowerEquiped = CurrentItem
		else:
			print("Cycling Powders...")
			#CurrentItem = 
			#PowerEquiped = CurrentItem
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
