#This class is responsible for handling input and output for the player's character
#Utilizing a 'KISS'-forward state machine, inputs will be handled
#This class contains necessary data for child objects to pull from ie Health, XP, Stamina, Damage, etc
#Various signals are created to avoid altering or calling data directly in child objects

extends CharacterBody2D
class_name Player

signal PlayerDied(pos : Vector2)
signal PlayerHit(dur : float)

enum eStates {NoAction, Blocking, Attacking, Blink, AttackCooldown, InMenu, Break, Dead}
var CurrentState : eStates

@export_category("Player Stats")
@export var WalkSpeed : float
@export var MaxHealth : int
var CurrentHealth : int
@export var MaxStaminaActions : int
var CurrentStamina : int
@export var StaminaRefill : float
@export var BreakTime : float
@onready var ResolvePoints : int = 0
@onready var CurrentXP : int = 0
@export var NeededXP : int
@export var XPScalar : float
@export var BlinkCooldown : float
@export var Blinkdistance : int 

@export_category("Attack Stats")
@export var MaxDamage : int
var CurrentDamage : int
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
@export var InventoryRef : InventoryManager
@export var UI : PlayerUI
@export var HitBox : Hit_Box
@export var HurtBox : Hurt_Box
@export var Shield : ShieldController
@onready var GM : GameManager = get_parent()

@export_category("Internal References")
@export var AnimPlayer : AnimationPlayer
@export var AnimTree : AnimationTree
@export var AttackTimer : Timer
@export var BodyAudio : BodyAudioPlayer
@export var WeaponAudio : WeaponAudioPlayer
@export var BlinkTimer : Timer

func _ready():
	Direction = Vector2.DOWN
	LastDirection = Vector2.DOWN
	
	UI.UpdateAttackIcons(MaxAttackNumber)
	UI.SetStaminaIcons(MaxStaminaActions)
	
	if Shield.Sprite.visible == true:
		Shield.Sprite.visible = false
	
	Shield.Disable()
	Shield.AttackBlocked.connect(BlockAttack)
	
	CurrentHealth = MaxHealth
	CurrentStamina = MaxStaminaActions
	
	HitBox.HitRecieved.connect(TakeDamage)
	
	AnimState = AnimTree.get("parameters/playback")
	
	CurrentState = eStates.NoAction
	
	CurrentDamage = MaxDamage
	
func _process(_delta):
	if CurrentState == eStates.Dead:
		return
	
	#print("Current State: " + str(CurrentState))
	
	#if CurrentState != eStates.Blocking && CurrentState != eStates.Break && CurrentState != eStates.Blink:
	if CurrentState != eStates.Break && CurrentState != eStates.Blink:
		Move()
		InputManager()
	
	StateMachine()

func _physics_process(_delta):
	if !CurrentState == eStates.Blink:
		velocity = (Direction * CurrentSpeed)
	move_and_slide()
	
func StateMachine():
	match CurrentState:
		
		eStates.InMenu:
			CurrentSpeed = 0
			AnimTree.set("parameters/Idle/blend_position", Vector2.UP)
			AnimState.travel("Idle")
			
		eStates.Attacking:
			Attack()
		
		eStates.Blocking:
			CurrentSpeed = 0
	
func InputManager():
	if CurrentState == eStates.Dead or CurrentState == eStates.Break or CurrentState == eStates.InMenu:
		return
	
	Direction = Vector2.ZERO
	Direction.x = Input.get_action_strength("Run_Right") - Input.get_action_strength("Run_Left")
	Direction.y = Input.get_action_strength("Run_Down") - Input.get_action_strength("Run_Up")
	Direction = Direction.normalized()
	
	if Input.is_action_just_pressed("Attack"):
		Attack()
		
	if Input.is_action_just_pressed("Block"):
		GuardON()
		
	if Input.is_action_just_released("Block"):
		GuardOFF()
	
	if Input.is_action_just_released("Blink"):
		Blink()
	
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
			
func AnxietyEffects(percent : float):
	if percent >= 0.50:
		UI.AttackIndicatorBox.visible = false
	if percent >= 0.75:
		UI.StaminaIndicatorBox.visible = false
	if percent >= 0.85:
		CurrentDamage = MaxDamage * 0.85
	if percent >= 1.00:
		CurrentDamage = MaxDamage * 0.70
		
func Attack():
	if CurrentState == eStates.Attacking or AttackIndex > MaxAttackNumber:
		return
		
	CurrentState = eStates.Attacking
	
	BodyAudio.PlayVoice()
	await get_tree().create_timer(0.10).timeout
	WeaponAudio.PlaySwing()
	
	match AttackIndex:
		1:
			AnimState.travel("Swipe Attack")
		
		2:
			AnimState.travel("Reverse Swipe")
		
		3:
			AnimState.travel("Swipe Attack")
		
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
	
func GetXP(amount : int):
	print("Recieving " + str(amount) + " XP!")
	if CurrentXP + amount < NeededXP:
		CurrentXP += amount
	else:
		var FinishVaue : int = NeededXP - CurrentXP
		print("Filling the last " + str(FinishVaue) + " point(s)")
		#var Remainder : int = 

