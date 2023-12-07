extends CharacterBody2D
class_name Player

@onready var AnimPlayer = $AnimationPlayer

@onready var AttackTimer = $Timers/AttackStateTimer
@onready var CooldownTimer = $Timers/CoolDown
@onready var SFXtime = $Timers/SFXtimer

@onready var BodyAudio = $Audio/BodyAudio
@onready var WeaponAudio = $Audio/WeaponAudio

@onready var UI = $"Player UI"

@onready var EnvColl = $"Environment Collision"
@onready var HitColl = $HitBox/CollisionShape2D

enum DirectionStates {Up, Down, Left, Right}

var CurrentDirection : int
@onready var CurrentAttackIndex : int = 1

var IsMoving = false
var IsHealing = false

@export_category("PlayerStats")
@export var MaxHealth : int
@export var MaxStaminaMoves : int
@export var StaminaRefillTime : float
var CurrentXP : int
var AddedXP : int

@export_category("Movement Stats")
@export var TopSpeed = 0
@export var Acceleration = 0.0
@export var Deceleration = 0.0

@export_category("Attack Stats")
@export var DamageOutput : int
@export var AttackTime : float
@export var CooldownTime : float
@export var InputBufferAmnt : float

@export_category("Internal References")
@export var InventoryRef : Inventory

var CurrentSpeed = 0
var HorizontalInput = 0
var VerticalInput = 0
var Direction = Vector2.ZERO

var CurrentHealth : int
var CurrentStaminaActions : int

var AnimState = null

var IsRolling = false
var IsDead = false

func _ready():
	CurrentDirection = DirectionStates.Down
	
	CurrentHealth = MaxHealth
	CurrentStaminaActions = MaxStaminaMoves
	
	UI.get_node("StaminaContainer").SetMaxIcons(MaxStaminaMoves)
	
	$"Player UI/XpLabel/Amount Label".visible = false
	CurrentXP = GameSettings.CurrentPlayerXP
	
func _process(_delta):
	if CurrentHealth <= 0 && $Timers/DeathTimer.is_stopped():
		$StateMachine.CurrentState.Transitioned.emit("Dead")
		IsDead = true
		$Timers/DeathTimer.one_shot = true
		$Timers/DeathTimer.start(8)
		
	$"Player UI/XpLabel".text = ("XP: " + str(CurrentXP))
	$"Player UI/XpLabel/Amount Label".text = ("+" + str(AddedXP))
	
	if CurrentHealth >= MaxHealth:
		CurrentHealth = MaxHealth
	
func _physics_process(_delta):
	
	if IsDead == false:
		IsMoving = Input.is_action_pressed("Run_Up") || Input.is_action_pressed("Run_Down") || Input.is_action_pressed("Run_Left") || Input.is_action_pressed("Run_Right")
	
	if IsRolling == false && IsMoving:
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
	
	if IsDead == false:
		if IsMoving:
			CurrentSpeed = TopSpeed
		elif IsRolling:
			CurrentSpeed = TopSpeed + 25
		else:
			CurrentSpeed = 0
	else:
		CurrentSpeed = 0
	
	velocity = (Direction * CurrentSpeed)
	move_and_slide()

func _on_attack_state_timer_timeout():
	CurrentAttackIndex = 1

func AttackCooldown():
	CooldownTimer.start(CooldownTime)
	await CooldownTimer.timeout
	CurrentAttackIndex = 1

func ReduceStamina(Amnt : int):
	CurrentStaminaActions -= Amnt
	UI.get_node("StaminaContainer").UpdateIcons(CurrentStaminaActions)

#Resets stamina circles 1-by-1
func ResetStamina(Amnt : int):
	for i in range(Amnt):
		
		await get_tree().create_timer(StaminaRefillTime).timeout
		
		if CurrentStaminaActions + 1 <= MaxStaminaMoves:
			CurrentStaminaActions += 1
			UI.get_node("StaminaContainer").UpdateIcons(CurrentStaminaActions)
		else:
			print_debug('ERROR @ ResetStamina(): CurrentStaminaActions += 1 would EXCEED MaxStamina variable')

#Regains a variable amount of health
func RegainHealth(Amount : int):
	if IsHealing == false:
		print("Healing: " + str(Amount) + " points!")
		IsHealing = true
		var HealthTween = get_tree().create_tween()
		HealthTween.tween_property(self, "CurrentHealth", (CurrentHealth + Amount), 0.5)
		await HealthTween.finished
		IsHealing = false

#Regains MaxHealth
func RegainFULLHealth():
	if IsHealing == false:
		IsHealing = true
		var HealthTween = get_tree().create_tween()
		HealthTween.tween_property(self, "CurrentHealth", MaxHealth, 0.5)
		await HealthTween.finished
		IsHealing = false

#Reloads the current level
func Respawn():
	print("Reloading...")
	get_tree().reload_current_scene()

#Add to the amount of XP to then be added to the total count
func AddXP(Amount : int):
	if $Timers/XPTimer.time_left > 0:
		$Timers/XPTimer.stop()
	$Timers/XPTimer.start(3)
	AddedXP += Amount
	$"Player UI/XpLabel/Amount Label".visible = true
	await $Timers/XPTimer.timeout
	DisplayXP()

#Aesthetically display the addition of XP
func DisplayXP():
	var XPTween = get_tree().create_tween()
	var AmountTween = get_tree().create_tween()
	XPTween.tween_property(self, "CurrentXP", (CurrentXP + AddedXP), 1.25)
	AmountTween.tween_property(self, "AddedXP", 0, 1.25)
	await XPTween.finished
	await AmountTween.finished
	$"Player UI/XpLabel/Amount Label".visible = false
