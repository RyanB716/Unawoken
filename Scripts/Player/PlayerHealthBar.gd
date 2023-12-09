extends ProgressBar

@export var player : Player 

func _ready():
	self.max_value = player.MaxHealth

func _process(_delta):
	self.value = player.CurrentHealth
