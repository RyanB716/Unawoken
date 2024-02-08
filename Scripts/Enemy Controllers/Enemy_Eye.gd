extends ShooterEnemy
class_name Eye

func TestHealth():
	$"Health Bar/Label".text = (str(CurrentHealth) + "/" + str(MaxHealth))

func AnxietyEffect(percent : float):
	#print("Percent: " + str(percent))
	var fCurrentHealth : float = float(CurrentHealth)
	var fMaxHealth : float = float(MaxHealth)
	var HealthPercentage : float = snapped((fCurrentHealth / fMaxHealth), 0.01)
	#print("Health is filled: " + str(HealthPercentage) + "%")
	
	if percent >= 0.25 && percent < 0.5:
		MaxHealth = 150
	elif percent >= 0.5 && percent < 0.75:
		MaxHealth = 175
	elif percent >= 0.75 && percent < 1.00:
		MaxHealth = 200
	elif percent >= 1.00:
		MaxHealth = 250
	else:
		MaxHealth = 125

	CurrentHealth = MaxHealth * HealthPercentage
	#print("New Max Health: " + str(MaxHealth) + " // New Current Health: " + str(self.CurrentHealth))
