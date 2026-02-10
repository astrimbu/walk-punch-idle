extends Node

const SAVE_FILE_PATTERN = "user://save_slot_%d.dat"
const LEGACY_SAVE_FILE = "user://game_save.dat"
const NUM_SLOTS = 4

var slot_state = {
	"global_data": {
		"cookies": {}
	},
	"characters": {},
	"metadata": {
		"last_played_character": "",
		"last_played_time": 0
	}
}

func _get_slot_path(slot_index: int) -> String:
	return SAVE_FILE_PATTERN % slot_index

func _default_character_state() -> Dictionary:
	return {
		"position": {"x": 0.0, "y": 0.0},
		"current_scene": "",
		"quests": {
			"completed": [],
			"active": {}  # quest_id -> current_objective index
		},
		"portals": {}
	}

func _get_current_character_id() -> String:
	return Global.selected_character if Global else "Smiley"

func _ensure_character(character_id: String) -> void:
	if character_id not in slot_state["characters"]:
		slot_state["characters"][character_id] = _default_character_state()

func set_current_slot(slot_index: int) -> void:
	Global.current_slot_index = clampi(slot_index, 1, NUM_SLOTS)

func load_game() -> void:
	var slot_index = Global.current_slot_index if Global else 1
	var path = _get_slot_path(slot_index)
	# Optional migration: if slot 1 and no slot file, try legacy file
	if slot_index == 1 and not FileAccess.file_exists(path) and FileAccess.file_exists(LEGACY_SAVE_FILE):
		_migrate_legacy_save()
		return
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var data = file.get_var()
			file.close()
			if data is Dictionary:
				slot_state = _normalize_loaded_state(data)
				return
	slot_state = {
		"global_data": {"cookies": {}},
		"characters": {},
		"metadata": {"last_played_character": "", "last_played_time": 0}
	}

func _normalize_loaded_state(data: Dictionary) -> Dictionary:
	var normalized = {
		"global_data": data.get("global_data", {"cookies": {}}),
		"characters": {},
		"metadata": data.get("metadata", {"last_played_character": "", "last_played_time": 0})
	}
	var raw_chars = data.get("characters", {})
	for cid in raw_chars:
		var c = raw_chars[cid]
		if c is Dictionary:
			var def = _default_character_state()
			normalized["characters"][cid] = {
				"position": c.get("position", def["position"]),
				"current_scene": c.get("current_scene", ""),
				"quests": c.get("quests", def["quests"]),
				"portals": c.get("portals", def["portals"])
			}
	return normalized

func _migrate_legacy_save() -> void:
	var file = FileAccess.open(LEGACY_SAVE_FILE, FileAccess.READ)
	if not file:
		load_game()
		return
	var old = file.get_var()
	file.close()
	if old is Dictionary:
		slot_state = {
			"global_data": {"cookies": old.get("cookies", {})},
			"characters": {},
			"metadata": {"last_played_character": "Smiley", "last_played_time": 0}
		}
		var q = old.get("quests", {})
		var completed = q.get("completed", []) if q is Dictionary else []
		var active_list = q.get("active", []) if q is Dictionary else []
		var active_dict = {}
		for quest_id in active_list:
			active_dict[quest_id] = 0
		var player = old.get("player", _default_character_state()["position"])
		var pos = player.get("position", {"x": 0.0, "y": 0.0}) if player is Dictionary else {"x": 0.0, "y": 0.0}
		var scene = player.get("current_scene", "") if player is Dictionary else ""
		var portals = old.get("portals", {})
		slot_state["characters"]["Smiley"] = {
			"position": pos,
			"current_scene": scene,
			"quests": {"completed": completed, "active": active_dict},
			"portals": portals
		}
		save_game()
		# Optionally remove legacy file
		DirAccess.remove_absolute(LEGACY_SAVE_FILE)
	else:
		load_game()

func save_game() -> void:
	var slot_index = Global.current_slot_index if Global else 1
	var path = _get_slot_path(slot_index)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_var(slot_state)
		file.close()

func slot_has_data(slot_index: int) -> bool:
	var path = _get_slot_path(slot_index)
	if not FileAccess.file_exists(path):
		return false
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return false
	var data = file.get_var()
	file.close()
	if data is Dictionary:
		var chars = data.get("characters", {})
		return chars.size() > 0 or not data.get("global_data", {}).get("cookies", {}).is_empty()
	return false

func peek_slot_state(slot_index: int) -> Dictionary:
	var path = _get_slot_path(slot_index)
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var data = file.get_var()
	file.close()
	if data is Dictionary:
		return {
			"characters": data.get("characters", {}),
			"metadata": data.get("metadata", {})
		}
	return {}

func clear_slot(slot_index: int) -> void:
	var path = _get_slot_path(slot_index)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
	slot_state = {
		"global_data": {"cookies": {}},
		"characters": {},
		"metadata": {"last_played_character": "", "last_played_time": 0}
	}

func init_slot_for_new_game(slot_index: int) -> void:
	set_current_slot(slot_index)
	slot_state = {
		"global_data": {"cookies": {}},
		"characters": {},
		"metadata": {"last_played_character": "", "last_played_time": 0}
	}
	save_game()

# ---- Character-scoped API (use Global.selected_character) ----

func get_player_state() -> Dictionary:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	return slot_state["characters"][cid]

func update_player_state(position: Vector2, current_scene: String) -> void:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	slot_state["characters"][cid]["position"] = {"x": position.x, "y": position.y}
	slot_state["characters"][cid]["current_scene"] = current_scene
	slot_state["metadata"]["last_played_character"] = cid
	slot_state["metadata"]["last_played_time"] = int(Time.get_unix_time_from_system())
	save_game()

func update_quest_state(quest_id: String, completed: bool, objective_index: int = 0) -> void:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	var quests = slot_state["characters"][cid]["quests"]
	if completed:
		if quest_id not in quests["completed"]:
			quests["completed"].append(quest_id)
		quests["active"].erase(quest_id)
	else:
		quests["active"][quest_id] = objective_index
	save_game()

func update_quest_active_objective(quest_id: String, objective_index: int) -> void:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	slot_state["characters"][cid]["quests"]["active"][quest_id] = objective_index
	save_game()

func get_character_quest_state() -> Dictionary:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	return slot_state["characters"][cid]["quests"].duplicate(true)

func is_quest_completed(quest_id: String) -> bool:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	return quest_id in slot_state["characters"][cid]["quests"]["completed"]

func update_portal_state(portal_id: String, is_active: bool) -> void:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	slot_state["characters"][cid]["portals"][portal_id] = is_active
	save_game()

func is_portal_active(portal_id: String) -> bool:
	var cid = _get_current_character_id()
	_ensure_character(cid)
	return slot_state["characters"][cid]["portals"].get(portal_id, false)

# ---- Global (per-slot) API ----

func get_cookies_state() -> Dictionary:
	return slot_state["global_data"].get("cookies", {})

func update_cookies_state(cookies_data: Dictionary) -> void:
	slot_state["global_data"]["cookies"] = cookies_data
	save_game()
