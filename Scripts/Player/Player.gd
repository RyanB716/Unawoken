#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

enum eStates {Idle, Walk, Attack, Roll, InMenu, Dead}
var CurrentState : eStates

signal UpdateIcons(Amount : int)

@export_category("Player Stats")
@export var WalkSpeed : float
@export var MaxHealth : int
var CurrentHealth : int

@export_category("Attack Stats")
@export var AttackTime : float
@export var AttackCooldown : float
@export var MaxAttackNumber : int = 3

var CurrentSpeed : float = 0
var Direction
var AttackIndex : int = 1
var LastDirection : Vector2
var animID : String

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var AttackTimer : Timer
@export var CooldownTimer : Timer
@export var BodyAudio : BodyAudioPlayer
@export var WeaponAudio : WeaponAudioPlayer
@export var InventoryRef : Inventory

func _ready():
	CurrentState = eStates.Idle
	LastDirection = Vector2.DOWN
	
	UpdateIcons.emit(MaxAttackNumber)
	
func _process(_delta):
	if CurrentState == eStates.Dead:
		return
	
	InputManager()
	StateMachine()
	AnimationManager()
	
func _physics_process(_delta):
	move_and_slide()
	
func StateMachine():
	match CurrentState:
		eStates.Idle:
			CurrentSpeed = 0
			
		eStates.Walk:
			CurrentSpeed = WalkSpeed
			BodyAudio.PlayStep()
			
		eStates.Roll:
			pass
			
		eStates.Dead:
			pass
	
func InputManager():
	if CurrentState == eStates.InMenu:
		return
	
	if CurrentState == eStates.Attack:
		return
	
	Direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down").normalized()
	velocity = (Direction * CurrentSpeed)
	
	if Direction != Vector2.ZERO:
		CurrentState = eStates.Walk
		
		match Direction:
			Vector2.UP:
				LastDirection = Vector2.UP
			Vector2.DOWN:
				LastDirection = Vector2.DOWN
			Vector2.LEFT:
				LastDirection = Vector2.LEFT
			Vector2.RIGHT:
				LastDirection = Vector2.RIGHT
	
	elif Direction == Vector2.ZERO:
		CurrentState = eStates.Idle
	
	if Input.is_action_just_pressed("Attack") && CurrentState != eStates.Attack:
		Attack()

func AnimationManager():
	match CurrentState:
		eStates.Idle:
			match LastDirection:
				Vector2.RIGHT:
					AnimPlayer.play("Idle_Right")
				Vector2.LEFT:
					AnimPlayer.play("Idle_Left")
				Vector2.UP:
					AnimPlayer.play("Idle_Up")
				Vector2.DOWN:
					AnimPlayer.play("Idle_Down")
					
		eStates.Walk:
			match LastDirection:
				Vector2.RIGHT:
					AnimPlayer.play("Run_Right")
				Vector2.LEFT:
					AnimPlayer.play("Run_Left")
				Vector2.UP:
					AnimPlayer.play("Run_Up")
				Vector2.DOWN:
					AnimPlayer.play("Run_Down")

func Attack():
	if CooldownTimer.time_left >= 0.01:
		return
	
	CurrentState = eStates.Attack
	
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
	CurrentState = eStates.Idle
	
	UpdateIcons.emit(MaxAttackNumber - AttackIndex)
	
	if AttackTimer.time_left >= 0.01:
			AttackTimer.stop()
	
	if AttackIndex == MaxAttackNumber:
		#print("Max reached, cooling down")
		CooldownTimer.start(AttackCooldown)
	else:
		AttackIndex += 1
		AttackTimer.start(AttackTime)

func ResetAttackIndex():
	AttackIndex = 1
	UpdateIcons.emit(MaxAttackNumber)
