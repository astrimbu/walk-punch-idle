extends Area2D

@export var quest_id: String
@export var objective_index: int

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if quest_id in QuestManager.active_quests:
			var quest = QuestManager.active_quests[quest_id]
			if quest.current_objective == objective_index:
				QuestManager.update(quest_id)
				NotificationSystem.show_notification("Objective completed!")
