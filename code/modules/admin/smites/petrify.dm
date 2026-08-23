// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Turn pur target to stone, forever
/datum/smite/petrify
	name = "Petrify"

/datum/smite/petrify/effect(client/user, mob/living/target)
	. = ..()

	if(!ishuman(target))
		to_chat(user, span_warning(LANG("datum.34cdb548b229379a", null)), confidential = TRUE)
		return
	var/mob/living/carbon/human/human_target = target
	human_target.petrify(statue_timer = INFINITY, save_brain = FALSE)

/datum/smite/petrify/divine
	name = "Petrify (Divine)"
	smite_flags = SMITE_DIVINE|SMITE_DELAY|SMITE_STUN
