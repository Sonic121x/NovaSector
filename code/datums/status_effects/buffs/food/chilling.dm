///food effect applied by ice cream and frozen treats
/datum/status_effect/food/chilling
	alert_type = /atom/movable/screen/alert/status_effect/icecream_chilling //different path, so we sprite one state and not five.

/datum/status_effect/food/chilling/tick(seconds_between_ticks)
	var/minimum_temp = (BODYTEMP_HEAT_DAMAGE_LIMIT - 12 * strength)
	if(owner.bodytemperature >= minimum_temp)
		owner.adjust_bodytemperature(-2.75 * strength * seconds_between_ticks, min_temp = minimum_temp)

/atom/movable/screen/alert/status_effect/icecream_chilling
	name = "冷静下来"
	desc = "在炎热、等离子体泛滥的日子里，没有什么比得上一杯冰淇淋..."
	use_user_hud_icon = USER_HUD_STYLE_INHERIT
	overlay_state = "food_icecream"

