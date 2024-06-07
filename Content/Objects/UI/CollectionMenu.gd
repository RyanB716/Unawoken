extends ColorRect
class_name CollectionMenuController

func _ready():
	visible = false
	
func Open():
	#print("Bringing up Collection Menu")
	visible = true
