class_name Quest
extends Resource

@export var id: String
@export var name: String
@export var description: String
@export var objectives: Array
@export var current_objective: int = 0
@export var reward: Dictionary

func _init(p_id = "", p_name = "", p_description = "", p_objectives = [], p_reward = {}):
	id = p_id
	name = p_name
	description = p_description
	objectives = p_objectives
	reward = p_reward

func advance_objective():
	current_objective += 1
	return current_objective >= objectives.size()

func get_current_objective():
	return objectives[current_objective] if current_objective < objectives.size() else ""
