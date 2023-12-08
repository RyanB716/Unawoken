extends Resource
class_name UsableItemResource

@export_category("Data")
@export var Name : String
enum StatTypes {Stamina, Health}
@export var StatType : StatTypes
@export var AmountInPercent : int

@export_category("Aesthetics")
@export var Icon : Texture2D
@export var PickupSFX : AudioStream
@export var UseSFX : AudioStream
@export var Description : String
