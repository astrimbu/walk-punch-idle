extends Node

signal interact

func trigger_interact():
	emit_signal("interact")
