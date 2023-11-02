extends AudioStreamPlayer
class_name AudioPlayer

@export var TrackArray = []

func PlaySFX():
	var RNG = RandomNumberGenerator.new()
	var index = RNG.randi_range(0, TrackArray.size() - 1)
	self.stream = TrackArray[index]
	self.play()
