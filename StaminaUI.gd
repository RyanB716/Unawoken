extends HBoxContainer

@onready var StaminaTexture = preload("res://StaminaCircle.tscn")

@onready var PlayerRef = $"../.."

var NumOfCircles : int

func _ready():
	NumOfCircles = PlayerRef.MaxStaminaMoves
	
	for i in NumOfCircles - 1:
		var newCircle = StaminaTexture.instantiate()
		add_child(newCircle)
	
func UpdateCircles(Amnt : int):
	
	#find first Empty circle
	var FirstEmpty
	for i in NumOfCircles:
		if get_child(i).IsFilled == false:
			FirstEmpty = get_child(i)
	
	if FirstEmpty == null:
		FirstEmpty = self.get_child(get_child_count() - 1)
	
	for i in Amnt:
		var nextCircle = self.get_child(get_child_count() - (i + 1))
		nextCircle.IsFilled = false
		
