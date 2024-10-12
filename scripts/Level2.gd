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

func _on_XButton_pressed() -> void:
	Cookies.hide_ui()
