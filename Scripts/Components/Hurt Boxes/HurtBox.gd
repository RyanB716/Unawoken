extends Area2D
class_name HurtBox

@onready var GameCamera = get_tree().get_first_node_in_group("Cameras")

func _ready():
	self.get_child(0).disabled = true
