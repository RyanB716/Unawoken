#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

signal PlayerDied(pos : Vector2)
signal PlayerHit(dur : float)

enum eStates {NoAction, Guarding, Attacking, AttackCooldown, GuardCooldown, InMenu, Dead}
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
	
	CurrentState = eStates.NoAction
	
func _process(_delta):
	if CurrentState == eStates.Dead:
		return
	
	Move()
	InputManager()
	StateMachine()
	
func _physics_process(_delta):
	velocity = (Direction * CurrentSpeed)
	move_and_slide()
	
func StateMachine():
	match CurrentState:
			
		eStates.Attacking:
			Attack()
		
		eStates.Guarding:
			Guard()
	
func InputManager():
	if CurrentState == eStates.Dead or CurrentState == eStates.InMenu:
		return
	
	Direction = Vector2.ZERO
	Direction.x = Input.get_action_strength("Run_Right") - Input.get_action_strength("Run_Left")
	Direction.y = Input.get_action_strength("Run_Down") - Input.get_action_strength("Run_Up")
	Direction = Direction.normalized()
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
		
	if Input.is_action_pressed("Guard"):
		Guard()
	
	if Input.is_action_just_pressed("UseItem") && InventoryRef.CurrentItem != null:
		InventoryRef.UseCurrentItem()

func Move():
	if Direction != Vector2.ZERO:
		if CurrentState == eStates.NoAction:
			AnimTree.set("parameters/Idle/blend_position", Direction)
			AnimTree.set("parameters/Run/blend_position", Direction)
			AnimTree.set("parameters/Swipe Attack/blend_position", Direction)
			AnimTree.set("parameters/Reverse Swipe/blend_position", Direction)
		
		CurrentSpeed = WalkSpeed
		
		BodyAudio.PlayStep()
		if CurrentState == eStates.NoAction:
			AnimState.travel("Run")
	else:
		CurrentSpeed = 0
		if CurrentState == eStates.NoAction:
			AnimState.travel("Idle")
		
func Attack():
	if CurrentState == eStates.Attacking or AttackIndex > MaxAttackNumber:
		return
		
	CurrentState = eStates.Attacking
	
	BodyAudio.PlayVoice()
	await get_tree().create_timer(0.10).timeout
	WeaponAudio.PlaySwing()
	
	print(AttackIndex)
	
	match AttackIndex:
		1:
			AnimState.travel("Swipe Attack")
			await AnimTree.animation_finished
		
		2:
			AnimState.travel("Reverse Swipe")
			await AnimTree.animation_finished
		
		3:
			AnimState.travel("Swipe Attack")
			await AnimTree.animation_finished
		
		4:
			AnimState.travel("Reverse Swipe")
			await AnimTree.animation_finished
	
	if AttackIndex == MaxAttackNumber:
		print("Running cooldown\n")
		ReduceStamina(1)
		AttackTimer.start(AttackCooldown)
	else:
		AttackTimer.start(AttackTime)
	
	AttackIndex += 1
	UI.UpdateAttackIcons(MaxAttackNumber - (AttackIndex - 1))
	CurrentState = eStates.NoAction
	
func Guard():
	print("Guard ON")

func ResetAttackIndex():
	AttackIndex = 1
	UI.UpdateAttackIcons(MaxAttackNumber)
	
func ReduceStamina(Amount : int):
	print(AttackIndex)
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
