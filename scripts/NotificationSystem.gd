extends Node

signal notification_displayed(text)
signal notification_hidden

func show_notification(text: String):
	emit_signal("notification_displayed", text)

func hide_notification():
	emit_signal("notification_hidden")
