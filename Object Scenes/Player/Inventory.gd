extends Node2D
class_name Inventory

@export var Elixirs : Array[UsableItemResource]

@onready var CurrentElixir : UsableItemResource
@onready var ElixirIndex : int = 0

@onready var CoinCount : int = 0

func _process(delta):
	if Elixirs[ElixirIndex] && Elixirs[ElixirIndex].NumberHeld > 0:
		CurrentElixir = Elixirs[ElixirIndex]
	
	if Input.is_action_just_pressed("UseItem"):
		UseCurrentItem()
	
	if Input.is_action_just_pressed("CycleElixir"):
		CycleElixir()

func AddElixir(item : UsableItemResource):
	for i in Elixirs.size():
		if Elixirs[i].Name == item.Name:
			print("\nMatches!")
			print("Adding to Number Held")
			Elixirs[i].NumberHeld += 1
			break
		else:
			if i == Elixirs.size() - 1:
				print("\nDoes not match!")
				print("Adding new item")
				Elixirs.append(item)
				item.NumberHeld += 1
				if CurrentElixir == null:
					CurrentElixir = Elixirs[i]
				break
		
	print("\nElixirs Contents:")
	for i in Elixirs.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Name) + ", " + str(Elixirs[i].NumberHeld))

func UseCurrentItem():
	if CurrentElixir.NumberHeld > 0:
		var player = get_parent()
		if player is Player:
			if player.CurrentHealth < player.MaxHealth && player.IsHealing == false:
				CurrentElixir.NumberHeld -= 1
				if CurrentElixir.StatType == CurrentElixir.StatTypes.Health:
					var AmntToAdd : int = int(player.MaxHealth * (CurrentElixir.AmountInPercent * 0.01))
					player.RegainHealth(AmntToAdd)
					

func CycleElixir():
	if CurrentElixir != null:
		if (ElixirIndex + 1) > Elixirs.size() - 1:
				ElixirIndex = 0
		else:
			ElixirIndex += 1
