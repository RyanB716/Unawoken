extends Area2D

@onready var NoteScroll = $CanvasLayer/Scroll

var CanOpen : bool = false

func _ready():
	$Prompt.visible = false
	
func _process(_delta):
	if CanOpen && Input.is_action_just_pressed("Interact"):
		if NoteScroll.visible == true:
			NoteScroll.visible = false
		else:
			NoteScroll.visible = true

func _on_area_entered(area):
	if area.get_parent() is Player:
		CanOpen = true
		$Prompt.visible = true

func _on_area_exited(_area):
	$Prompt.visible = false
	CanOpen = false
	NoteScroll.visible = false
