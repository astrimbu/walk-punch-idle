extends CanvasLayer

@onready var notification_label = $NotificationLabel
@onready var quest_ui = $QuestUI

func _ready():
	# Set up QuestUI
	quest_ui.anchor_right = 1
	quest_ui.anchor_bottom = 1
	quest_ui.offset_right = 0
	quest_ui.offset_bottom = 0

	NotificationSystem.connect("notification_displayed", Callable(self, "_on_notification_system_notification_displayed"))

func _on_notification_system_notification_displayed(text):
	notification_label.text = text
	notification_label.visible = true
	await get_tree().create_timer(10.0).timeout
	notification_label.visible = false
