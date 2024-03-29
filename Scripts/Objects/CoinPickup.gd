extends RigidBody2D
class_name Coin

@export var Velocity : float

var Direction
var player
var CanMove

func _enter_tree():
	SendAway()
	
func _ready():
	self.CanMove = false
	TimeDestroy()
	player = get_tree().get_first_node_in_group('Player')
	await get_tree().create_timer(0.35).timeout
	self.CanMove = true

func _physics_process(_delta):
	if self.CanMove == false:
		return

	Direction = player.global_position - self.global_position
	
	if Direction.length() < 100:
		self.linear_velocity = Direction.normalized() * 100

func SendAway():
	var RNG =  RandomNumberGenerator.new()
	RNG.randomize()
	var VelX = RNG.randf_range(-Velocity, Velocity)
	var VelY = RNG.randf_range(-Velocity, Velocity)
	if absi(VelX) <= 10 or absi(VelY) <= 10:
		SendAway()
	self.linear_velocity.x = VelX
	self.linear_velocity.y = VelY

#If coin is not picked up by the end of its random lifespan; delete and add 1 to coin count
func TimeDestroy():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	await get_tree().create_timer(30.0).timeout
	if self.is_inside_tree():
		self.queue_free()

#Add to coin count on collision
func OnPickup(body : Node2D):
	if body is Player:
		body.InventoryRef.AddCoin()
		self.queue_free()
	
func _on_body_entered(body):
	if body != Player:
		var RNG = RandomNumberGenerator.new()
		RNG.randomize()
		$AudioStreamPlayer2D.pitch_scale = RNG.randf_range(0.7, 1.15)
		$AudioStreamPlayer2D.play()
