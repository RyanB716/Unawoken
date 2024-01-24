#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

enum eStates {CanAttack, Attacking, AttackCooldown, Guard, InMenu, Dead}
var CurrentState : eStates

@export_category("Player Stats")
@export var WalkSpeed : float
@export var MaxHealth : int
var CurrentHealth : int
@export var MaxStaminaActions : int
var CurrentStamina : int
@export var StaminaRefill : float

@export_category("Attack Stats")
@export var Damage : int
@export var AttackTime : float
@export var AttackCooldown : float
@export var MaxAttackNumber : int = 3

var CurrentSpeed : float = 0
var Direction
var AttackIndex : int = 1
var LastDirection : Vector2
var animID : String

var IsHealing : bool = false

@export_category("Components")
@export var InventoryRef : Inventory
@export var UI : PlayerUI
@export var HitBox : Hit_Box
@export var HurtBox : Hurt_Box

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var AttackTimer : Timer
@export var CooldownTimer : Timer
@export var BodyAudio : BodyAudioPlayer
@export var WeaponAudio : WeaponAudioPlayer

func _ready():
	CurrentState = eStates.CanAttack
	Direction = Vector2.DOWN
	LastDirection = Vector2.DOWN
	
	UI.UpdateAttackIcons(MaxAttackNumber)
	UI.SetStaminaIcons(MaxStaminaActions)
	
	CurrentHealth = MaxHealth
	CurrentStamina = MaxStaminaActions
	
	HitBox.HitRecieved.connect(TakeDamage)
	
func _process(_delta):
	if CurrentState == eStates.Dead:
		return
	
	InputManager()
	StateMachine()
	AnimationManager()
	
func _physics_process(_delta):
	velocity = (Direction * CurrentSpeed)
	move_and_slide()
	
func StateMachine():
	match CurrentState:
		eStates.Dead:
			velocity = Vector2.ZERO
	
func InputManager():
	if CurrentState == eStates.InMenu:
		return
	
	Direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down").normalized()
	
	if Direction != Vector2.ZERO:
		
		CurrentSpeed = WalkSpeed
		BodyAudio.PlayStep()
		
		if CurrentState != eStates.Attacking:
			match Direction:
				Vector2.UP:
					AnimPlayer.play("Run_Up")
					LastDirection = Vector2.UP
				Vector2.DOWN:
					AnimPlayer.play("Run_Down")
					LastDirection = Vector2.DOWN
				Vector2.LEFT:
					AnimPlayer.play("Run_Left")
					LastDirection = Vector2.LEFT
				Vector2.RIGHT:
					AnimPlayer.play("Run_Right")
					LastDirection = Vector2.RIGHT
	
	elif Direction == Vector2.ZERO:
		CurrentSpeed = 0
		
		if CurrentState != eStates.Attacking:
			match LastDirection:
					Vector2.RIGHT:
						AnimPlayer.play("Idle_Right")
					Vector2.LEFT:
						AnimPlayer.play("Idle_Left")
					Vector2.UP:
						AnimPlayer.play("Idle_Up")
					Vector2.DOWN:
						AnimPlayer.play("Idle_Down")
	
	if Input.is_action_just_pressed("Attack") && CurrentState == eStates.CanAttack:
		Attack()

func AnimationManager():
	pass
	
func Attack():
	if CooldownTimer.time_left >= 0.01:
		return
	
	CurrentState = eStates.Attacking
	
	BodyAudio.PlayVoice()
	await get_tree().create_timer(0.15).timeout
	
	WeaponAudio.PlaySwing()
	
	var library : String
	var dir : String
	
	match AttackIndex:
		1:
			library = "Swipe"
		2:
			library = "Reverse Swipe"
		3:
			library = "Swipe"
	
	match LastDirection:
		Vector2.LEFT:
			dir = "Left"
		Vector2.RIGHT:
			dir = "Right"
		Vector2.UP:
			dir = "Up"
		Vector2.DOWN:
			dir = "Down"
	
	animID = (library + "/" + dir)
	AnimPlayer.play(animID)
	
	await AnimPlayer.animation_finished
	CurrentState = eStates.CanAttack
	
	UI.UpdateAttackIcons(MaxAttackNumber - AttackIndex)
	
	if AttackTimer.time_left >= 0.01:
			AttackTimer.stop()
	
	if AttackIndex == MaxAttackNumber:
		ReduceStamina(1)
		CooldownTimer.start(AttackCooldown)
	else:
		AttackIndex += 1
		AttackTimer.start(AttackTime)

func ResetAttackIndex():
	AttackIndex = 1
	UI.UpdateAttackIcons(MaxAttackNumber)
	
func ReduceStamina(Amount : int):
	CurrentStamina -= Amount
	#print(CurrentStamina)
	UI.UpdateStaminaIcons(CurrentStamina)
	
	await get_tree().create_timer(StaminaRefill).timeout
	CurrentStamina += 1
	UI.RefillStaminaIcons(CurrentStamina)

func TakeDamage(Amount : int):
	print("PLAYER HIT")
	CurrentHealth -= Amount
	
#Regains a variable amount of health
func RegainHealth(Amount : int):
	if IsHealing == false:
		print("Healing: " + str(Amount) + " points!")
		IsHealing = true
		var HealthTween = get_tree().create_tween()
		HealthTween.tween_property(self, "CurrentHealth", (CurrentHealth + Amount), 0.5)
		await HealthTween.finished
		IsHealing = false
