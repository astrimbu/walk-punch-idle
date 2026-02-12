extends Area2D

@export var portal_id: String
@export var target_scene: String

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	update_visibility()

func update_visibility():
	var is_active = SaveManager.is_portal_active(portal_id)
	visible = is_active
	$CollisionShape2D.set_deferred("disabled", !is_active)

func activate():
	SaveManager.update_portal_state(portal_id, true)
	update_visibility()

func _on_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("change_scene")

func change_scene():
	SceneTransition.transition_to_scene(target_scene)
