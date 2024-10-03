extends Node

@onready var ap = $AnimationPlayer
@onready var ap2 = $AnimationPlayer2
@onready var em = $ExclamationMark

var intro_quest: Quest

func _ready() -> void:
	ap.play("idleto")
	ap2.play("rotate")
	_create_intro_quest()

func _create_intro_quest():
	intro_quest = Quest.new(
		"intro_quest",
		"Intro Quest",
		"Help WelcomeBot with a simple task",
		[
			"Talk to WelcomeBot",
			"Go to the other side of the map",
			"Return to WelcomeBot"
		],
		{"experience": 50, "gold": 100}
	)
	QuestManager.add(intro_quest.id, intro_quest)

func _on_click_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		print("Mouse button event detected")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("WelcomeBot clicked")
			if DialogueSystem.is_dialogue_active():
				DialogueSystem.next_dialogue()
			elif intro_quest.id in QuestManager.available_quests:
				print("Starting intro quest")
				_start_intro_quest()
			elif intro_quest.id in QuestManager.active_quests:
				print("Checking quest progress")
				_check_quest_progress()

func _start_intro_quest():
	QuestManager.start(intro_quest.id)
	print("Started ", intro_quest.id)
	em.visible = false
	DialogueSystem.start_dialogue("WelcomeBot", [
		"Hello, adventurer! Welcome to our world!",
		"Would you go to the other side of the map and check if everything is alright?",
		"Come back to me when you're done, and I'll reward you for your help!"
	])
	await DialogueSystem.dialogue_ended
	QuestManager.update(intro_quest.id)

func _check_quest_progress():
	var quest = QuestManager.active_quests[intro_quest.id]
	if quest.current_objective == 1:
		DialogueSystem.start_dialogue("WelcomeBot", [
				"Have you checked the other side of the map yet?",
				"Please go there and come back when you're done."
			])
	elif quest.current_objective == 2:
		DialogueSystem.start_dialogue("WelcomeBot", [
				"Ah, you're back! Thank you for your help!",
				"Here's your reward for completing the task."
			])
		await DialogueSystem.dialogue_ended
		QuestManager.complete(intro_quest.id)
		NotificationSystem.show_notification("Received 50 XP, 100 Gold", 20.0)
