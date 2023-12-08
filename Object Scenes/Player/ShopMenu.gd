extends Panel
class_name ShopMenu

@export var DialogueBox : RichTextLabel

@onready var player = get_parent().player

@onready var SlotScene = preload("res://Object Scenes/NPCS/Merchants/Ware_Slot.tscn")

var Buttons : Array[Button]

var NPC : Merchant

var newText : String

func _ready():
	self.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		print("Closing Menu...")
		self.visible = false
		get_tree().paused = false
		
	if Input.is_action_just_pressed("CycleElixir"):
		var RNG = RandomNumberGenerator.new()
		RNG.randomize()
		var Index = RNG.randi_range(0, NPC.Dialogue.size() - 1)
		UpdateText(NPC.Dialogue[Index])
		NPC.SpokenLines.append(NPC.Dialogue[Index])
		NPC.Dialogue.remove_at(Index)
		if NPC.Dialogue.size() <= 1:
			NPC.RepopulateDialogue()
	
func OpenMenu(npc : Merchant):
	NPC = npc
	ClearMenu()
	print("Opening Menu...")
	self.visible = true
	get_tree().paused = true
	
	for i in NPC.Wares.size():
		var newPanel = SlotScene.instantiate()
		if newPanel is Ware_Slot:
			newPanel.AssignData(NPC.Wares[i])
			$HBoxContainer.add_child(newPanel)
			Buttons.append(newPanel.BuyButton)
			
	$Portrait.texture = NPC.Portrait
	UpdateText(NPC.Greeting)
	await get_tree().create_timer(0.25).timeout
	Buttons[0].grab_focus()

func ClearMenu():
	Buttons.clear()
	for i in $HBoxContainer.get_child_count():
		$HBoxContainer.get_child(i).queue_free()

func UpdateText(message : String):
	DialogueBox.text = ""
	
	if newText != "":
		newText = ""
	newText = message
	
	for i in newText.length():
		if newText == message:
			DialogueBox.text += message[i]
			await get_tree().create_timer(0.05).timeout
		else:
			break
