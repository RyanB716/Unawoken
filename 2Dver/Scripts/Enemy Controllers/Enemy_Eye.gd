extends BasicEnemy
class_name Eye

@export_category("Eye Variables")
@export var ProjectileScene : PackedScene
@export var ChangeTimer : Timer
@export var ShootTimer : Timer
@export var FlyRange : float

enum eStates {Idle, Patrol, Follow, Shoot, Dead}
var CurrentState : eStates
var RNG

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	RNG = RandomNumberGenerator.new()
	Died.connect(Die)
	CurrentState = eStates.Idle

func _process(_delta):
	TestHealth()
	Distance = PlayerTarget.position - self.position
	
	if CurrentState != eStates.Dead:
		if Distance.length() <= DetectionRange:
			CurrentState = eStates.Follow
			if Distance.length() <= AttackRange: ## && Distance.length() >= FlyRange:
				CurrentState = eStates.Shoot
			elif Distance.length() >= FlyRange:
				CurrentState = eStates.Patrol
		elif Distance.length() >= DisengagementRange:
			CurrentState = eStates.Idle
	else:
		CurrentSpeed = 0

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
			
			
			
func StateMachine():
	match CurrentState:
		eStates.Dead:
			velocity = Vector2.ZERO
		
		eStates.Idle:
			CurrentSpeed = 0
			if ChangeTimer != null and ChangeTimer.is_stopped():
				var newTime = RNG.randf_range(3, 5)
				ChangeTimer.start(newTime)
			
		eStates.Patrol:
			CurrentSpeed = BaseSpeed
			if ChangeTimer != null and ChangeTimer.is_stopped():
				var newTime = RNG.randf_range(3, 5)
				ChangeTimer.start(newTime)
				
		eStates.Follow:
			CurrentSpeed = TopSpeed
			Direction = Distance
			
		eStates.Shoot:
			CurrentSpeed = 0
			if ShootTimer != null and ShootTimer.is_stopped():
				ShootProjectile()


func ChangeState():
	RNG.randomize()
	var newValue = RNG.randi_range(0, 100)
	if newValue >= 50:
		if CurrentState == eStates.Idle:
			CurrentState = eStates.Patrol
			Direction = Vector2(RNG.randf_range(-1, 1), RNG.randf_range(-1, 1))
		elif CurrentState == eStates.Patrol:
			CurrentState = eStates.Idle


func ShootProjectile():
	var newProjectile = ProjectileScene.instantiate()
	if newProjectile is Projectile:
		newProjectile.Launcher = self
		newProjectile.Damage = self.Damage
		newProjectile.Direction = Distance
		add_child(newProjectile)
	ShootTimer.start(2.5)

func Die():
	print("\n" + str(self.name) + " has died!")
	HitBox.call_deferred("Disable")
	self.EnvCollider.set_deferred("disabled", true)
	CurrentState = eStates.Dead
	await get_tree().create_timer(1.5).timeout
	self.queue_free()

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
