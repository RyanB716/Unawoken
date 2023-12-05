extends Area2D
class_name Coin

func _ready():
	TimeDestroy()
	
func TimeDestroy():
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var newTime = RNG.randf_range(2.5, 5.0)
	await get_tree().create_timer(newTime).timeout
	if self.is_inside_tree():
		var player = get_tree().get_first_node_in_group("Player")
		if player is Player:
			player.InventoryRef.CoinCount += 1
		self.queue_free()

func OnPickup(body : Node2D):
	if body is Player:
		body.InventoryRef.CoinCount += 1
		self.queue_free()
