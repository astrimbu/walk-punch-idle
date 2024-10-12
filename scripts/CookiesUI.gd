extends CanvasLayer

@onready var cookies = $Cookies
@onready var x_button = $XButton

func _ready():
	x_button.connect("pressed", _on_x_button_pressed)

func _input(event):
	if visible and event is InputEventMouseButton:
		get_viewport().set_input_as_handled()

func _on_x_button_pressed():
	hide()

func show_ui():
	show()

func hide_ui():
	hide()
