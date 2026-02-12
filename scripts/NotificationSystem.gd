extends Node

signal notification_displayed(text)
signal notification_hidden

var _hide_timer: Timer

func show_notification(text: String, duration: float = 0.0):
	emit_signal("notification_displayed", text)
	if duration > 0:
		if _hide_timer == null:
			_hide_timer = Timer.new()
			_hide_timer.one_shot = true
			_hide_timer.timeout.connect(_on_hide_timer_timeout)
			add_child(_hide_timer)
		_hide_timer.start(duration)

func hide_notification():
	emit_signal("notification_hidden")

func _on_hide_timer_timeout():
	_hide_timer.stop()
	hide_notification()
