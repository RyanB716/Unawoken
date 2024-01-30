#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

signal PlayerDied(pos : Vector2)
signal PlayerHit(dur : float)

enum eStates {Moving, Guarding, Attacking, AttackCooldown, GuardCooldown, InMenu, Dead}
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
@export var MaxAttackNumber : int = 4

var CurrentSpeed : float = 0
var Direction
var AttackIndex : int = 1
var LastDirection : Vector2
var animID : String

var IsHealing : bool = false

var AnimState : AnimationNodeStateMachinePlayback

@export_category("Components")
@export var InventoryRef : Inventory
@export var UI : PlayerUI
@export var HitBox : Hit_Box
@export var HurtBox : Hurt_Box

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var AnimTree : AnimationTree
@export var AttackTimer : Timer
@export var CooldownTimer : Timer
@export var BodyAudio : BodyAudioPlayer
@export var WeaponAudio : WeaponAudioPlayer

func _ready():
	Direction = Vector2.DOWN
	LastDirection = Vector2.DOWN
	
	UI.UpdateAttackIcons(MaxAttackNumber)
	UI.SetStaminaIcons(MaxStaminaActions)
	
	CurrentHealth = MaxHealth
	CurrentStamina = MaxStaminaActions
	
	HitBox.HitRecieved.connect(TakeDamage)
	
	AnimState = AnimTree.get("parameters/playback")
	
func _process(_delta):
	if CurrentState == eStates.Dead:
		return
		
	StateMachine()
	
func _physics_process(_delta):
	velocity = (Direction * CurrentSpeed)
	move_and_slide()
	
func StateMachine():
	
	match CurrentState:
		eStates.Moving:
			Move()

		eStates.Attacking:
			pass
			
		eStates.Guarding:
			pass
	
	"""
	if CurrentState == eStates.Dead:
		CurrentSpeed = 0
		return
	
	if CurrentSpeed > 0 && CurrentSpeed != eStates.Attacking:
		BodyAudio.PlayStep()
		AnimState.travel("Run")
	elif CurrentSpeed <= 0 && CurrentState != eStates.Attacking:
		AnimState.travel("Idle")
	
	match CurrentState:
		eStates.InMenu:
			CurrentSpeed = 0
			AnimState.travel("Idle")
	"""
	
func InputManager():
	
	if Input.is_action_just_pressed("Attack") && CurrentState != eStates.Attacking:
		Attack()

func Move():
	Direction = Vector2.ZERO
	Direction.x = Input.get_action_strength("Run_Right") - Input.get_action_strength("Run_Left")
	Direction.y = Input.get_action_strength("Run_Down") - Input.get_action_strength("Run_Up")
	Direction = Direction.normalized()
	
	if Direction != Vector2.ZERO:
		AnimTree.set("parameters/Idle/blend_position", Direction)
		AnimTree.set("parameters/Run/blend_position", Direction)
		AnimTree.set("parameters/Swipe Attack/blend_position", Direction)
		
		CurrentSpeed = WalkSpeed
		
		AnimState.travel("Run")
		BodyAudio.PlayStep()
	else:
		CurrentSpeed = 0
		AnimState.travel("Idle")
		
func Attack():
	if CooldownTimer.time_left >= 0.01:
		return
	
	BodyAudio.PlayVoice()
	
	await get_tree().create_timer(0.15).timeout
	
	CurrentState = eStates.Attacking
	
	WeaponAudio.PlaySwing()
	AnimState.travel("Swipe Attack")
	
	await AnimTree.animation_finished
	
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
	PlayerHit.emit(0.25)
	CurrentHealth -= Amount
	if CurrentHealth <= 0:
		Die()

func Die():
	PlayerDied.emit(self.position)
	CurrentState = eStates.Dead

#Regains a variable amount of health
func RegainHealth(AmountInPercent : float):
	if IsHealing == false:
		var Amount : int = int(MaxHealth * (AmountInPercent * 0.01))
		print("Healing: " + str(Amount) + " points!")
		IsHealing = true
		var HealthTween = get_tree().create_tween()
		HealthTween.tween_property(self, "CurrentHealth", (CurrentHealth + Amount), 0.5)
		await HealthTween.finished
		IsHealing = false
