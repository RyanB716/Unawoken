extends Area2D
class_name HurtBox

@onready var Parent

func _ready():
	Parent = get_parent()
	self.get_child(0).disabled = true
