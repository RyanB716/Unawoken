extends Node2D
class_name InventoryManager

@export var InventoryData : InventoryResource


#var Elixirs : Array[Elixir]
#var Powders : Array[Powder]


#@onready var inventoyMap : Dictionary
#var Coins : int

@onready var player : Player = get_parent()
@onready var InvSFX : InventoryAudio = $InventoryAudio


#@export var InventoyMap : Dictionary 


#@onready var	InitInv = {InventoryItem.eItemTypes.Elixir :
		 #{"Lite Elixir" : load("res://Content/Resources/Usable Items/LiteElixir.tres").duplicate() , "Mild Elixir" : load("res://Content/Resources/Usable Items/MedElixir.tres").duplicate()} ,
		 #InventoryItem.eItemTypes.Powder : {"Azalea Powder" : load("res://Content/Resources/Usable Items/BluePowder.tres").duplicate()}
	#}	
	
func _ready():
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("CycleElixir") && InventoryData.Elixirs > 0:
		CycleElixir()
	
	if Input.is_action_just_pressed("CyclePowder") && InventoryData.Powders > 0:
		CyclePowder()
		
	#Coins = InventoryData.CoinAmount
#Adds a new item to proper inventory
func AddItem(item : InventoryItem, amount : int):
	#Key : InventoryItem Name   Value : InventoryItem Object
	
	match InventoryData.InventoryStorage[item.ItemType][item.Name].ItemType:
		InventoryItem.eItemTypes.Elixir:
			if !InventoryData.InventoryStorage[item.ItemType][item.Name].Heal.is_connected(player.RegainHealth):
				InventoryData.InventoryStorage[item.ItemType][item.Name].Heal.connect(player.RegainHealth)
			AddItemDelegate(InventoryData.InventoryStorage[item.ItemType][item.Name], amount)
			#if Powders <= 0:
				#CycleElixir()
				
		InventoryItem.eItemTypes.Powder:
			if !InventoryData.InventoryStorage[item.ItemType][item.Name].UpdateAnxiety.is_connected(player.GM.RestartAnxietyFill):
				InventoryData.InventoryStorage[item.ItemType][item.Name].UpdateAnxiety.connect(player.GM.RestartAnxietyFill)
			AddItemDelegate(InventoryData.InventoryStorage[item.ItemType][item.Name], amount)
			print("AddItemDelegate" + str(InventoryData.InventoryStorage[item.ItemType]))
			#if Elixirs <= 0:
				#CyclePowder()
				
		InventoryItem.eItemTypes.Key:
			pass
			
	InvSFX.PlaySFX(item.PickupSFX)
	
func AddItemDelegate(_item : InventoryItem,  amount : int):
	
	InventoryData.InventoryStorage[_item.ItemType][_item.Name].AmountHeld += amount
	match _item.ItemType:
		InventoryItem.eItemTypes.Elixir :
			InventoryData.Elixirs += amount
			
			if InventoryData.CurrentItem == null: 
				InventoryData.CurrentItem = InventoryData.InventoryStorage[_item.ItemType][_item.Name]
			if InventoryData.ElixerEquiped == null:
				InventoryData.ElixerEquiped = InventoryData.InventoryStorage[_item.ItemType][_item.Name]
		InventoryItem.eItemTypes.Powder :
			InventoryData.Powders += amount
			
			if InventoryData.CurrentItem == null:
				InventoryData.CurrentItem = InventoryData.InventoryStorage[_item.ItemType][_item.Name]
			if InventoryData.PowerEquiped == null:
				InventoryData.PowerEquiped = InventoryData.InventoryStorage[_item.ItemType][_item.Name]
	
#Uses the current item
func UseCurrentItem():
	match InventoryData.CurrentItem.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				InventoryData.CurrentItem.UseItem()
				InventoryData.Elixirs -= 1
				InvSFX.PlaySFX(InventoryData.CurrentItem.UseSFX)
				
				if InventoryData.CurrentItem.AmountHeld <= 0:
					RemoveItem(InventoryData.CurrentItem)
		
		InventoryItem.eItemTypes.Powder:
			InventoryData.CurrentItem.UseItem()
			InventoryData.Powders -= 1
			InvSFX.PlaySFX(InventoryData.CurrentItem.UseSFX)
			
			if InventoryData.CurrentItem.AmountHeld <= 0:
				RemoveItem(InventoryData.CurrentItem)
	
func RemoveItem(item : InventoryItem):
	# check amount of consumables, manages item UI
	# change for scalability
	match item.ItemType:
		InventoryItem.eItemTypes.Elixir:
			if InventoryData.Elixirs > 0:
				for i in InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]:
					if InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir][i].AmountHeld > 0:
						InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir][i]
						InventoryData.ElixerEquiped = InventoryData.CurrentItem
						break
			elif InventoryData.Powders > 0:
				for i in InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder]:
					if InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder][i].AmountHeld > 0:
						InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder][i]
						InventoryData.ElixerEquiped = null
						InventoryData.PowerEquiped = InventoryData.CurrentItem
						break
			else:
				InventoryData.CurrentItem = null
				InventoryData.ElixerEquiped = null
				
		InventoryItem.eItemTypes.Powder:
			if InventoryData.Elixirs > 0 && InventoryData.Powders <= 0:
				for i in InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]:
					if i.AmountHeld > 0:
						InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir][i]
						InventoryData.ElixerEquiped = InventoryData.CurrentItem
						break
			else:
				InventoryData.ElixerEquiped = null
				InventoryData.PowerEquiped = null
				InventoryData.CurrentItem = null

#Cycles the Elixir inventory upward
func CycleElixir():
	
	if !InventoryData.CurrentItem is Elixir: #&& Elixirs >= 1: 
		print("Equipping Elixir!")		
		var temp = FirstHeld(InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir])
		InventoryData.CurrentItem = temp
		InventoryData.ElixerEquiped = InventoryData.CurrentItem
		
	else:
		
		match InventoryData.CurrentItem.Name:
			"Lite Elixir":
				#ElixirIndex = newIndex
				if InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Mild Elixir"].AmountHeld > 0:
					print("Cycling Elixirs...")
					InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Mild Elixir"]
					InventoryData.ElixerEquiped = InventoryData.CurrentItem
			"Mild Elixir":
				#PowderIndex = newIndex
				if InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Lite Elixir"].AmountHeld > 0:
					print("Cycling Elixirs...")
					InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Lite Elixir"]
					InventoryData.ElixerEquiped = InventoryData.CurrentItem
	
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
	
		if !InventoryData.CurrentItem is Powder: #&& Powders >= 1:
			print("Equipping Powder!")
			InventoryData.CurrentItem = InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder]["Azalea Powder"]
			InventoryData.PowerEquiped = InventoryData.CurrentItem
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
