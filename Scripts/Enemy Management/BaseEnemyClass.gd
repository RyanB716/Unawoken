extends CharacterBody2D
class_name BasicEnemy

@export_category("General Stats")
@export var MaxHealth : int
@export var XpAmount : int

var CurrentHealth : int

@export_category("Movement Stats")
@export var BaseSpeed : float
@export var TopSpeed : float

@export_category("Surveilance Stats")
@export var DetectionRange : float
@export var DisengagementRange : float
@export var AttackRange : float

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var Hit_Box : CharacterHitBox
@export var HealthBar : ProgressBar

var PlayerTarget : Player

var IsAttacking : bool = false
var IsDead : bool = false

func _ready():
	PlayerTarget = get_tree().get_first_node_in_group("Player")
	
	CurrentHealth = MaxHealth
	HealthBar.max_value = MaxHealth
	
	Hit_Box.Hurt.connect(TakeDamage)
	
func _process(delta):
	HealthBar.value = CurrentHealth

func _physics_process(_delta):
	move_and_slide()

func TakeDamage(Amount : int):
	CurrentHealth -= Amount
