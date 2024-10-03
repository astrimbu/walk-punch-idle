extends Node

signal notification_displayed(text)

func show_notification(text: String, duration: float = 5.0):
	emit_signal("notification_displayed", text)
	await get_tree().create_timer(duration).timeout
