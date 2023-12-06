extends Node
class_name StateMachine

@export var InitialState : State

var CurrentState : State

var StatesList : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			StatesList[child.name.to_lower()] = child
			child.Transitioned.connect(OnStateTransition)
			
	if InitialState:
		InitialState.OnEnter()
		CurrentState = InitialState
			
func _process(delta):
	if CurrentState:
		CurrentState.Update(delta)
	
func _physics_process(delta):
	if CurrentState:
		CurrentState.PhysicsUpdate(delta)

func OnStateTransition(newStateName):
	var nextState = StatesList.get(newStateName.to_lower())
	if !nextState:
		return
		
	if CurrentState:
		CurrentState.OnExit()
	
	nextState.OnEnter()
	CurrentState = nextState
