extends Panel
class_name XPTracker

@export var ResolvePoints : Label
@export var Amount : Label
@export var Bar : ProgressBar
@export var AddAmount : Label

@onready var WaitTimer : SceneTreeTimer = get_tree().create_timer(5)
var AmntToAdd : int

func _ready():
	AddAmount.text = "0"
	
func _process(delta):
	pass

func DisplayXP(amount : int):
	if WaitTimer.time_left > 0:
		WaitTimer.stop()
		WaitTimer.start(5)
	AmntToAdd += amount
	AddAmount.text = "+" + str(AmntToAdd)
	await WaitTimer.timeout
	var WaitTime : float = 0.20
	var Pitch : float
	for i in amount:
		AmntToAdd -= 1
		AddAmount.text = "+" + str(AmntToAdd)
		#CurrentXP += 1
		WaitTime -= 0.01
		Pitch += 0.1
		$Audio/AudioStreamPlayer.pitch_scale = Pitch
		$Audio/AudioStreamPlayer.play()
		await get_tree().create_timer(WaitTime).timeout
