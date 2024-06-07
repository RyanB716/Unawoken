extends StaticBody2D
class_name DestructableObject

@export var HitBox : Hit_Box

@export_category("Data Variables")
@export var NeededHits : int

@export var ItemDrops : Array[ItemDrop]

@export var Min_CoinAmount : int
@export var Max_CoinAmount : int
var CoinAmount : int

@export_category("Aesthetic Variables")
@export var HitSFX : Array[AudioStream]
@export var BreakSFX : Array[AudioStream]

@onready var PickupScene = preload("res://Content/Objects/Items/Pickups/ItemPickup.tscn")
@onready var CoinScene = preload("res://Content/Objects/Items/Pickups/Coin.tscn")
@onready var Area = self.get_child(0)
@onready var RNG = RandomNumberGenerator.new()


signal CallScreenShake(Strength : float, Duration : float)

func _ready():
	
	RNG.randomize()
	CoinAmount = RNG.randi_range(Min_CoinAmount, Max_CoinAmount)
	
	if HitBox == null:
		print("ERROR: DestructableObject: " + str(self.name) + " has NO HitBox!")
	else:
		HitBox.HitRecieved.connect(TakeHit)

func TakeHit(amount : int):
	if NeededHits - amount > 0:
		Hit(amount)
	elif NeededHits -1 == 0:
		Destroy()
		
func Hit(amount : int):
	NeededHits -= amount
	CallScreenShake.emit(0.75, 0.15)
	PlayHitSFX()

func Destroy():
	CallScreenShake.emit(1.5, 0.25)
	PlayBreakSFX()
	Area.queue_free()
	HitBox.queue_free()
	$CollisionShape2D.queue_free()
	$Sprite2D.visible = false
	GiveItems()
	await get_tree().create_timer(1).timeout
	self.queue_free()

#plays a random sfx
func PlayHitSFX():
	RNG.randomize()
	var index = RNG.randi_range(1, HitSFX.size())
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = HitSFX[index - 1]
	NewPlayer.play()
	await NewPlayer.finished
	NewPlayer.queue_free()
	
func PlayBreakSFX():
	RNG.randomize()
	var index = RNG.randi_range(1, BreakSFX.size())
	var NewPlayer = AudioStreamPlayer.new()
	add_child(NewPlayer)
	NewPlayer.stream = BreakSFX[index - 1]
	NewPlayer.play()
	await NewPlayer.finished

func GiveItems():
		
	if ItemDrops.size() >= 1:
		for i in ItemDrops.size():
			var newItem : ItemPickup = PickupScene.instantiate()			
			newItem.res = ItemDrops[i].Item
			newItem.Amount = ItemDrops[i].AmountToGive
			get_tree().current_scene.call_deferred("add_child", newItem)
			newItem.position = self.position
	
	for i in CoinAmount:
		var newCoin = CoinScene.instantiate()
		get_tree().current_scene.call_deferred("add_child", newCoin)
		newCoin.position = self.position
