extends NPC

signal quest_started

func _ready() -> void:
	super._ready()

func _create_quest():
	QuestManager.add_from_database("quest2")
	quest = QuestManager.available_quests["quest2"]

func _on_click_area_input_event(viewport, event, shape_idx):
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var current_time = Time.get_ticks_msec()
	if current_time - last_click_time < 50:
		return
	last_click_time = current_time

	if DialogueSystem.is_dialogue_active():
		DialogueSystem.next_dialogue()
		return

	# Ensure quest2 exists in QuestManager when not completed
	if not SaveManager.is_quest_completed("quest2"):
		if "quest2" not in QuestManager.active_quests and "quest2" not in QuestManager.available_quests:
			QuestManager.add_from_database("quest2")
		quest = QuestManager.available_quests.get("quest2") if QuestManager.available_quests.has("quest2") else QuestManager.active_quests.get("quest2")

	# Start quest: available to take
	if "quest2" in QuestManager.available_quests:
		quest = QuestManager.available_quests["quest2"]
		_start_quest()
		return
	# In progress
	if quest and quest.id in QuestManager.active_quests:
		_check_quest_progress()
		return
	# Already completed - optional post-completion dialogue
	if SaveManager.is_quest_completed("quest2"):
		DialogueSystem.start_dialogue(npc_name, [
			"Thanks again for your help!",
		])

func _start_quest():
	QuestManager.start(quest.id)
	emit_signal("quest_started")
	DialogueSystem.start_dialogue(npc_name, [
		"Hey, you found Level 2, nice.",
		"I've opened the door for you.",
		"Feel free to explore!",
	])
	await DialogueSystem.dialogue_ended
	QuestManager.update(quest.id)

func _check_quest_progress():
	var active_quest = QuestManager.active_quests[quest.id]
	if active_quest.current_objective == 1:
		DialogueSystem.start_dialogue(npc_name, ["Go explore!"])
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
		# Add any specific actions for completing the red quest
		pass
