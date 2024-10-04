extends CanvasLayer

@onready var notification_label = $NotificationLabel
@onready var quest_ui = $QuestUI

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
	notification_label.text = text
	notification_label.visible = true

func _on_notification_system_notification_hidden():
	notification_label.visible = false
