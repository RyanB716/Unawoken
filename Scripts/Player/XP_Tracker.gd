extends Panel
class_name XPTracker

@export var ResolvePoints : Label
@export var Amount : Label
@export var Bar : ProgressBar
@export var AddAmount : Label

@export var AddTimer : Timer
@export var SFX : AudioStreamPlayer

@onready var CurrentAmount : int
@onready var AmntToAdd : int

func _ready():
	AmntToAdd = 0
	CurrentAmount = 0
	
func _process(delta):
	AddAmount.text = "+" + str(AmntToAdd)
	Amount.text = str(CurrentAmount)
	Bar.value = CurrentAmount
	
func ResetProgressBar(Amount):
	Bar.max_value = Amount

func DisplayXP():
	var WaitTime : float = 0.20
	var Pitch : float = 0.1
	for i in AmntToAdd:
		AmntToAdd -= 1
		CurrentAmount += 1
		WaitTime -= 0.01
		Pitch += 0.1
		SFX.pitch_scale = Pitch
		SFX.play()
		await get_tree().create_timer(WaitTime).timeout
