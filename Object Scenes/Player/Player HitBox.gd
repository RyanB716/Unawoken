extends Area2D
class_name PlayerHitbox

@onready var PlayerRef = $".."

func TakeDamage(Amount : int):
	PlayerRef.CurrentHealth -= Amount
