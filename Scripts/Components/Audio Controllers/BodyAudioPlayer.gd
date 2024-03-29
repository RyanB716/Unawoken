extends AudioStreamPlayer
class_name BodyAudioPlayer

@export var Parent : CharacterBody2D

@export_category("Track Arrays")
@export var VoiceSFX : Array[AudioStream]
@export var HurtSFX : Array[AudioStream]

@export_category("Single Tracks")
@export var FootSFX : AudioStream

var RNG = RandomNumberGenerator.new()

var StepTimer : Timer

func _ready():
	StepTimer = Timer.new()
	add_child(StepTimer)
		
func PlayVoice():
	pitch_scale = 1
	RNG.randomize()
	var index = RNG.randi_range(0, VoiceSFX.size() - 1)
	stream = VoiceSFX[index]
	play()
		
func PlayHitSFX():
	pitch_scale = 1
	RNG.randomize()
	var index = RNG.randi_range(0, HurtSFX.size() - 1)
	stream = HurtSFX[index]
	play()

#Play the sfx at a random pitch
func PlayStep():
	if StepTimer.time_left > 0.01:
		return
		
	stream = FootSFX
	pitch_scale = RNG.randf_range(0.5, 1.5)
	self.play()
	StepTimer.start(0.50)
	if self.playing == false:
		print('Error')
