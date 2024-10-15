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
	if ResourceLoader.exists("res://scenes/Main.tscn"):
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Main.tscn")
		Global.selected_character = selected_character

func _on_select_button_2_pressed():
	selected_character = "Farmer"
	on_select_pressed()

func _on_select_button_3_pressed():
	selected_character = "Smiley"
	on_select_pressed()
