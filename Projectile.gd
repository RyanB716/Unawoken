extends RigidBody2D
class_name Projectile

var Damage : int
var Direction : Vector2

@export var Speed : float

func _enter_tree():
	self.linear_velocity = Direction.normalized() * Speed

func _on_body_entered(body):
	print("Hit object")
	print(Damage)
	self.queue_free()
