extends Node

@export var MaxHealth : int
var CurrentHealth : int

func _ready():
	CurrentHealth = MaxHealth
	
func TakeDamage(Amount : int):
	CurrentHealth -= Amount
	print(CurrentHealth)
