extends ProgressBar

@onready var PlayerRef = $"../.."

func _ready():
	self.max_value = PlayerRef.MaxHealth

func _process(_delta):
	self.value = PlayerRef.CurrentHealth
