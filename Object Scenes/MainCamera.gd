extends Camera2D

@onready var Target : CharacterBody2D

func _ready():
	Target = get_tree().get_first_node_in_group("Player")
	
func _process(delta):
	self.global_position = Target.global_position

@export_category("Camera Shake Properties")
@export var ShakeDecay : float
@export var MaxOffset : Vector2
@export var ShakeStrength : float
@export var ShakeScaler : float
