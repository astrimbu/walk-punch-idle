extends Node2D

func _input(_event):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn")

func _ready():
	var portal = get_node("Portals/PortalToLevel2")
	if portal:
		portal.update_visibility()
	else:
		print("Portal not found in Main scene")

	# Call a function to set up the player after a short delay
	call_deferred("setup_player")

func setup_player():
	var player = get_node_or_null("Player")
	if player:
		var player_state = SaveManager.get_player_state()
		if player_state["current_scene"] == scene_file_path:
			player.global_position = Vector2(player_state["position"]["x"], player_state["position"]["y"])
	else:
		print("Player node not found in Main scene")
