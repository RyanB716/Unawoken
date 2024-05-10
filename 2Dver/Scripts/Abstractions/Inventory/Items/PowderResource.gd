extends InventoryItem
class_name Powder

signal UpdateAnxiety(time : float, amount : float)

@export_category("Powder")
@export var TimeToAdd : float
@export var PercentToSubtract : float

func Effect():
	UpdateAnxiety.emit(TimeToAdd, PercentToSubtract)
