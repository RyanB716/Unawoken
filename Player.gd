extends CharacterBody2D

@onready var AnimTree = $AnimationTree
@onready var AttackTimer = $AttackStateTimer
@onready var B_Audio = $BodyAudio
@onready var W_Audio = $WeaponAudio

enum DirectionStates {Up, Down, Left, Right}
enum MoveStates {Idle, Run}
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

@export_category("Movement Stats")
@export var TopSpeed = 0
@export var Acceleration = 0.0
@export var Deceleration = 0.0

@export_category("Attack Stats")
@export var AttackTime : float
@export var CooldownTime : float
@export var InputBufferAmnt : float

var CurrentSpeed = 0
var HorizontalInput = 0
var VerticalInput = 0
var Direction = Vector2.ZERO

var CurrentHealth : int

var AnimState = null

func _ready():
	CurrentMoveState = MoveStates.Idle
	CurrentDirection = DirectionStates.Down
	CurrentAttackState = AttackActionStates.NotAttacking
	
	AnimState = AnimTree.get("parameters/playback")
	
	CurrentHealth = MaxHealth

func _physics_process(delta):
	
	IsMoving = Input.is_action_pressed("Run_Up") || Input.is_action_pressed("Run_Down") || Input.is_action_pressed("Run_Left") || Input.is_action_pressed("Run_Right")
	
	if IsMoving:
		HorizontalInput = int(Input.is_action_pressed("Run_Right")) - int(Input.is_action_pressed("Run_Left"))
		VerticalInput = int(Input.is_action_pressed("Run_Down")) - int(Input.is_action_pressed("Run_Up"))
		
		CurrentSpeed = lerpf(CurrentSpeed, TopSpeed, Acceleration * delta)
		CurrentMoveState = MoveStates.Run
		
	else:
		CurrentSpeed = lerpf(CurrentSpeed, 0, Deceleration * delta)
		CurrentMoveState = MoveStates.Idle
	
	Direction = Vector2(HorizontalInput, VerticalInput).normalized()
	velocity = (Direction * CurrentSpeed)
	
	AnimTree.set("parameters/Idle/blend_position", Direction)
	AnimTree.set("parameters/Run/blend_position", Direction)
	AnimTree.set("parameters/Attack/blend_position", Direction)
	AnimTree.set("parameters/Attack 2/blend_position", Direction)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("Attack"):
		if CurrentAttackState == AttackActionStates.NotAttacking && CurrentAttackState != AttackActionStates.Cooldown:
			Attack()
			
	AnimationStateController()
			
	pass
	
func AnimationStateController():
	if CurrentAttackState == AttackActionStates.NotAttacking or CurrentAttackState == AttackActionStates.Cooldown:
		if CurrentMoveState == MoveStates.Run:
			AnimState.travel("Run")
		elif CurrentMoveState == MoveStates.Idle:
			AnimState.travel("Idle")

func Attack():
	
	B_Audio.PlaySFX()
	CurrentAttackState = AttackActionStates.IsAttacking
	
	#Initial Input Buffer + State Switch
	await get_tree().create_timer(0.2).timeout
	
	#Movement Decrease
	var InitialSpeed = TopSpeed
	TopSpeed = TopSpeed * 0.25
	
	#If timer is not running; execute attack 1
	if AttackTimer.is_stopped():
		if CurrentAttackIndex != AttackSlots.Attack1:
			CurrentAttackIndex = AttackSlots.Attack1
		AnimState.travel("Attack")
		W_Audio.PlaySFX()
		print("Attack 1")
	
	#else; match attack index and increase until cooldown
	else:
		match CurrentAttackIndex:
			0:
				print("Attack 2")
				AnimState.travel("Attack 2")
				W_Audio.PlaySFX()
				CurrentAttackIndex = AttackSlots.Attack2
				AttackTimer.stop()
			
			1:
				print("Attack 3")
				AnimState.travel("Attack")
				W_Audio.PlaySFX()
				CurrentAttackIndex = AttackSlots.Attack3
				AttackTimer.stop()

	await AnimTree.animation_finished
	CurrentAttackState = AttackActionStates.NotAttacking
	TopSpeed = InitialSpeed
	
	if CurrentAttackIndex == AttackSlots.Attack3:
		CurrentAttackState = AttackActionStates.Cooldown
		AttackTimer.stop()
		AttackCooldown()
	else:
		AttackTimer.stop()
		AttackTimer.start(AttackTime)

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
