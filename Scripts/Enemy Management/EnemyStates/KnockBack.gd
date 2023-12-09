extends State
class_name KnockBack

@export var SelfRef : Moblin

func OnEnter():
	#print("Enemy is knocked back!")
	SelfRef.IsKnockedBack = true
	SelfRef.velocity = SelfRef.KB_dir * SelfRef.KB_scale
	await get_tree().create_timer(SelfRef.KB_scale).timeout
	
	Transitioned.emit("Idle")

func OnExit():
	#print("Leaving KB state")
	SelfRef.KB_dir = Vector2.ZERO
	SelfRef.KB_scale = 0
	SelfRef.KB_time = 0
	SelfRef.IsKnockedBack = false
