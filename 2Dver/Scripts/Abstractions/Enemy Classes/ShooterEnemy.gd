extends BasicEnemy
class_name ShooterEnemy

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
			if Distance.length() <= AttackRange && Distance.length() >= FlyRange:
				CurrentState = eStates.Shoot
			elif Distance.length() >= FlyRange:
				CurrentState = eStates.Patrol
		elif Distance.length() >= DisengagementRange:
			CurrentState = eStates.Idle
	else:
		CurrentSpeed = 0

func StateMachine():
	match CurrentState:
		eStates.Dead:
			velocity = Vector2.ZERO
		
		eStates.Idle:
			CurrentSpeed = 0
			if ChangeTimer.is_stopped():
				var newTime = RNG.randf_range(3, 5)
				ChangeTimer.start(newTime)
			
		eStates.Patrol:
			CurrentSpeed = BaseSpeed
			if ChangeTimer.is_stopped():
				var newTime = RNG.randf_range(3, 5)
				ChangeTimer.start(newTime)
				
		eStates.Follow:
			CurrentSpeed = TopSpeed
			Direction = Distance
			
		eStates.Shoot:
			CurrentSpeed = 0
			if ShootTimer.is_stopped():
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

func TestHealth():
	pass
