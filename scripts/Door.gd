extends StaticBody2D

var is_open = false
var is_locked = true

@onready var closed_sprite = $Closed
@onready var collision_shape = $CollisionShape2D

func open():
	if not is_open and not is_locked:
		is_open = true
		collision_shape.disabled = true
		closed_sprite.hide()

func close():
	if is_open and not is_locked:
		is_open = false
		collision_shape.disabled = false
		closed_sprite.show()

func unlock():
	is_locked = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_locked:
			if is_open:
				close()
			else:
				open()
		get_viewport().set_input_as_handled()

func _mouse_enter():
	if not is_locked:
		modulate = Color(1.2, 1.2, 1.2)

func _mouse_exit():
	modulate = Color(1, 1, 1)
