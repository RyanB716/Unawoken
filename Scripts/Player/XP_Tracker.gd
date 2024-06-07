extends Panel
class_name XPTracker

@export var ResolvePoints : Label
@export var Amount : Label
@export var Bar : ProgressBar
@export var AddAmount : Label

@export var AddTimer : Timer
@export var SFX : AudioStreamPlayer
@export var XpTrack : AudioStream
@export var RpTrack : AudioStream
@export var CollapseTrack : AudioStream

@onready var CurrentAmount : int
@onready var AmountAdding : int
