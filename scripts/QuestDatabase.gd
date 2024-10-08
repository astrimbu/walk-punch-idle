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
	),
	"red_quest": QuestData.new(
		"red_quest",
		"Red Quest",
		"Title of Red Quest",
		[
			"Do the first thing",
			"Do the second thing",
			"Return to RedBot"
		],
		{"experience": 100, "gold": 500}
	)
}

func get_quest(quest_id: String) -> QuestData:
	return quests.get(quest_id)
