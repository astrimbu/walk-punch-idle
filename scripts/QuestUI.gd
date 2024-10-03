extends Control

@onready var quest_label = $QuestLabel

func _ready():
	# Set up QuestLabel
	quest_label.anchor_left = 0
	quest_label.anchor_top = 0
	quest_label.anchor_right = 0
	quest_label.anchor_bottom = 0
	quest_label.offset_left = 10
	quest_label.offset_top = 10
	quest_label.offset_right = 210  # Adjust based on desired width
	quest_label.offset_bottom = 36  # Adjust based on desired height

	# Connect to QuestManager signals
	QuestManager.connect("quest_started", Callable(self, "_on_quest_manager_quest_started"))
	QuestManager.connect("quest_updated", Callable(self, "_on_quest_manager_quest_updated"))
	QuestManager.connect("quest_completed", Callable(self, "_on_quest_manager_quest_completed"))

	# Add click functionality to the quest_label
	quest_label.mouse_filter = Control.MOUSE_FILTER_STOP
	quest_label.gui_input.connect(_on_quest_label_gui_input)

func _on_quest_manager_quest_started(quest_id):
	var quest = QuestManager.active_quests[quest_id]
	quest_label.text = "Current Quest: " + quest.name + "\n" + quest.get_current_objective()

func _on_quest_manager_quest_updated(quest_id, objective):
	quest_label.text = "Current Quest: " + QuestManager.active_quests[quest_id].name + "\n" + objective

func _on_quest_manager_quest_completed(quest_id):
	quest_label.text = "Quest Completed: " + QuestManager.completed_quests[quest_id].name

func _on_quest_label_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		quest_label.text = ""
