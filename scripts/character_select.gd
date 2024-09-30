extends Node2D

var character = {
	"name": "Robot",
}

@onready var select_button = $CanvasLayer/UI/SelectButton
@onready var character_sprite = $CanvasLayer/UI/CharacterSprite
@onready var character_sprite2 = $CanvasLayer/UI/CharacterSprite2
@onready var character_sprite3 = $CanvasLayer/UI/CharacterSprite3
@onready var animation_player = $CanvasLayer/AnimationPlayer
@onready var animation_player2 = $CanvasLayer/AnimationPlayer2
@onready var animation_player3 = $CanvasLayer/AnimationPlayer3

var characters = ["Robot", "Farmer", "Smiley"]

func _ready():
	select_button.pressed.connect(on_select_pressed)
	play_idle_animation()
	
	# Initialize all sprites with no highlight
	for sprite in [character_sprite, character_sprite2, character_sprite3]:
		sprite.material.set_shader_parameter("outline_width", 0.0)
		sprite.material.set_shader_parameter("outline_color", Color(1, 1, 1, 0))

func play_idle_animation():
	animation_player.play("idleto")
	animation_player2.play("idleto-normal")
	animation_player3.play("idleto-normal")

func on_select_pressed():
	if ResourceLoader.exists("res://scenes/main.tscn"):
		get_tree().call_deferred("change_scene_to_file", "res://scenes/main.tscn")

func toggle_highlight(sprite):
	for s in [character_sprite, character_sprite2, character_sprite3]:
		s.material.set_shader_parameter("outline_width", 0.0)
		s.material.set_shader_parameter("outline_color", Color(1, 1, 1, 0))
	
	var tween = create_tween()
	tween.tween_property(sprite.material, "shader_parameter/outline_width", 1.0, 0.2)
	tween.parallel().tween_property(sprite.material, "shader_parameter/outline_color", Color(1, 1, 1, 1), 0.2)

func _on_select_button_2_pressed():
	toggle_highlight(character_sprite2)
	on_select_pressed()

func _on_select_button_pressed():
	toggle_highlight(character_sprite)
	on_select_pressed()

func _on_select_button_3_pressed():
	toggle_highlight(character_sprite3)
	on_select_pressed()
