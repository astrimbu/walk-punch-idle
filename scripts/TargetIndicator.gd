extends Node2D

var _pop_tween: Tween

func _ready():
	scale = Vector2(0.3, 0.3)
	_pop_tween = create_tween()
	_pop_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func dismiss():
	if _pop_tween and _pop_tween.is_valid():
		_pop_tween.kill()
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(0.0, 0.0), 0.08).set_ease(Tween.EASE_IN)
	t.finished.connect(queue_free)
