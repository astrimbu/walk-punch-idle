extends CanvasLayer

@onready var notification_label = $NotificationLabel

func _ready():
	NotificationSystem.connect("notification_displayed", Callable(self, "_on_notification_system_notification_displayed"))

func _on_notification_system_notification_displayed(text):
	notification_label.text = text
	notification_label.visible = true
	await get_tree().create_timer(2.0).timeout
	notification_label.visible = false
