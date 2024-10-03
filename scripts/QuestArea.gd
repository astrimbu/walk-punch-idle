extends Area2D

@export var quest_id: String
@export var objective_index: int

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	print("QuestArea ready. Quest ID: ", quest_id, ", Objective Index: ", objective_index)

func _on_body_entered(body: Node2D):
	print("Body entered QuestArea. Body: ", body.name)
	if body.is_in_group("player"):
		print("Body is in 'player' group")
		if quest_id in QuestManager.active_quests:
			print("Quest ", quest_id, " is active")
			var quest = QuestManager.active_quests[quest_id]
			print("Current objective: ", quest.current_objective, ", Target objective: ", objective_index)
			if quest.current_objective == objective_index:
				print("Updating quest and showing notification")
				QuestManager.update(quest_id)
				NotificationSystem.show_notification("Objective completed! Return to WelcomeBot for your reward.", 20.0)
			else:
				print("Objective index mismatch")
		else:
			print("Quest ", quest_id, " is not active")
	else:
		print("Body is not in 'player' group")
