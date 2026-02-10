extends Node

var selected_character = "Smiley"  # Default character
var current_slot_index: int = 1  # 1-4, which save slot is active
## When opening Character Select, set this so Escape can return the player to the right place.
var character_select_return_scene: String = "res://scenes/SaveSlotSelect.tscn"
