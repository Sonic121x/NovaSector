// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/**
 * Scrambles the languages of someone you shoot.
 */
/obj/item/gun/magic/wand/babel
	name = "rod of babel"
	desc = "The incredible power of this wand causes victims to forget all of the languages they know, and learn a new one."
	school = SCHOOL_TRANSMUTATION
	ammo_type = /obj/item/ammo_casing/magic/babel
	icon_state = "babelwand"
	base_icon_state = "babelwand"
	fire_sound = 'sound/effects/magic/staff_change.ogg'
	max_charges = 6

/obj/item/gun/magic/wand/babel/zap_self(mob/living/user, suicide = FALSE)
	. = ..()
	charges--
	if (HAS_TRAIT(user, TRAIT_TOWER_OF_BABEL))
		return
	curse_of_babel(user)

/obj/item/gun/magic/wand/babel/do_suicide(mob/living/user)
	. = ..()
	user.say(LANG("obj.7d8048b9f884daee", null), forced = "failed babel wand suicide")
	return SHAME
