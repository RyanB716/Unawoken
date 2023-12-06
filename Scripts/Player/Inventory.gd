extends Node2D
class_name Inventory

@export var Elixirs : Array[InventorySlot]

@onready var CurrentElixir : InventorySlot
@onready var ElixirIndex : int = 0

@onready var CoinCount : int = 0

func _process(delta):
	if Elixirs[0].Amount > 0:
		CurrentElixir = Elixirs[ElixirIndex]
	
	if Input.is_action_just_pressed("UseItem"):
		UseCurrentItem()
	
	if Input.is_action_just_pressed("CycleElixir"):
		CycleElixir()

#Adds a new Elixir item to proper inventory
func AddElixir(item : UsableItemResource):
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
				if CurrentElixir == null:
					CurrentElixir = Elixirs[i]
				break
		
	print("\nElixirs Contents:")
	for i in Elixirs.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Item.Name) + ", " + str(Elixirs[i].Amount))

#Uses the current item
func UseCurrentItem():
	if CurrentElixir.Amount> 0:
		var player = get_parent()
		if player is Player:
			if CurrentElixir.Item.StatType == CurrentElixir.Item.StatTypes.Health:
				if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
					CurrentElixir.Amount -= 1
					var AmntToAdd : int = int(player.MaxHealth * (CurrentElixir.Item.AmountInPercent * 0.01))
					player.RegainHealth(AmntToAdd)

#Cycles the Elixir inventory upward
func CycleElixir():
	if CurrentElixir != null:
		if (ElixirIndex + 1) > Elixirs.size() - 1:
				ElixirIndex = 0
		else:
			ElixirIndex += 1
