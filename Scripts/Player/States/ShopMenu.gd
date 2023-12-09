extends Panel
class_name ShopMenu

@export var DialogueBox : RichTextLabel
@export var ItemPanels : HBoxContainer
@export var Portrait : TextureRect
@export var Audio : AudioStreamPlayer

@onready var player = get_parent().player

@onready var SlotScene = preload("res://Object Scenes/NPCS/Merchants/Ware_Slot.tscn")


var Buttons : Array[Button]

var NPC : Merchant

var newText : String

func _ready():
	self.visible = false
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		player.IsInMenu = false
		print("Closing Menu...")
		self.visible = false
		get_tree().paused = false
		
	if Input.is_action_just_pressed("Attack") && self.visible:
		ChooseDialogue(NPC.Dialogue, NPC.SpokenDialogue)
	
func OpenMenu(npc : Merchant):
	player.IsInMenu = true
	NPC = npc
	ClearMenu()
	print("Opening Menu...")
	Audio.stream = NPC.voice
	self.visible = true
	get_tree().paused = true
	
	for i in NPC.Wares.size():
		var newPanel = SlotScene.instantiate()
		if newPanel is Ware_Slot:
			newPanel.AssignData(NPC.Wares[i])
			newPanel.controller = self
			ItemPanels.add_child(newPanel)
			Buttons.append(newPanel.BuyButton)
			
	Portrait.texture = NPC.Portrait
	UpdateText(NPC.Greeting)
	await get_tree().create_timer(0.25).timeout
	Buttons[0].grab_focus()

func ClearMenu():
	Buttons.clear()
	for i in ItemPanels.get_child_count():
		ItemPanels.get_child(i).queue_free()
		
func ChooseDialogue(array : Array[String], pullArray):
	var RNG = RandomNumberGenerator.new()
	RNG.randomize()
	var Index = RNG.randi_range(0, array.size() - 1)
	UpdateText(array[Index])
	pullArray.append(array[Index])
	array.remove_at(Index)
	if array.size() <= 1:
		NPC.RepopulateDialogue(array, pullArray)

func UpdateText(message : String):
	DialogueBox.text = ""
	
	if newText != "":
		newText = ""
	newText = message
	
	for i in newText.length():
		if newText == message:
			var RNG = RandomNumberGenerator.new()
			RNG.randomize()
			var value = RNG.randf_range(0, 100)
			if value <= 10 or i == 0 && newText[i] != "." && newText[i] != " ":
				var newPoint = RNG.randf_range(0.1, NPC.voice.get_length())
				Audio.play(newPoint)
			DialogueBox.text += newText[i]
			await get_tree().create_timer(0.025).timeout
		else:
			break
	Audio.stop()
