extends NPC

func _ready() -> void:
	super._ready()
	npc_name = "RedBot"

func _create_quest():
	QuestManager.add_from_database("red_quest")
	quest = QuestManager.available_quests["red_quest"]

func _start_quest():
	print("RedBot: _start_quest called")
	QuestManager.start(quest.id)
	DialogueSystem.start_dialogue(npc_name, [
		"Hey, you found Level 2, nice.",
		"I'm still working on the quest, sorry.",
	])
	print("RedBot: Dialogue started")
	await DialogueSystem.dialogue_ended
	print("RedBot: Dialogue ended")
	QuestManager.update(quest.id)

func _check_quest_progress():
	var active_quest = QuestManager.active_quests[quest.id]
	if active_quest.current_objective == 1:
		DialogueSystem.start_dialogue(npc_name, ["Have you completed the challenge yet?"])
	elif active_quest.current_objective == 2:
		DialogueSystem.start_dialogue(npc_name, [
			"Impressive! You've completed the challenge.",
			"Here's your reward for your bravery and skill."
		])
		await DialogueSystem.dialogue_ended
		QuestManager.complete(quest.id)
		NotificationSystem.show_notification("Received a special item!")

func _on_quest_manager_quest_completed(quest_id):
	if quest_id == quest.id:
		print("Red quest completed!")
		# Add any specific actions for completing the red quest
