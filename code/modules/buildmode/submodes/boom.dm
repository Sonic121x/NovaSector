// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define BOOM_DEVASTATION "devastation"
#define BOOM_HEAVY "heavy"
#define BOOM_LIGHT "light"
#define BOOM_FLASH "flash"
#define BOOM_FLAMES "flames"

/datum/buildmode_mode/boom
	key = "boom"

	var/list/explosions = list(
		BOOM_DEVASTATION = 0,
		BOOM_HEAVY = 0,
		BOOM_LIGHT = 0,
		BOOM_FLASH = 0,
		BOOM_FLAMES = 0,
	)

/datum/buildmode_mode/boom/show_help(client/builder)
	to_chat(builder, span_purple(boxed_message(
		LANG("datum.1774e16547d6f0cf", list(span_bold("Set explosion destructiveness"), span_bold("Kaboom"), span_warning("NOTE:")))))
	)

/datum/buildmode_mode/boom/change_settings(client/c)
	for (var/explosion_level in explosions)
		explosions[explosion_level] = input(c, LANG("datum.593032cd51bcdef1", list(explosion_level)), LANG("datum.8c7e56a24e9ebe25", null)) as num|null
		if(explosions[explosion_level] == null || explosions[explosion_level] < 0)
			explosions[explosion_level] = 0

/datum/buildmode_mode/boom/handle_click(client/c, params, obj/object)
	var/list/modifiers = params2list(params)

	var/value_valid = FALSE
	for (var/explosion_type in explosions)
		if (explosions[explosion_type] > 0)
			value_valid = TRUE
			break
	if (!value_valid)
		return

	if(LAZYACCESS(modifiers, LEFT_CLICK))
		log_admin("Build Mode: [key_name(c)] caused an explosion(dev=[explosions[BOOM_DEVASTATION]], hvy=[explosions[BOOM_HEAVY]], lgt=[explosions[BOOM_LIGHT]], flash=[explosions[BOOM_FLASH]], flames=[explosions[BOOM_FLAMES]]) at [AREACOORD(object)]")
		explosion(object, explosions[BOOM_DEVASTATION], explosions[BOOM_HEAVY], explosions[BOOM_LIGHT], explosions[BOOM_FLASH], explosions[BOOM_FLAMES], adminlog = FALSE, ignorecap = TRUE)

#undef BOOM_DEVASTATION
#undef BOOM_HEAVY
#undef BOOM_LIGHT
#undef BOOM_FLASH
#undef BOOM_FLAMES
