extends CharacterBody2D
class_name BasicEnemy

signal Died()

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
@export var Hit_Box : HitBox
@export var HealthBar : ProgressBar

var PlayerTarget : Player

var IsAttacking : bool = false
var IsDead : bool = false

func _enter_tree():
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
	Hit_Box.HitRecieved.connect(TakeDamage)

func _physics_process(_delta):
	HealthBar.value = CurrentHealth
	StateMachine()
	velocity = Direction.normalized() * CurrentSpeed
	move_and_slide()
	
func StateMachine():
	pass

func TakeDamage(Amount : int):
	CurrentHealth -= Amount
	
	if CurrentHealth <= 0:
		Died.emit()
