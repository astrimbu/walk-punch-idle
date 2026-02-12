extends CanvasLayer

@onready var notification_label = $NotificationLabel
@onready var quest_ui = $QuestUI

var _notification_tween: Tween

func _ready():
	# Set up QuestUI
	quest_ui.anchor_right = 1
	quest_ui.anchor_bottom = 1
	quest_ui.offset_right = 0
	quest_ui.offset_bottom = 0
	
	notification_label.offset_left = 0
	notification_label.offset_top = 180
	notification_label.offset_right = 640  # Adjust based on desired width
	notification_label.offset_bottom = 180  # Adjust based on desired height
	notification_label.anchor_left = 0
	notification_label.anchor_top = 0

	NotificationSystem.connect("notification_displayed", Callable(self, "_on_notification_system_notification_displayed"))
	NotificationSystem.connect("notification_hidden", Callable(self, "_on_notification_system_notification_hidden"))

func _on_notification_system_notification_displayed(text):
	if _notification_tween and _notification_tween.is_valid():
		_notification_tween.kill()
	notification_label.text = text
	notification_label.modulate.a = 0
	notification_label.visible = true
	_notification_tween = create_tween()
	_notification_tween.tween_property(notification_label, "modulate", Color(1, 1, 1, 1), 0.1).set_ease(Tween.EASE_OUT)

func _on_notification_system_notification_hidden():
	if _notification_tween and _notification_tween.is_valid():
		_notification_tween.kill()
	_notification_tween = create_tween()
	_notification_tween.tween_property(notification_label, "modulate", Color(1, 1, 1, 0), 0.1).set_ease(Tween.EASE_IN)
	_notification_tween.finished.connect(_hide_notification_label)

func _hide_notification_label():
	notification_label.visible = false
	if _notification_tween and _notification_tween.is_valid():
		_notification_tween.finished.disconnect(_hide_notification_label)
