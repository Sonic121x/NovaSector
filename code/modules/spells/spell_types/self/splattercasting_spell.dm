// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/splattercasting
	name = "Marrabbio's Splattercasting"
	desc = "A spell invented by a banished wizard, who obsessed over aligning \
		the primal essences of life and magic into one. Dramatically lowers the \
		cooldown on all spells, but each one will cost blood, as well as it naturally \
		draining from you. You can replenish it from your victims."
	button_icon_state = "splattercasting"

	school = SCHOOL_SANGUINE
	cooldown_time = 1 SECONDS

	invocation = "THE STARS ALIGN! THE COSMOS BLEEDS!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC|SPELL_REQUIRES_STATION|SPELL_REQUIRES_MIND
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY
	spell_max_level = 1

/datum/action/cooldown/spell/splattercasting/cast(mob/living/cast_on)
	. = ..()

	to_chat(cast_on, span_green(LANG("datum.321122bf832df121", null)))
	if(!do_after(cast_on, 5 SECONDS))
		to_chat(cast_on, span_warning(LANG("datum.5ae22f28959da728", null)))
		return

	playsound(cast_on, 'sound/effects/pope_entry.ogg', 100)
	to_chat(cast_on, span_danger(LANG("datum.72a7dffb0cca7b4d", null)))

	cast_on.set_species(/datum/species/human/vampire)
	cast_on.set_blood_volume(BLOOD_VOLUME_NORMAL) ///for predictable blood total amounts when the spell is first cast.

	cast_on.AddComponent(/datum/component/splattercasting)

	if(ishuman(cast_on))
		var/mob/living/carbon/human/human_cast_on = cast_on
		human_cast_on.dropItemToGround(human_cast_on.w_uniform)
		human_cast_on.dropItemToGround(human_cast_on.wear_suit)
		human_cast_on.dropItemToGround(human_cast_on.head)
		human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/suit/wizrobe/red(human_cast_on), ITEM_SLOT_OCLOTHING)
		human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/head/wizard/red(human_cast_on), ITEM_SLOT_HEAD)
		human_cast_on.equip_to_slot_or_del(new /obj/item/clothing/under/color/red(human_cast_on), ITEM_SLOT_ICLOTHING)

	qdel(src)
