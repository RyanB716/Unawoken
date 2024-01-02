extends RigidBody2D
class_name Projectile

var Launcher : Node2D
var Damage : int
var Direction : Vector2

@export var Speed : float

func _enter_tree():
	self.linear_velocity = Direction.normalized() * Speed
	
func _on_body_entered(body):
	if body is HitBox && body.Parent == Launcher:
		pass
	else:
		self.queue_free()
