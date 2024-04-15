extends Panel
class_name XPTracker

@export var ResolvePoints : Label
@export var Amount : Label
@export var Bar : ProgressBar
@export var AddAmount : Label

@export var AddTimer : Timer
@export var SFX : AudioStreamPlayer

@onready var CurrentAmount : int
@onready var AmountAdding : int

@onready var Transferring : bool = false

func _ready():
	AmountAdding = 0
	CurrentAmount = 0

func DisplayXP():
	if Transferring:
		return
		
	var WaitTime : float = 0.20
	var Pitch : float = 0.1
	Transferring = true
	for i in AmountAdding:
		AmountAdding -= 1
		CurrentAmount += 1
		WaitTime -= 0.01
		Pitch += 0.1
		SFX.pitch_scale = Pitch
		SFX.play()
		await get_tree().create_timer(WaitTime).timeout
	Transferring = false
