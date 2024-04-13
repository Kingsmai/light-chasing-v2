extends Node
class_name StateMachine

@export var initial_state : State

var current_state : State
var states : Dictionary = {}


func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_state_transitioned)
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func  _physics_process(delta: float) -> void:
	if current_state:
		current_state.physic_update(delta)


func _on_state_transitioned(state: State, new_state_name: String):
	if state != current_state:
		print(get_parent().name + str(get_parent().get_rid()) + " ERROR: state " + str(state) + " not equal as current state " + str(current_state))
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print(get_parent().name + str(get_parent().get_rid()) + " ERROR: coudn't find state: " + new_state_name)
		return
	
	if current_state:
		print(get_parent().name + str(get_parent().get_rid()) + " Exiting current state: " + str(current_state))
		current_state.exit()
	
	print(get_parent().name + str(get_parent().get_rid()) + " Entering new state: " + str(new_state))
	new_state.enter()
	
	current_state = new_state
