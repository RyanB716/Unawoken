extends Area2D
class_name HurtBox

func _ready():
	self.get_child(0).disabled = true
