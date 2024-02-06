extends Resource
class_name InventoryItem

@export_category("Data")
@export var Name : String
enum eItemTypes {Elixir, Powder, Key}
@export var ItemType : eItemTypes
@export var Icon : Texture2D
@export var PickupSFX : AudioStream
@export var UseSFX : AudioStream
@export var Description : String
@export var AmountHeld : int


func UseItem():
	print("Using " + str(Name))
	AmountHeld -= 1
	Effect()

func Effect():
	pass
