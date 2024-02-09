extends Area2D
class_name Hurt_Box

@onready var Parent
var DamageOutput

func _ready():
	Parent = get_parent()
	
	if !Parent is Projectile:
		self.get_child(0).disabled = true
		
func _process(delta):
	if Parent is Player:
		DamageOutput = Parent.CurrentDamage
		#print("Current Damage: " + str(Parent.CurrentDamage))
	if Parent is BasicEnemy:
		DamageOutput = Parent.Damage
	if Parent is Projectile:
		DamageOutput = Parent.Damage
