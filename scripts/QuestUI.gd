extends Control

@onready var quest_label = $QuestLabel

func _ready():
	QuestManager.connect("quest_started", Callable(self, "_on_quest_manager_quest_started"))
	QuestManager.connect("quest_updated", Callable(self, "_on_quest_manager_quest_updated"))
	QuestManager.connect("quest_completed", Callable(self, "_on_quest_manager_quest_completed"))

func _on_quest_manager_quest_started(quest_id):
	var quest = QuestManager.active_quests[quest_id]
	quest_label.text = "Current Quest: " + quest.name + "\n" + quest.get_current_objective()

func _on_quest_manager_quest_updated(quest_id, objective):
	quest_label.text = "Current Quest: " + QuestManager.active_quests[quest_id].name + "\n" + objective

func _on_quest_manager_quest_completed(quest_id):
	quest_label.text = "Quest Completed: " + QuestManager.completed_quests[quest_id].name
	await get_tree().create_timer(2.0).timeout
	quest_label.text = ""
