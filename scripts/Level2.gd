extends Node2D

@onready var Cookies := $CookiesLayer/Cookies
@onready var portal := get_node("Portals/PortalToMain")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Cookies and Cookies.visible:
			Cookies.hide_ui()
		else:
			Global.character_select_return_scene = "res://scenes/Level2.tscn"
			get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn")

func _ready():
	QuestManager.load_character_state(SaveManager.get_character_quest_state())
	if portal:
		portal.update_visibility()
	if Cookies:
		Cookies.hide_ui()
	call_deferred("setup_player")

func setup_player():
	var player = get_node_or_null("YSort/Player")
	var player_state = SaveManager.get_player_state() if player else {}
	var is_restoring_position = player and player_state.get("current_scene") == scene_file_path
	if is_restoring_position:
		player.global_position = Vector2(player_state["position"]["x"], player_state["position"]["y"])

	# Restore door state so we don't soft-lock if player saved outside after unlocking
	var door = get_node_or_null("YSort/Door")
	if door and (SaveManager.is_quest_completed("quest2") or "quest2" in QuestManager.active_quests):
		door.unlock()
		# If player was saved outside the room, keep door open so they can re-enter
		if is_restoring_position and player.global_position.x > 40:
			door.open()

func _on_XButton_pressed() -> void:
	Cookies.hide_ui()
