extends Area2D

@export var quest_id: String
@export var objective_index: int

var hide_timer: Timer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Create and configure the timer
	hide_timer = Timer.new()
	hide_timer.one_shot = true
	hide_timer.wait_time = 2.0  # 1 second delay
	hide_timer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))
	add_child(hide_timer)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		hide_timer.stop()
		if quest_id in QuestManager.active_quests:
			var quest = QuestManager.active_quests[quest_id]
			if quest.current_objective == objective_index:
				QuestManager.update(quest_id)
				NotificationSystem.show_notification("Objective completed! Return to WelcomeBot for your reward.")

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		hide_timer.start()  # Start the 1-second timer

func _on_hide_timer_timeout():
	NotificationSystem.hide_notification()
