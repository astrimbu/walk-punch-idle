extends Node2D

func _input(_event):
	pass

func _ready():
	var portal = get_node("PortalToLevel2")
	if portal:
		portal.update_visibility()
