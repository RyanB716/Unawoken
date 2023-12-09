extends Area2D
class_name Merchant

@export_category("Data")
@export var Wares : Array[WareSlot]
@export var voice : AudioStream
@export var Portrait : Texture

@export_category("Aesthetics")
@export var Greeting : String

@export var Dialogue : Array[String]
@export var PurchaseLines : Array[String]
@export var FailLines : Array[String]

var SpokenDialogue : Array[String]
var SpokenPurchaseLines : Array[String]
var  SpokenFailLines : Array[String]

var CanInput = false

@onready var PlayerRef = get_tree().get_first_node_in_group("Player")
@onready var UI = get_tree().get_first_node_in_group("Player").get_node("Player UI")

func _ready():
	$Label.visible = false
	$AnimatedSprite2D.play("default")

func _process(_delta):
	if CanInput == true && Input.is_action_just_pressed("Interact"):
		print("Interacting with merchant!")
		UI.Shop.OpenMenu(self)

func _on_area_entered(area):
	if area.get_parent() is Player:
		$Label.visible = true
		CanInput = true

func _on_area_exited(area):
	$Label.visible = false
	CanInput = false
	UI.StatueMenu.visible = false

func RepopulateDialogue(PopArray : Array[String], PullArray : Array[String]):
	for i in PullArray.size():
		PopArray.append(PullArray[i])
