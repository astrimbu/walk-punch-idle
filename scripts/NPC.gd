extends CharacterBody2D

class_name NPC

@export var npc_name: String = "NPC"
@onready var ap = $AnimationPlayer
@onready var click_area = $ClickArea

var quest: Quest
var last_click_time = 0

func _ready() -> void:
	add_to_group("npc")
	QuestManager.connect("quest_completed", Callable(self, "_on_quest_manager_quest_completed"))
	_setup_animations()
	_create_quest()

func _setup_animations():
	# Override in derived classes if needed
	if ap:
		ap.play("idle")

func _create_quest():
	# Override in derived classes
	pass

func _on_click_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var current_time = Time.get_ticks_msec()
		if current_time - last_click_time < 50:  # Ignore clicks within 50ms of each other
			return
		last_click_time = current_time

		print("%s: Click detected at %s" % [npc_name, current_time])
		print("Dialogue active: ", DialogueSystem.is_dialogue_active())
		if quest:
			print("Quest available: ", quest.id in QuestManager.available_quests)
			print("Quest active: ", quest.id in QuestManager.active_quests)

		if DialogueSystem.is_dialogue_active():
			print("%s: Dialogue active, advancing" % npc_name)
			DialogueSystem.next_dialogue()
		elif quest and quest.id in QuestManager.available_quests:
			print("%s: Starting quest" % npc_name)
			_start_quest()
		elif quest and quest.id in QuestManager.active_quests:
			print("%s: Checking quest progress" % npc_name)
			_check_quest_progress()

func _start_quest():
	# Override in derived classes
	pass

func _check_quest_progress():
	# Override in derived classes
	pass

func _on_quest_manager_quest_completed(quest_id):
	# Override in derived classes if needed
	pass
