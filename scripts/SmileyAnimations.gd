extends BaseCharacterAnimations

class_name SmileyAnimations

func _init(player: CharacterBody2D):
	super._init(player)
	animation_player = player.get_node("AnimationPlayer2")
	sprite = player.get_node("Sprite2D2")

func play_punch_animation(last_direction: Vector2):
	_flip_sprite(last_direction.x)
	_play_directional_animation("gangnam", last_direction)
