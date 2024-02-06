extends InventoryItem
class_name Elixir

signal Heal(amnt : float)

@export_category("Elixir")
@export var AmountInPercent : int

func Effect():
	Heal.emit(AmountInPercent)
