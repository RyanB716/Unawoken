extends ShooterEnemy
class_name Eye

func TestHealth():
	$"Health Bar/Label".text = (str(CurrentHealth) + "/" + str(MaxHealth))

func AnxietyEffect(percent : float):
	var fCurrentHealth : float = float(CurrentHealth)
	var fMaxHealth : float = float(MaxHealth)
	var HealthPercentage : float = (fCurrentHealth / fMaxHealth)
	print("Health is filled: " + str(HealthPercentage) + "%")
	
	match percent:
		0.25:
			MaxHealth = 150
		0.5:
			MaxHealth = 175
		0.75:
			MaxHealth = 200
		1.00:
			MaxHealth = 250

	CurrentHealth = MaxHealth * HealthPercentage
	print("New Max Health: " + str(MaxHealth) + " // New Current Health: " + str(self.CurrentHealth))
