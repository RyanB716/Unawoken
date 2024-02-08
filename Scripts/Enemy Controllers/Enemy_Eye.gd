extends ShooterEnemy
class_name Eye

func TestHealth():
	$"Health Bar/Label".text = (str(CurrentHealth) + "/" + str(MaxHealth))

func AnxietyEffect(percent : float):
	MaxHealth = MaxHealth + (MaxHealth * 0.25)
	CurrentHealth = CurrentHealth + (CurrentHealth * 0.25)
	#print("New Max Health: " + str(MaxHealth) + " // New Current Health: " + str(self.CurrentHealth))
