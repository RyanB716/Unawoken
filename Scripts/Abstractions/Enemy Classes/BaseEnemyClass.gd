extends CharacterBody2D
class_name BasicEnemy

signal Died()
signal OnDeath(time : float)
signal OnHit(intensity : float, dur : float)

@export_category("General Stats")
@export var MaxHealth : int
@export var XpAmount : int
@export var Damage : int
var CurrentHealth : int

@export_category("Movement Stats")
@export var BaseSpeed : float
@export var TopSpeed : float
var CurrentSpeed : float
var Direction : Vector2 = Vector2.ZERO
var Distance

@export_category("Surveilance Stats")
@export var DetectionRange : float
@export var DisengagementRange : float
@export var AttackRange : float

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var HitBox : Hit_Box
@export var HealthBar : ProgressBar

var PlayerTarget : Player

var IsAttacking : bool = false
var IsDead : bool = false

func _enter_tree():
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
	HitBox.HitRecieved.connect(TakeDamage)

	var GM : GameManager = get_tree().current_scene
	OnHit.connect(GM.CamShake)
	OnDeath.connect(GM.HitStop)

func _physics_process(_delta):
	HealthBar.value = CurrentHealth
	StateMachine()
	velocity = Direction.normalized() * CurrentSpeed
	move_and_slide()
	
func StateMachine():
	pass

func TakeDamage(Amount : int):
	OnHit.emit(0.75, 0.25)
	CurrentHealth -= Amount
	
	if CurrentHealth <= 0:
		OnHit.emit(1.25, 0.5)
		Died.emit()
		OnDeath.emit(0.15)
		
func AnxietyEffect(percent : float):
	print("Enabling effect for: " + str(percent) + " percent!")
