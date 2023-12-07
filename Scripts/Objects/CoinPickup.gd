extends RigidBody2D
class_name Coin

@export var Velocity : float

func _enter_tree():
	SendAway()
	
func _ready():
	TimeDestroy()

func SendAway():
	var RNG =  RandomNumberGenerator.new()
	RNG.randomize()
	self.linear_velocity.x = RNG.randf_range(-Velocity, Velocity)
	self.linear_velocity.y = RNG.randf_range(-Velocity, Velocity)

#If coin is not picked up by the end of its random lifespan; delete and add 1 to coin count
func TimeDestroy():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	#var newTime = RNG.randf_range(5.0, 10.0)
	await get_tree().create_timer(20.0).timeout
	if self.is_inside_tree():
		#var player = get_tree().get_first_node_in_group("Player")
		#if player is Player:
			#player.InventoryRef.CoinCount += 1
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
