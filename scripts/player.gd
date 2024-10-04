extends CharacterBody2D

@export var speed := 64
@onready var camera := $Camera2D

var target : Vector2
var mouse_held = false
var last_direction : Vector2 = Vector2.ZERO

var character_animations: BaseCharacterAnimations
var current_state: String = "idle"

var zoom_speed = 0.05
var min_zoom = 0.5
var max_zoom = 2.0

var target_indicator: Node2D

# draw indicator under the player
var TargetIndicator = preload("res://scenes/TargetIndicator.tscn")
const TARGET_INDICATOR_LAYER = 0

func _ready():
	match Global.selected_character:
		"Robot":
			character_animations = RobotAnimations.new(self)
		"Smiley":
			character_animations = SmileyAnimations.new(self)
		"Farmer":
			character_animations = FarmerAnimations.new(self)
	
	character_animations.show_sprite()
	character_animations.connect("animation_finished", Callable(self, "_on_animation_finished"))
	add_to_group("player")

func _input(event):
	if event is InputEventKey and current_state != "punch" and not DialogueSystem.is_dialogue_active():
		change_state("punch")
	
	if event is InputEventMouseButton:
		# click
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var clicked_object = get_clicked_object()
			if clicked_object and clicked_object.is_in_group("npc"):
				return
			change_state("walk")
			target = get_global_mouse_position()
			show_target_indicator(target)
		# zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

func get_clicked_object():
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collision_mask = 4
	var result = space.intersect_point(query)
	if result:
		return result[0].collider
	return null

func _physics_process(_delta):
	match current_state:
		"idle":
			character_animations.play_idle_animation(last_direction)
		"walk":
			var direction = (target - global_position).normalized()
			last_direction = direction
			velocity = direction * speed
			character_animations.play_walk_animation(direction)
			move_and_slide()
			for i in get_slide_collision_count():
				var _collision = get_slide_collision(i)
				change_state("idle")
				remove_target_indicator()
			if global_position.distance_to(target) < 5:
				change_state("idle")
				remove_target_indicator()
		"punch":
			character_animations.play_punch_animation(last_direction)

func _on_animation_finished(anim_name: String):
	if anim_name.begins_with("punch") and current_state == "punch":
		change_state("idle")

func change_state(new_state: String):
	match new_state:
		"idle":
			current_state = "idle"
			velocity = Vector2.ZERO
		"walk":
			current_state = "walk"
		"punch":
			current_state = "punch"
			velocity = Vector2.ZERO

func zoom_camera(zoom_factor):
	var new_zoom = camera.zoom.x - zoom_factor
	new_zoom = clamp(new_zoom, min_zoom, max_zoom)
	camera.zoom = Vector2(new_zoom, new_zoom)

func show_target_indicator(pos: Vector2):
	remove_target_indicator()  # Remove any existing indicator
	target_indicator = TargetIndicator.instantiate()
	target_indicator.global_position = pos
	target_indicator.z_index = TARGET_INDICATOR_LAYER
	get_parent().add_child(target_indicator)

func remove_target_indicator():
	if target_indicator:
		target_indicator.queue_free()
		target_indicator = null
