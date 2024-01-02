extends Area2D
class_name HurtBox

@onready var Parent
var DamageOutput

func _ready():
	Parent = get_parent()
	
	if Parent is Player || Parent is BasicEnemy:
		DamageOutput = Parent.Damage
	elif Parent is Projectile:
		DamageOutput = Parent.Damage
	
	if !Parent is Projectile:
		self.get_child(0).disabled = true
