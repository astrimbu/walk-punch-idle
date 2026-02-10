extends Node2D

var selected_character = "Smiley"  # Default character

@onready var character_sprite2 = $CanvasLayer/UI/CharacterSprite2
@onready var character_sprite3 = $CanvasLayer/UI/CharacterSprite3
@onready var animation_player2 = $CanvasLayer/AnimationPlayer2
@onready var animation_player3 = $CanvasLayer/AnimationPlayer3

func _ready():
	play_idle_animation()

func play_idle_animation():
	animation_player2.play("idleto-normal")
	animation_player3.play("idleto-normal")

func on_select_pressed():
	Global.selected_character = selected_character
	var player_state = SaveManager.get_player_state()
	var saved_scene: String = player_state.get("current_scene", "")
	if saved_scene.is_empty() or not ResourceLoader.exists(saved_scene):
		saved_scene = "res://scenes/Main.tscn"
	if ResourceLoader.exists(saved_scene):
		get_tree().call_deferred("change_scene_to_file", saved_scene)

func _on_select_button_2_pressed():
	selected_character = "Farmer"
	on_select_pressed()

func _on_select_button_3_pressed():
	selected_character = "Smiley"
	on_select_pressed()
