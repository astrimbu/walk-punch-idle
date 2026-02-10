extends Control

const NUM_SLOTS = 4

@onready var confirm_dialog: ConfirmationDialog = $ConfirmationDialog
var _pending_slot_index: int = 0
var _pending_action: String = ""  # "new" or "delete"

func _ready() -> void:
	refresh_slots()
	if confirm_dialog:
		confirm_dialog.confirmed.connect(_on_confirm_dialog_confirmed)

func refresh_slots() -> void:
	for i in range(1, NUM_SLOTS + 1):
		var summary_label = get_node_or_null("UI/Slot%d/Summary" % i)
		var load_btn = get_node_or_null("UI/Slot%d/Buttons/LoadBtn" % i)
		var new_btn = get_node_or_null("UI/Slot%d/Buttons/NewBtn" % i)
		var delete_btn = get_node_or_null("UI/Slot%d/Buttons/DeleteBtn" % i)
		var has_data = SaveManager.slot_has_data(i)
		var summary_text = _get_slot_summary(i)
		if summary_label:
			summary_label.text = summary_text
		if load_btn:
			load_btn.visible = has_data
			load_btn.disabled = not has_data
		if new_btn:
			new_btn.visible = true
			new_btn.disabled = false
		if delete_btn:
			delete_btn.visible = has_data
			delete_btn.disabled = not has_data

func _get_slot_summary(slot_index: int) -> String:
	var peek = SaveManager.peek_slot_state(slot_index)
	if peek.is_empty():
		return "Slot %d: Empty" % slot_index
	var chars = peek.get("characters", {})
	if chars.is_empty():
		return "Slot %d: Empty" % slot_index
	var parts: Array[String] = []
	for cid in chars:
		var c = chars[cid]
		if c is Dictionary:
			var scene = c.get("current_scene", "")
			var scene_name = "Main" if "Main" in scene else ("Level 2" if "Level2" in scene else "Game")
			parts.append("%s - %s" % [cid, scene_name])
	return "Slot %d: %s" % [slot_index, ", ".join(parts)]

func _on_slot_load(slot_index: int) -> void:
	SaveManager.set_current_slot(slot_index)
	SaveManager.load_game()
	Global.character_select_return_scene = "res://scenes/SaveSlotSelect.tscn"
	get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn")

func _on_slot_new(slot_index: int) -> void:
	if SaveManager.slot_has_data(slot_index):
		_pending_slot_index = slot_index
		_pending_action = "new"
		confirm_dialog.dialog_text = "Overwrite save in slot %d?" % slot_index
		confirm_dialog.popup_centered()
	else:
		_do_new_slot(slot_index)

func _on_slot_delete(slot_index: int) -> void:
	_pending_slot_index = slot_index
	_pending_action = "delete"
	confirm_dialog.dialog_text = "Delete save in slot %d? This cannot be undone." % slot_index
	confirm_dialog.popup_centered()

func _on_confirm_dialog_confirmed() -> void:
	if _pending_action == "new":
		_do_new_slot(_pending_slot_index)
	elif _pending_action == "delete":
		SaveManager.clear_slot(_pending_slot_index)
		refresh_slots()
	_pending_action = ""
	_pending_slot_index = 0

func _do_new_slot(slot_index: int) -> void:
	SaveManager.init_slot_for_new_game(slot_index)
	Global.character_select_return_scene = "res://scenes/SaveSlotSelect.tscn"
	get_tree().change_scene_to_file("res://scenes/CharacterSelect.tscn")

func _on_slot_1_load() -> void:
	_on_slot_load(1)
func _on_slot_1_new() -> void:
	_on_slot_new(1)
func _on_slot_1_delete() -> void:
	_on_slot_delete(1)
func _on_slot_2_load() -> void:
	_on_slot_load(2)
func _on_slot_2_new() -> void:
	_on_slot_new(2)
func _on_slot_2_delete() -> void:
	_on_slot_delete(2)
func _on_slot_3_load() -> void:
	_on_slot_load(3)
func _on_slot_3_new() -> void:
	_on_slot_new(3)
func _on_slot_3_delete() -> void:
	_on_slot_delete(3)
func _on_slot_4_load() -> void:
	_on_slot_load(4)
func _on_slot_4_new() -> void:
	_on_slot_new(4)
func _on_slot_4_delete() -> void:
	_on_slot_delete(4)
