extends BasicEnemy
class_name Kitethrower

func _ready():
	Died.connect(Die)
	
func Die():
	print("\n" + str(self.name) + " has died!")
