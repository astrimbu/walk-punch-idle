extends Node

var _canvas_layer: CanvasLayer
var _overlay: ColorRect

func _ready():
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 100
	add_child(_canvas_layer)

	_overlay = ColorRect.new()
	_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_overlay.offset_left = 0
	_overlay.offset_top = 0
	_overlay.offset_right = 0
	_overlay.offset_bottom = 0
	_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_overlay.color = Color(0, 0, 0, 0)
	_canvas_layer.add_child(_overlay)

	_canvas_layer.visible = false

func transition_to_scene(path: String):
	_overlay.color = Color(0, 0, 0, 0)
	_canvas_layer.visible = true
	var t = create_tween()
	t.tween_property(_overlay, "color", Color(0, 0, 0, 1), 0.25).set_ease(Tween.EASE_IN)
	t.finished.connect(_on_fade_out_finished.bind(path))

func _on_fade_out_finished(path: String):
	get_tree().change_scene_to_file(path)
	call_deferred("_fade_in")

func _fade_in():
	var t = create_tween()
	t.tween_property(_overlay, "color", Color(0, 0, 0, 0), 0.2).set_ease(Tween.EASE_OUT)
	t.finished.connect(_on_fade_in_finished)

func _on_fade_in_finished():
	_canvas_layer.visible = false
