extends Control

var cookies = 0
var clicker_level = 0
var cps = 1
var upgrade_cost = 10

# Called when the timer ticks (every second)
func _on_AutoClickerTimer_timeout():
	cookies += cps
	update_ui()

# Called when the upgrade button is pressed
func _on_UpgradeButton_pressed():
	if cookies >= upgrade_cost:
		cookies -= upgrade_cost
		clicker_level += 1
		cps += 1
		upgrade_cost = int(upgrade_cost * 1.5)
		update_ui()

# Update the UI elements
func update_ui():
	$CookieCounter.text = "Cookies: %s" % cookies
	$ClickerStatus.text = "CPS: %s | Clicker Level: %s" % [cps, clicker_level]
	$UpgradeButton.text = "Upgrade Clicker: %s Cookies" % upgrade_cost


func _on_auto_clicker_timer_timeout() -> void:
	pass # Replace with function body.
