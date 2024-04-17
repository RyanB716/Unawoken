extends ShooterEnemy
class_name Eye

func TestHealth():
	match MaxHealth:
		125:
			$"Health Bar/Label".visible = false
		150:
			$"Health Bar/Label".visible = true
			$"Health Bar/Label".text = "+25"
		175:
			$"Health Bar/Label".text = "+50"
		200:
			$"Health Bar/Label".text = "+75"
		250:
			$"Health Bar/Label".text = "+125"

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
