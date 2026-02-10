extends Node2D

func _ready():
	scale = Vector2(0.3, 0.3)
	var t = create_tween()
	t.tween_property(self, "scale", Vector2(1.0, 1.0), 0.12).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
