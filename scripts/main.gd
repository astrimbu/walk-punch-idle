extends Node2D

func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn")

func _ready():
	var portal = get_node("Portals/PortalToLevel2")
	if portal:
		print("Portal found in Main scene. Position:", portal.global_position)
		portal.update_visibility()
	else:
		print("Portal not found in Main scene")
