extends Area2D
class_name ItemPickup

@export var resource : InventoryItem

func _ready():
	if resource != null:
		$Sprite2D.texture = resource.Icon
		$Sprite2D.scale = Vector2(0.5, 0.5)
	else:
		print_debug("ERROR @ ItemPickup _ready(): 'resource' NOT SET")

#Adds item to inventory
func OnPickup(body : Node2D):
	if body is Player:
		body.InventoryRef.AddItem(resource)
		self.queue_free()
