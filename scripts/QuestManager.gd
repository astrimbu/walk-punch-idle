extends Node

var available_quests = {}
var active_quests = {}
var completed_quests = {}

signal quest_started(quest_id)
signal quest_updated(quest_id, objective)
signal quest_completed(quest_id)

func add(quest_id, quest_data):
	available_quests[quest_id] = quest_data

func start(quest_id):
	if quest_id in available_quests:
		active_quests[quest_id] = available_quests[quest_id]
		available_quests.erase(quest_id)
		emit_signal("quest_started", quest_id)
		emit_signal("quest_updated", quest_id, active_quests[quest_id].get_current_objective())

func update(quest_id):
	if quest_id in active_quests:
		var quest = active_quests[quest_id]
		var is_complete = quest.advance_objective()
		if is_complete:
			complete(quest_id)
		else:
			emit_signal("quest_updated", quest_id, quest.get_current_objective())

func complete(quest_id):
	if quest_id in active_quests:
		completed_quests[quest_id] = active_quests[quest_id]
		active_quests.erase(quest_id)
		emit_signal("quest_completed", quest_id)

func fail(quest_id):
	if quest_id in active_quests:
		available_quests[quest_id] = active_quests[quest_id]
		active_quests.erase(quest_id)
