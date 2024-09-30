extends BaseCharacterAnimations

class_name SmileyAnimations

func _init(player: CharacterBody2D):
	super._init(player)
	animation_player = player.get_node("AnimationPlayer2")
	sprite = player.get_node("Sprite2D2")
