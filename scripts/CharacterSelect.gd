extends Node2D

var selected_character = "Robot"  # Default character

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

func play_idle_animation():
	animation_player.play("idleto")
	animation_player2.play("idleto-normal")
	animation_player3.play("idleto-normal")

func on_select_pressed():
	if ResourceLoader.exists("res://scenes/Main.tscn"):
		# Pass the selected character to the main scene
		get_tree().call_deferred("change_scene_to_file", "res://scenes/Main.tscn")
		# Store the selected character in an autoload script or global variable
		Global.selected_character = selected_character

func _on_select_button_pressed():
	selected_character = "Robot"
	on_select_pressed()

func _on_select_button_2_pressed():
	selected_character = "Farmer"
	on_select_pressed()

func _on_select_button_3_pressed():
	selected_character = "Smiley"
	on_select_pressed()
