extends Node2D

var character = {
	"name": "Robot",
}

@onready var character_name_label = $CanvasLayer/UI/CharacterName
@onready var select_button = $CanvasLayer/UI/SelectButton
@onready var character_sprite = $CanvasLayer/CharacterSprite
@onready var animation_player = $CanvasLayer/AnimationPlayer

# Add variables for navigation
var current_character_index = 0
var characters = ["Robot"]  # Add more character names here when you have them

func _ready():
	update_character_preview()
	select_button.pressed.connect(on_select_pressed)
	play_idle_animation()
	character_sprite.show()
	setup_highlight_effect()
	
	# Show highlight for the initial character
	toggle_highlight_effect(true)

func _input(event):
	if event.is_action_pressed("ui_left"):
		change_character(-1)
	elif event.is_action_pressed("ui_right"):
		change_character(1)

func change_character(direction):
	current_character_index = (current_character_index + direction) % characters.size()
	if current_character_index < 0:
		current_character_index = characters.size() - 1
	character["name"] = characters[current_character_index]
	update_character_preview()
	
	# Update highlight for the new character
	toggle_highlight_effect(true)

func update_character_preview():
	character_name_label.text = character["name"]
	# Here you would also update the character_sprite texture
	# character_sprite.texture = load("res://path/to/" + character["name"].to_lower() + "_sprite.png")

func play_idle_animation():
	animation_player.play("idleto")

func on_select_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func setup_highlight_effect():
	character_sprite.material.set_shader_parameter("outline_width", 0.0)
	character_sprite.material.set_shader_parameter("outline_color", Color(1, 1, 1, 0))  # White, fully transparent

func toggle_highlight_effect(highlight_on: bool):
	var tween = create_tween()
	if highlight_on:
		tween.tween_property(character_sprite.material, "shader_parameter/outline_width", 0.5, 0.2)
		tween.parallel().tween_property(character_sprite.material, "shader_parameter/outline_color", Color(1, 1, 1, 1), 0.2)
	else:
		tween.tween_property(character_sprite.material, "shader_parameter/outline_width", 0.0, 0.2)
		tween.parallel().tween_property(character_sprite.material, "shader_parameter/outline_color", Color(1, 1, 1, 0), 0.2)
