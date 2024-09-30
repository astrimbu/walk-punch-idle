extends BaseCharacterAnimations

class_name FarmerAnimations

func _init(player: CharacterBody2D):
	super._init(player)
	animation_player = player.get_node("AnimationPlayer3")
	sprite = player.get_node("Sprite2D3")
	
