extends Control

@onready var dialogue_label = $DialogueLabel


func _ready():
	DialogueSystem.connect("dialogue_started", Callable(self, "_on_dialogue_system_dialogue_started"))
	DialogueSystem.connect("dialogue_ended", Callable(self, "_on_dialogue_system_dialogue_ended"))
	dialogue_label.visible = false

func _on_dialogue_system_dialogue_started(npc_name, dialogue):
	dialogue_label.text = npc_name + ": " + dialogue
	dialogue_label.visible = true

func _on_dialogue_system_dialogue_ended():
	dialogue_label.text = ""
	dialogue_label.visible = false

func _input(event):
	if event.is_action_pressed("ui_accept") and dialogue_label.visible:
		DialogueSystem.next_dialogue()
