extends CanvasLayer

@onready var dialogue_label = $DialogueLabel

@export var dialogue_position: Vector2 = Vector2.ZERO
@export var dialogue_size: Vector2 = Vector2(400, 100)
@export var font_size: int = 16
@export var background_color: Color = Color.BLACK

var current_npc_name = ""

func _ready():
	DialogueSystem.connect("dialogue_started", Callable(self, "_on_dialogue_system_dialogue_started"))
	DialogueSystem.connect("dialogue_ended", Callable(self, "_on_dialogue_system_dialogue_ended"))
	dialogue_label.visible = false
	apply_settings()

func apply_settings():
	dialogue_label.position = dialogue_position
	dialogue_label.size = dialogue_size
	dialogue_label.add_theme_font_size_override("font_size", font_size)
	dialogue_label.add_theme_color_override("font_color", background_color)

func _on_dialogue_system_dialogue_started(npc_name, dialogue):
	if npc_name != "":
		current_npc_name = npc_name
	dialogue_label.text = current_npc_name + ": " + dialogue
	dialogue_label.visible = true

func _on_dialogue_system_dialogue_ended():
	dialogue_label.text = ""
	dialogue_label.visible = false
	current_npc_name = ""
