extends Camera2D

@onready var Target : CharacterBody2D

@export var CamSpeed : float

func _ready():
	Target = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	self.position = lerp(self.position, Target.position, CamSpeed * delta)
