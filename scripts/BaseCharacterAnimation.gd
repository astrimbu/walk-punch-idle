extends Node

class_name BaseCharacterAnimations

signal animation_finished(anim_name: String)

var animation_player: AnimationPlayer
var sprite: Sprite2D

func _init(player: CharacterBody2D):
	animation_player = player.get_node("AnimationPlayer2")
	sprite = player.get_node("Sprite2D2")
	animation_player.connect("animation_finished", Callable(self, "_on_animation_player_finished"))

func _on_animation_player_finished(anim_name: String):
	animation_finished.emit(anim_name)

func play_walk_animation(direction: Vector2):
	_flip_sprite(direction.x)
	var anim_name = _play_directional_animation("walk", direction)
	# Scale walk animation so one cycle = 1 second, matching move speed (no sliding)
	if anim_name and animation_player.has_animation(anim_name):
		animation_player.speed_scale = animation_player.get_animation(anim_name).length
	else:
		animation_player.speed_scale = 1.0

func play_idle_animation(last_direction: Vector2):
	_flip_sprite(last_direction.x)
	animation_player.speed_scale = 1.0
	_play_directional_animation("idle", last_direction)

func play_punch_animation(last_direction: Vector2):
	_flip_sprite(last_direction.x)
	animation_player.speed_scale = 1.0
	_play_directional_animation("punch", last_direction)

func show_sprite():
	sprite.show()

func hide_sprite():
	sprite.hide()

func _get_direction(vector: Vector2) -> int:
	var angle = vector.angle()
	var degrees = rad_to_deg(angle)
	return int(round(degrees / 45) * 45)

func _flip_sprite(x_direction: float):
	if x_direction < 0:
		sprite.scale.x = -1
	elif x_direction > 0:
		sprite.scale.x = 1

func _play_directional_animation(action: String, direction: Vector2) -> String:
	var angle = _get_direction(direction)
	var animation_name = action
	match angle:
		90:
			animation_name += "to"
		45, 135:
			animation_name += "to45"
		0, 180, -180:
			pass
		-45, -135:
			animation_name += "away45"
		-90:
			animation_name += "away"
	
	animation_player.play(animation_name)
	return animation_name
