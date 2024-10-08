extends NPC

@onready var ap2 = $AnimationPlayer2
@onready var em = $ExclamationMark

func _ready() -> void:
	super._ready()

func _setup_animations():
	ap.play("idleto")
	ap2.play("rotate")

func _create_quest():
	QuestManager.add_from_database("intro_quest")
	quest = QuestManager.available_quests["intro_quest"]

func _start_quest():
	print("WelcomeBot: _start_quest called")
	QuestManager.start(quest.id)
	em.visible = false
	DialogueSystem.start_dialogue(npc_name, [
		"Hello, adventurer! Welcome to our world!",
		"Would you go to the other side of the map and check if everything is alright?",
		"Come back to me when you're done, and I'll reward you for your help!",
	])
	print("WelcomeBot: Dialogue started")
	await DialogueSystem.dialogue_ended
	print("WelcomeBot: Dialogue ended")
	QuestManager.update(quest.id)

func _check_quest_progress():
	var active_quest = QuestManager.active_quests[quest.id]
	if active_quest.current_objective == 1:
		DialogueSystem.start_dialogue(npc_name, [
			"Have you checked the other side of the map yet?"
		])
	elif active_quest.current_objective == 2:
		DialogueSystem.start_dialogue(npc_name, [
			"Wow you did it! That's incredible, thanks!",
			"Here's your reward for completing the task."
		])
		await DialogueSystem.dialogue_ended
		QuestManager.complete(quest.id)
		NotificationSystem.show_notification("Received nothing!")
		var timer = get_tree().create_timer(5.0)
		await timer.timeout
		NotificationSystem.hide_notification()

func _on_quest_manager_quest_completed(quest_id):
	if quest_id == quest.id:
		activate_portal()

func activate_portal():
	var portal = get_tree().current_scene.get_node("Portals/PortalToLevel2")
	if portal:
		portal.activate()
	else:
		print("Portal not found in the current scene")
