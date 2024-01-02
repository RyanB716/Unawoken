# This class is to manage the generic HitBox component.
# Its component will be attached to any "hit-able" object ie Characters and Destructable Objects
# Upon being hit, it will emit a signal that its parent can interpret in its base controller class
# The Hurt signal contains an attacker variable, in order to derive data from it later

extends Area2D
class_name HitBox

@onready var Parent : Node2D

signal HitRecieved(amount : int)

func _ready():
	Parent = get_parent()
	if get_child(0).disabled == true:
		get_child(0).disabled = false
	
func OnHurt(hurtbox : Area2D):
	if hurtbox is HurtBox:
		if hurtbox.Parent is Projectile:
			if hurtbox.Parent.Launcher != self.Parent:
				HitRecieved.emit(hurtbox.DamageOutput)
	
		elif hurtbox.Parent != self.Parent:
			if Parent is DestructableObject:
				HitRecieved.emit(1)
			elif Parent is CharacterBody2D:
				HitRecieved.emit(hurtbox.DamageOutput)
