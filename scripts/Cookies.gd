extends Control

const INITIAL_PROGRESS_THRESHOLD: float = 50.0
const PROGRESS_MULTIPLIER: float = 2.0

const PROGRESS_THRESHOLDS: Array[float] = [
	50.0,    # Level 0
	200.0,   # Level 1
	1000.0,  # Level 2
]

@onready var cookie_counter = $CookieCounter
@onready var clicker_status = $ClickerStatus
@onready var progress_bar = $ProgressBar
@onready var progress_level_label = $ProgressLevel
@onready var upgrade_buttons = [
	$UpgradeButton,
	$UpgradeButton2,
	$UpgradeButton3,
	$UpgradeButton4
]
@onready var test_reset_button = $TestReset

const DEFAULT_UPGRADE_COSTS: Array[float] = [1.0, 10.0, 10.0, 1000.0]

var cookies: float = 0.0
var clicker_level: int = 0
var cps: float = 1.0

var upgrade_levels: Array = [0, 0, 0, 0]
var upgrade_costs: Array[float] = DEFAULT_UPGRADE_COSTS.duplicate()
var upgrade_multipliers: Array = [1.15, 1.25, 1.35, 1.5]
var progress: float = 0
var progress_level: int = 0
var reset_count: int = 0

var displayed_cookies: float = 0.0
var displayed_cps: float = 1.0

func _ready() -> void:
	test_reset_button.connect("pressed", _on_TestReset_pressed)
	load_game()
	update_ui()
	update_upgrade_buttons()
	set_process(true)  # Enable _process

func _process(delta: float) -> void:
	update_display(delta)

func _on_AutoClickerTimer_timeout() -> void:
	cookies += cps
	progress += cps
	update_ui()
	update_upgrade_buttons()
	check_progress()
	save_game()

func _on_UpgradeButton_pressed() -> void:
	upgrade(0)

func _on_UpgradeButton2_pressed() -> void:
	upgrade(1)

func _on_UpgradeButton3_pressed() -> void:
	upgrade(2)

func _on_UpgradeButton4_pressed() -> void:
	upgrade(3)

func upgrade(index: int) -> void:
	if cookies >= upgrade_costs[index]:
		cookies -= upgrade_costs[index]
		upgrade_levels[index] += 1
		
		match index:
			0: # +1 CPS
				cps += 1
			1: # +5% CPS
				cps *= 1.05
			2: # -10% upgrade costs
				for i in range(upgrade_costs.size()):
					upgrade_costs[i] *= 0.9
			3: # Reset all upgrades, 3x previous base CPS
				reset_count += 1
				cps = pow(3, reset_count)
				upgrade_levels = [0, 0, 0, 1]
				reset_upgrade_costs()
				reset_progress_level()
		
		# Apply the specific multiplier for this upgrade
		upgrade_costs[index] *= upgrade_multipliers[index]
		update_ui()
		update_upgrade_buttons()
		save_game()

func update_ui() -> void:
	if progress_level < PROGRESS_THRESHOLDS.size():
		progress_bar.max_value = PROGRESS_THRESHOLDS[progress_level]
		var progress_percentage = min((progress / PROGRESS_THRESHOLDS[progress_level]) * 100, 100)
		progress_bar.value = progress
	else:
		progress_bar.max_value = 100
		progress_bar.value = 100

	progress_level_label.text = "Lvl: %d" % progress_level
	update_upgrade_buttons()

func all_upgrades_unlocked() -> bool:
	return cookies >= upgrade_costs.max()

func update_upgrade_buttons() -> void:
	var upgrade_labels = [
		"+1 CPS",
		"+5% CPS",
		"-10% Costs",
		"Reset (3x CPS)"
	]
	
	for i in range(upgrade_buttons.size()):
		var button = upgrade_buttons[i]
		button.text = "%s: %s Cookies" % [upgrade_labels[i], format_large_number(upgrade_costs[i])]
		button.disabled = cookies < upgrade_costs[i]
		button.visible = i <= progress_level

func check_progress() -> void:
	if progress_level < PROGRESS_THRESHOLDS.size() and progress >= PROGRESS_THRESHOLDS[progress_level]:
		progress = 0
		progress_level += 1
		if progress_level < PROGRESS_THRESHOLDS.size():
			unlock_next_upgrade()

func unlock_next_upgrade() -> void:
	if progress_level < upgrade_buttons.size():
		upgrade_buttons[progress_level].visible = true

func reset_upgrade_costs() -> void:
	upgrade_costs = DEFAULT_UPGRADE_COSTS.duplicate()

func reset_progress_level() -> void:
	progress_level = 0
	progress = 0

func save_game() -> void:
	var save_data = {
		"cookies": cookies,
		"cps": cps,
		"upgrade_levels": upgrade_levels,
		"upgrade_costs": upgrade_costs,
		"upgrade_multipliers": upgrade_multipliers,
		"progress": progress,
		"progress_level": progress_level,
		"reset_count": reset_count
	}
	var file = FileAccess.open("user://cookie_save.dat", FileAccess.WRITE)
	file.store_var(save_data)
	file.close()

func load_game() -> void:
	if FileAccess.file_exists("user://cookie_save.dat"):
		var file = FileAccess.open("user://cookie_save.dat", FileAccess.READ)
		var save_data = file.get_var()
		file.close()
		
		cookies = save_data.get("cookies", 0.0)
		cps = save_data.get("cps", 1.0)
		upgrade_levels = save_data.get("upgrade_levels", [0, 0, 0, 0])
		upgrade_costs = save_data.get("upgrade_costs", DEFAULT_UPGRADE_COSTS.duplicate())
		upgrade_multipliers = save_data.get("upgrade_multipliers", [1.15, 1.25, 1.35, 1.5])
		progress = save_data.get("progress", 0.0)
		progress_level = save_data.get("progress_level", 0)
		reset_count = save_data.get("reset_count", 0)

func _on_TestReset_pressed() -> void:
	reset_game()
	save_game()
	update_ui()
	update_upgrade_buttons()

func reset_game() -> void:
	cookies = 0
	cps = 1
	upgrade_levels = [0, 0, 0, 0]
	upgrade_costs = DEFAULT_UPGRADE_COSTS.duplicate()
	reset_progress_level()
	reset_count = 0  # Reset the reset_count

func format_large_number(number: float) -> String:
	if number < 1_000_000:
		return str(int(number))
	elif number < 1e9:
		return "%.2fM" % (number / 1e6)
	elif number < 1e12:
		return "%.2fB" % (number / 1e9)
	elif number < 1e15:
		return "%.2fT" % (number / 1e12)
	elif number < 1e18:
		return "%.2fQ" % (number / 1e15)
	elif number < 1e21:
		return "%.2fQQ" % (number / 1e18)
	else:
		var exponent = floor(log(number) / log(10))
		var mantissa = number / pow(10, exponent)
		return "%.2fE%d" % [mantissa, exponent]

func update_display(delta: float) -> void:
	# Interpolate displayed values
	displayed_cookies = lerp(displayed_cookies, cookies, delta)
	displayed_cps = lerp(displayed_cps, cps, delta)
	
	# Update UI with interpolated values
	cookie_counter.text = "Cookies: %s" % format_large_number(displayed_cookies)
	clicker_status.text = "CPS: %s | Resets: %d" % [format_large_number(displayed_cps), reset_count]
