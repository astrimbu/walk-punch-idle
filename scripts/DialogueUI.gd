extends CanvasLayer

@onready var dialogue_label = $DialogueLabel
@onready var welcome_bot = get_node("/root/Main/WelcomeBot")

var current_npc_name = ""

func _ready():
	DialogueSystem.connect("dialogue_started", Callable(self, "_on_dialogue_system_dialogue_started"))
	DialogueSystem.connect("dialogue_ended", Callable(self, "_on_dialogue_system_dialogue_ended"))
	dialogue_label.visible = false

func _on_dialogue_system_dialogue_started(npc_name, dialogue):
	if npc_name != "":
		current_npc_name = npc_name
	dialogue_label.text = current_npc_name + ": " + dialogue
	dialogue_label.visible = true

func _on_dialogue_system_dialogue_ended():
	dialogue_label.text = ""
	dialogue_label.visible = false
	current_npc_name = ""
