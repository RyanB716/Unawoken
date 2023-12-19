extends Area2D
class_name HurtBox

@onready var Parent

signal Struck(target : CharacterBody2D)

func _ready():
	Parent = get_parent()
	self.get_child(0).disabled = true

func WeaponHit(hitbox : Area2D):
	if hitbox is HitBox && hitbox.Parent != Parent:
		#print(str(Parent.name) + "'s weapon has struck: " + str(hitbox.Parent.name))
		Struck.emit(hitbox.Parent)