func GuardON():
	CurrentState = eStates.Blocking
	AnimTree.set("parameters/Idle/blend_position", Vector2(0, 1))
	AnimState.travel("Idle")
	HitBox.Disable()
	Shield.Enable()
	CurrentSpeed = 0
	
func GuardOFF():
	Shield.Disable()
	HitBox.Enable()
	CurrentState = eStates.NoAction

func Blink():
	
	if Direction != Vector2.ZERO && CurrentState == eStates.NoAction:
	
		AnimState.travel("Idle")
		print("Blink")
		ReduceStamina(1)
		set_collision_mask_value(3, false)
		
		var PCollisionOffset : Vector2 = Vector2(0,2)
		var CollisionOrigin : Vector2 = global_position + PCollisionOffset
		var NormalizedBlinkdistance = Direction * Blinkdistance
	
	
		#Blink normalized Collision box distance + distance of Collieded Ray
		#environtment collision parameters 2px down 9.5px wide 4px tall
	
		#collisions adjustment (enum for readability?)
		#Vector2(x,y) x = -left +right y = -up +down
		#correct Raycast length(10px for each coord for now) based on direction but adjust for player environment collision box

		CurrentState = eStates.Blink
		#try to teleport here
		var Teleport = CollisionOrigin + NormalizedBlinkdistance
	
		#check if there would be a collision with the player environment collision box
		var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create( CollisionOrigin ,  CollisionOrigin + NormalizedBlinkdistance , 4)
		var Collision  =  space_state.intersect_ray(query)
	
		#if collision with collison box, move player origin to collision with the offset being the collision box
		if !Collision.is_empty():
			#4 ray query
			# Move this to method #TODO
			var InversionPixel = Collision.position  + (Direction * -0.08)
			var up = PhysicsRayQueryParameters2D.create( InversionPixel ,  InversionPixel + Vector2(0,-2), 4)
			var down = PhysicsRayQueryParameters2D.create( InversionPixel ,  InversionPixel + Vector2(0,2), 4)
			var left = PhysicsRayQueryParameters2D.create( InversionPixel ,  InversionPixel + Vector2(-4.75,0), 4)
			var right = PhysicsRayQueryParameters2D.create( InversionPixel ,  InversionPixel + Vector2(4.75,0), 4)
			var CollisionBoxOffsetter : Vector2
		
		
			var CollisionUp = space_state.intersect_ray(up)
			if CollisionUp.is_empty():
				var Collisiondown = space_state.intersect_ray(down)
				if !Collisiondown.is_empty():
					
					CollisionBoxOffsetter.y =  (Collisiondown.position.y ) - 2 
			else:
				CollisionBoxOffsetter.y =  (CollisionUp.position.y ) + 2
			var Collisionleft = space_state.intersect_ray(left)
			if Collisionleft.is_empty():
				var Collisionright = space_state.intersect_ray(right)
				if !Collisionright.is_empty():
					CollisionBoxOffsetter.x =  (Collisionright.position.x ) - 4.75
			else:
				CollisionBoxOffsetter.x = (Collisionleft.position.x ) + 4.75
		
			#redo to change collision position - the x and y of collision box based on "Direction"
			if CollisionBoxOffsetter.x:
				global_position.x =   CollisionBoxOffsetter.x
			if CollisionBoxOffsetter.y:
				global_position.y =   CollisionBoxOffsetter.y - PCollisionOffset.y
		#else just teleport player origin to point
		else:
			global_position = Teleport - PCollisionOffset
		set_collision_mask_value(3, true)
		velocity = Vector2.ZERO
		CurrentSpeed = 0
		Direction = Vector2(0,0)
		await get_tree().create_timer(BlinkCooldown).timeout
		CurrentState = eStates.NoAction
		#BlinkTimer.start(BlinkCooldown)
	else:
		pass

func ResetAttackIndex():
	AttackIndex = 1
	UI.UpdateAttackIcons(MaxAttackNumber)
	
func ReduceStamina(Amount : int):
	CurrentStamina -= Amount
	UI.UpdateStaminaIcons(CurrentStamina)
	#######
	await get_tree().create_timer(StaminaRefill).timeout
	CurrentStamina += 1
	UI.RefillStaminaIcons(CurrentStamina)
	
func BlockAttack():
	ReduceStamina(1)
	if CurrentStamina <= 0:
		Break()

func TakeDamage(Amount : int):
	PlayerHit.emit(0.25)
	CurrentHealth -= Amount
	BodyAudio.PlayHitSFX()
	if CurrentHealth <= 0:
		Die()
		
func Break():
	print("BREAK!")
	CurrentState = eStates.Break
	Shield.call_deferred("Disable")
	HitBox.call_deferred("Enable")
	await get_tree().create_timer(BreakTime).timeout
	CurrentState= eStates.NoAction

func Die():
	PlayerDied.emit(self.position)
	CurrentState = eStates.Dead

#Regains a variable amount of health
func RegainHealth(AmountInPercent : float):
	var Amount : int = int(MaxHealth * (AmountInPercent * 0.01))
	print("Healing: " + str(Amount) + " points!")
	IsHealing = true
	var HealthTween = get_tree().create_tween()
	HealthTween.tween_property(self, "CurrentHealth", (CurrentHealth + Amount), 0.5)
	await HealthTween.finished
	IsHealing = false
