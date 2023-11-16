extends CharacterBody2D
class_name BasicEnemy

@export_category("General Stats")
@export var MaxHealth : int
@export var XpAmount : int

@export_category("Combat Stats")
var CurrentHealth : int
@export var NumberOfAttacks : int
@export var DamageOutput : int

@export_category("Movement Stats")
@export var BaseSpeed : float
@export var TopSpeed : float

@export_category("Surveilance Stats")
@export var DetectionRange : float
@export var DisengagementRange : float
@export var AttackRange : float

var PlayerTarget : Player
var AnimPlayer : AnimationPlayer
var IsAttacking : bool = false
var IsDead : bool = false
enum DirectionStates {Up, Down, Left, Right}
var CurrentDirection : int

func _ready():
	CurrentHealth = MaxHealth

func _physics_process(_delta):
	move_and_slide()
