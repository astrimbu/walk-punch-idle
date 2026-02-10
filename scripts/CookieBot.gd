extends NPC

func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var cookies_ui = get_tree().get_first_node_in_group("cookies_ui")
		if cookies_ui:
			toggle_cookies_ui(cookies_ui)

func toggle_cookies_ui(cookies_ui: Control) -> void:
	if cookies_ui.visible:
		cookies_ui.hide_ui()
	else:
		cookies_ui.show_ui()
