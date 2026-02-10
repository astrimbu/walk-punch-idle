extends Node2D

@onready var Cookies := $CookiesLayer/Cookies
@onready var portal := get_node("Portals/PortalToMain")

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # This is typically the ESCAPE key
		Cookies.hide_ui()

func _ready():
	if portal:
		portal.update_visibility()
	if Cookies:
		Cookies.hide_ui()
	call_deferred("setup_player")

func setup_player():
	var player = get_node_or_null("Player")
	if player:
		var player_state = SaveManager.get_player_state()
		if player_state["current_scene"] == scene_file_path:
			player.global_position = Vector2(player_state["position"]["x"], player_state["position"]["y"])

func _on_XButton_pressed() -> void:
	Cookies.hide_ui()
