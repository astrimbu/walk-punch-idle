extends NPC

@onready var Cookies = get_node("/root/Level2/CookiesLayer/Cookies")

func _on_ClickArea_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Cookies:
			toggle_cookies_ui()

func toggle_cookies_ui() -> void:
	if Cookies.visible:
		Cookies.hide_ui()
	else:
		Cookies.show_ui()
