extends DestructableObject

func Destroy():
	self.get_parent().queue_free()
