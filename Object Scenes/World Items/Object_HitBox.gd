extends Area2D
class_name ObjectHitBox

@onready var Parent : DestructableObject

signal Hit()

func _ready():
	Parent = get_parent()
	if get_child(0).disabled == true:
		get_child(0).disabled = false
	
func OnHurt(hurtbox : Area2D):
	if hurtbox is HurtBox && hurtbox.Parent != Parent:
		Hit.emit()
