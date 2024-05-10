extends InventoryItem
class_name Elixir

signal Heal(amnt : float)

@export_category("Elixir")
@export var AmountInPercent : int

#enum ElixirTiers {LiteElixir,MildElixir}
#@export var Tier : ElixirTiers

func Effect():
	Heal.emit(AmountInPercent)
