extends AudioStreamPlayer
class_name InventoryAudio

@export var CoinSFX : AudioStream

func PlaySFX(sfx : AudioStream):
	self.stream = sfx
	play()
