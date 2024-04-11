extends Area2D
class_name ShieldController

@onready var Collider : CollisionShape2D
@onready var Anim : AnimationPlayer
@onready var Sprite : Sprite2D

func _ready():
	Collider = $CollisionShape2D
	Sprite = $Sprite2D
	Anim = $"Shield Animation"

func Enable():
	#print("Guard ON")
	if Collider.disabled == true:
		Collider.disabled = false
		Anim.play("Enable")

func Disable():
	#print("Guard OFF")
	if Collider.disabled == false:
		Collider.disabled = true
		Anim.play("Disable")
