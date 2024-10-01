extends Node

@onready var ap = $AnimationPlayer
@onready var ap2 = $AnimationPlayer2

func _ready() -> void:
	ap.play("idleto")
	ap2.play("rotate")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	# player is near WelcomeBot
	# display dialogue or quest interaction
	pass # Replace with function body.
