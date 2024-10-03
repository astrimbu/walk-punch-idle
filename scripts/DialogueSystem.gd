extends Node

signal dialogue_started(npc_name, dialogue)
signal dialogue_ended

var current_dialogue = []
var current_index = 0

func start_dialogue(npc_name: String, dialogue: Array):
	current_dialogue = dialogue
	current_index = 0
	print("Starting dialogue: " + npc_name + " - " + dialogue[0])  # Debug print
	emit_signal("dialogue_started", npc_name, current_dialogue[current_index])

func next_dialogue():
	current_index += 1
	if current_index < current_dialogue.size():
		print("Next dialogue: " + current_dialogue[current_index])  # Debug print
		emit_signal("dialogue_started", "", current_dialogue[current_index])
	else:
		print("Dialogue ended")  # Debug print
		emit_signal("dialogue_ended")
		current_dialogue = []
		current_index = 0

func is_dialogue_active():
	return current_dialogue.size() > 0

func _input(event):
	if event.is_action_pressed("ui_accept") and is_dialogue_active():
		next_dialogue()
