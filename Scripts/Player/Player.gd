extends CharacterBody2D
class_name Player

@onready var AnimTree = $AnimationTree
@onready var AttackTimer = $Timers/AttackStateTimer
@onready var B_Audio = $Audio/BodyAudio
@onready var W_Audio = $Audio/WeaponAudio
@onready var UI = $"Player UI"

enum DirectionStates {Up, Down, Left, Right}
enum MoveStates {Idle, Run, Roll}
enum AttackActionStates {NotAttacking, IsAttacking, Cooldown}
enum AttackSlots {Attack1, Attack2, Attack3}

var CurrentMoveState : int
var CurrentDirection : int
var CurrentAttackState : int
var CurrentAttackIndex : int

var IsMoving = false

@export_category("PlayerStats")
@export var MaxHealth : int
@export var MaxStaminaMoves : int
@export var StaminaRefillTime : float

@export_category("Movement Stats")
@export var TopSpeed = 0
@export var Acceleration = 0.0
@export var Deceleration = 0.0
@export var RollTime = 0.0

@export_category("Attack Stats")
@export var AttackTime : float
@export var CooldownTime : float
@export var InputBufferAmnt : float

var CurrentSpeed = 0
var HorizontalInput = 0
var VerticalInput = 0
var Direction = Vector2.ZERO

var CurrentHealth : int
var CurrentStaminaActions : int

var AnimState = null

func _ready():
	CurrentDirection = DirectionStates.Down
	
	CurrentHealth = MaxHealth
	CurrentStaminaActions = MaxStaminaMoves
	
	UI.get_node("StaminaContainer").SetMaxIcons(MaxStaminaMoves)

func _physics_process(delta):
	
	IsMoving = Input.is_action_pressed("Run_Up") || Input.is_action_pressed("Run_Down") || Input.is_action_pressed("Run_Left") || Input.is_action_pressed("Run_Right")
	
	if Input.is_action_pressed("Run_Up"):
		CurrentDirection = DirectionStates.Up
		Direction = Vector2.UP
	elif Input.is_action_pressed("Run_Down"):
		CurrentDirection = DirectionStates.Down
		Direction = Vector2.DOWN
	elif Input.is_action_pressed("Run_Right"):
		CurrentDirection = DirectionStates.Right
		Direction = Vector2.RIGHT
	elif Input.is_action_pressed("Run_Left"):
		CurrentDirection = DirectionStates.Left
		Direction = Vector2.LEFT
	
	if IsMoving:
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, Acceleration * delta)
		
	else:
		CurrentSpeed = lerpf(CurrentSpeed, 0, Deceleration * delta)
	
	velocity = (Direction * CurrentSpeed)
	move_and_slide()
	
func Roll():
	ReduceStamina(1)
	
	B_Audio.PlaySFX()
	$CollisionShape2D.disabled = true
	CurrentMoveState = MoveStates.Roll
	
	var PrevSpeed = CurrentSpeed
	CurrentSpeed = PrevSpeed * 0.75
	
	await get_tree().create_timer(RollTime).timeout
	$CollisionShape2D.disabled = false
	CurrentMoveState = MoveStates.Idle
	
	CurrentSpeed = PrevSpeed

func _on_attack_state_timer_timeout():
	CurrentAttackIndex = AttackSlots.Attack1

func AttackCooldown():
	print("Cooldown STARTED!")
	await get_tree().create_timer(CooldownTime).timeout
	CurrentAttackState = AttackActionStates.NotAttacking
	CurrentAttackIndex = AttackSlots.Attack1
	print('Cooldown FINISHED!')
	
func TakeDamage(Amount : int):
	CurrentHealth -= Amount

func ReduceStamina(Amnt : int):
	CurrentStaminaActions -= Amnt
	UI.get_node("StaminaContainer").UpdateIcons(CurrentStaminaActions)
	
	for i in range(Amnt):
		ResetStamina()

func ResetStamina():
	await get_tree().create_timer(StaminaRefillTime).timeout
	if CurrentStaminaActions + 1 <= MaxStaminaMoves:
		CurrentStaminaActions += 1
		UI.get_node("StaminaContainer").UpdateIcons(CurrentStaminaActions)
	else:
		print('ERROR @ ResetStamina(): CurrentStaminaActions += 1 would EXCEED MaxStamina variable')
