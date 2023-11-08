extends DestructableObject
class_name Pot

func Destroy():
	self.get_parent().queue_free()
