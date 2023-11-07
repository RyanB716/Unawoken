extends Area2D
class_name HurtBox

@onready var ParentRef = $".."

func _on_area_entered(area):
	if area is PlayerHitbox:
		print("Connected")
		area.TakeDamage(ParentRef.DamageMinimum)
