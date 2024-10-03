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
	if event is InputEventKey and current_state != "punch":
		change_state("punch")
	
	if event is InputEventMouseButton:
		# click
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			mouse_held = true
			change_state("walk")
			target = get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_held = false
			if current_state == "walk":
				change_state("idle")
		# zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_camera(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_camera(zoom_speed)

func _physics_process(_delta):
	match current_state:
		"idle":
			character_animations.play_idle_animation(last_direction)
		"walk":
			if mouse_held:
				target = get_global_mouse_position()
			var direction = (target - global_position).normalized()
			last_direction = direction
			velocity = direction * speed
			character_animations.play_walk_animation(direction)
			move_and_slide()
			for i in get_slide_collision_count():
				var _collision = get_slide_collision(i)
				if !mouse_held:
					change_state("idle")
			if global_position.distance_to(target) < 5 and not mouse_held:
				change_state("idle")
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
