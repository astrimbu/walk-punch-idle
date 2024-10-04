extends Node

signal dialogue_started(npc_name, dialogue)
signal dialogue_ended

var current_dialogue = []
var current_index = 0
var can_advance = true

func start_dialogue(npc_name, dialogue):
	current_dialogue = dialogue
	current_index = 0
	emit_signal("dialogue_started", npc_name, current_dialogue[current_index])
	can_advance = true

func next_dialogue():
	if not can_advance:
		return
	can_advance = false
	current_index += 1
	if current_index < current_dialogue.size():
		emit_signal("dialogue_started", "", current_dialogue[current_index])
	else:
		emit_signal("dialogue_ended")
		current_dialogue = []
		current_index = 0
	await get_tree().create_timer(0.2).timeout
	can_advance = true

func is_dialogue_active():
	return current_dialogue.size() > 0

func _input(event):
	if event.is_action_pressed("ui_accept") and is_dialogue_active():
		next_dialogue()
