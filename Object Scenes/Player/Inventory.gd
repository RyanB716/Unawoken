extends Node2D
class_name Inventory

@export var Elixirs : Array[UsableItemResource]

@onready var CurrentElixir : UsableItemResource
@onready var ElixirIndex : int = 0

func _process(delta):
	CurrentElixir = Elixirs[ElixirIndex]
	
	if Input.is_action_just_pressed("UseItem"):
		UseCurrentItem()

func AddElixir(item : UsableItemResource):
	for i in Elixirs.size():
		print(str(i) + "/" + str(Elixirs.size() - 1))
		if Elixirs[i].Name == item.Name:
			print("\nMatches!")
			print("Adding to Number Held")
			Elixirs[i].NumberHeld += 1
			print(Elixirs[i].NumberHeld)
			break
		else:
			if i == Elixirs.size() - 1:
				print("\nDoes not match!")
				print("Adding new item")
				Elixirs.append(item)
				item.NumberHeld += 1
				break
		
	print("\nElixirs Contents:")
	for i in Elixirs.size():
		print(str(i) + "/" + str(Elixirs.size() - 1) + ": " + str(Elixirs[i].Name) + ", " + str(Elixirs[i].NumberHeld))

func UseCurrentItem():
	if CurrentElixir.NumberHeld > 0:
		var player = get_parent()
		if player is Player:
			CurrentElixir.NumberHeld -= 1
			if CurrentElixir.StatType == CurrentElixir.StatTypes.Health:
				var AmntToAdd : int = int(player.CurrentHealth * (CurrentElixir.AmountInPercent * 0.01))
				player.RegainHealth(AmntToAdd)
