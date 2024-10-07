extends Node

var quests = {
	"intro_quest": QuestData.new(
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
	# Add more quests here as needed
}

func get_quest(quest_id: String) -> QuestData:
	return quests.get(quest_id)
