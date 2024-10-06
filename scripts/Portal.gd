extends Area2D

@export var target_scene: String
@export var is_active: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	update_visibility()

func update_visibility():
	visible = is_active
	$CollisionShape2D.set_deferred("disabled", !is_active)

func activate():
	is_active = true
	update_visibility()

func _on_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(target_scene)
