extends NPC

@onready var ap2 = $AnimationPlayer2
@onready var em = $ExclamationMark

func _ready() -> void:
	super._ready()
	_check_quest_status()

func _on_click_area_input_event(viewport, event, shape_idx):
	if not (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var current_time = Time.get_ticks_msec()
	if current_time - last_click_time < 50:
		return
	last_click_time = current_time

	if DialogueSystem.is_dialogue_active():
		DialogueSystem.next_dialogue()
	elif quest and quest.id in QuestManager.available_quests:
		_start_quest()
	elif quest and quest.id in QuestManager.active_quests:
		_check_quest_progress()
	elif SaveManager.is_quest_completed("intro_quest"):
		DialogueSystem.start_dialogue(npc_name, [
			"Hello again, adventurer! Thanks again for your help.",
		])

func _setup_animations():
	ap.play("idleto")
	ap2.play("rotate")

func _check_quest_status():
	if SaveManager.is_quest_completed("intro_quest"):
		em.visible = false
	else:
		_create_quest()

func _create_quest():
	if not SaveManager.is_quest_completed("intro_quest"):
		QuestManager.add_from_database("intro_quest")
		quest = QuestManager.available_quests["intro_quest"]

func _start_quest():
	if SaveManager.is_quest_completed("intro_quest"):
		DialogueSystem.start_dialogue(npc_name, [
			"Hello again, adventurer! Thanks again for your help.",
		])
		return

	QuestManager.start(quest.id)
	em.visible = false
	DialogueSystem.start_dialogue(npc_name, [
		"Hello, adventurer! Welcome to our world!",
		"Would you go to the other side of the map and check if everything is alright?",
		"Come back to me when you're done, and I'll reward you for your help!",
	])
	await DialogueSystem.dialogue_ended
	QuestManager.update(quest.id)

func _check_quest_progress():
	var active_quest = QuestManager.active_quests[quest.id]
	if active_quest.current_objective == 1:
		DialogueSystem.start_dialogue(npc_name, [
			"Have you checked the other side of the map yet?"
		])
	elif active_quest.current_objective == 2:
		DialogueSystem.start_dialogue(npc_name, [
			"You're back! Thank you for checking for me.",
			"Here's your reward for completing the task."
		])
		await DialogueSystem.dialogue_ended
		QuestManager.complete(quest.id)
		NotificationSystem.show_notification("Received nothing!")
		var timer = get_tree().create_timer(2.0)
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
