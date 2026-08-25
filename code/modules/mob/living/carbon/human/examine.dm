// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Collects information displayed about src when examined by a user with a medical HUD.
/mob/living/carbon/human/get_medhud_examine_info(mob/living/user, datum/record/crew/target_record)
	. = ..()

	if(istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/undershirt = w_uniform
		var/sensor_text = undershirt.get_sensor_text()
		if(sensor_text)
			. += LANG("mob.baa481b48e9f2319", list(sensor_text))
