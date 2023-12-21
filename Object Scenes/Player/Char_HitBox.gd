# This class is to manage the generic HitBox component.
# Its component will be attached to any "hit-able" object ie Characters and Destructable Objects
# Upon being hit, it will emit a signal that its parent can interpret in its base controller class
# The Hurt signal contains an attacker variable, in order to derive data from it later

extends Area2D
class_name CharacterHitBox

@onready var Parent : CharacterBody2D

signal Hurt(amount : int)

func _ready():
	Parent = get_parent()
	if get_child(0).disabled == true:
		get_child(0).disabled = false
	
func OnHurt(hurtbox : Area2D):
	if hurtbox is HurtBox && hurtbox.Parent != Parent:
		print("On Hurt activated")
		Hurt.emit(hurtbox.DamageOutput)
