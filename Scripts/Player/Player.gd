#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

enum eStates {Idle, Walk, Attack, Roll, Dead}
var CurrentState : eStates

@export_category("Player Stats")
@export var WalkSpeed : float

var CurrentSpeed : float = 0
var Direction
var MaxAttackNumber : int = 3
var AttackIndex : int = 0

func _ready():
	CurrentState = eStates.Idle
	
func _process(delta):
	if CurrentState == eStates.Dead:
		return
	
	StateMachine()
	
func _physics_process(delta):
	InputManager()
	move_and_slide()
	
func StateMachine():
	match CurrentState:
		eStates.Idle:
			CurrentSpeed = 0
			
		eStates.Walk:
			CurrentSpeed = WalkSpeed
		
		eStates.Attack:
			Attack()
	
func InputManager():
	Direction = Input.get_vector("Run_Left", "Run_Right", "Run_Up", "Run_Down").normalized()
	velocity = (Direction * CurrentSpeed)
	
	if Direction != Vector2.ZERO:
		CurrentState = eStates.Walk
	else:
		CurrentState = eStates.Idle
		
	if Input.is_action_just_pressed("Attack"):
		CurrentState = eStates.Attack

func Attack():
	# Check if attack timer has no time left
	await get_tree().create_timer(0.15).timeout
	
	# BODYAUDIO PLAY VOICE
	# WEAPONAUDIO PLAY SWING SFX
	
	match AttackIndex:
		0:
			print("Attacking with 1st animation!")
		1:
			print("Attacking with 2nd animation!")
		2:
			print("Attacking with 3rd animation!")
	
	AttackIndex += 1
	
	if AttackIndex == MaxAttackNumber:
		print("Max reached, cooling down")
		# Start Attack Cooldown
	else:
		pass
		# Start Attack Timer
	
	CurrentState = eStates.Idle
