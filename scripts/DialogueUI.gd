extends CanvasLayer

@onready var dialogue_label = $DialogueLabel

@export var dialogue_position: Vector2 = Vector2.ZERO
@export var dialogue_size: Vector2 = Vector2(64, 1)
@export var font_size: int = 10
@export var color: Color = Color.WHITE
@export var shadow_color: Color = Color(1 - color.r, 1 - color.g, 1-color.b, color.a)

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
	dialogue_label.add_theme_color_override("font_color", color)
	dialogue_label.add_theme_color_override("font_shadow_color", shadow_color)

func _on_dialogue_system_dialogue_started(npc_name, dialogue):
	if npc_name != "":
		current_npc_name = npc_name
	if dialogue == "":
		dialogue_label.text = dialogue
	else:
		dialogue_label.text = current_npc_name + ": " + dialogue
	dialogue_label.modulate = Color(1, 1, 1, 0)
	dialogue_label.visible = true
	var t = create_tween()
	t.tween_property(dialogue_label, "modulate", Color(1, 1, 1, 1), 0.1).set_ease(Tween.EASE_OUT)

func _on_dialogue_system_dialogue_ended():
	dialogue_label.text = ""
	dialogue_label.visible = false
	current_npc_name = ""
