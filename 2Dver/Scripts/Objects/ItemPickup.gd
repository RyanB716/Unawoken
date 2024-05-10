extends Area2D
class_name ItemPickup


@export var res : InventoryItem
@onready var Amount : int

func _ready():
	if res != null:
		$Sprite2D.texture = res.Icon
		$Sprite2D.scale = Vector2(0.5, 0.5)
	else:
		print_debug("ERROR @ ItemPickup _ready(): 'resource' NOT SET")

#Adds item to inventory
func OnPickup(body : Node2D):
	if body is Player:
		body.InventoryRef.AddItem(res, Amount)
		self.queue_free()
