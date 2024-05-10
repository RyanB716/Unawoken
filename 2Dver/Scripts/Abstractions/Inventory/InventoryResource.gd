extends Resource
class_name InventoryResource

#@export var ElixirsArray : Array[Elixir]
#@export var PowdersArray : Array[Powder]
#const liteelixir  = "res://Content/Resources/Usable Items/LiteElixir.tres"
#const medelixir = "res://Content/Resources/Usable Items/MedElixir.tres"
#const powder = "res://Content/Resources/Usable Items/BluePowder.tres"

var InventoryStorage : Dictionary 

var Elixirs : int = 0
var Powders : int = 0

var KeyAmount : int = 0
var CoinAmount : int = 0

var ElixerEquiped : Elixir
var PowerEquiped : Powder
var CurrentItem : InventoryItem

func _init():
	InventoryStorage = 	{InventoryItem.eItemTypes.Elixir :
		{"Lite Elixir" : load("res://Content/Resources/Usable Items/LiteElixir.tres").duplicate() , "Mild Elixir" : load("res://Content/Resources/Usable Items/MedElixir.tres").duplicate()} ,
		 InventoryItem.eItemTypes.Powder : {"Azalea Powder" : load("res://Content/Resources/Usable Items/BluePowder.tres").duplicate()}
		}	
	print("break")


