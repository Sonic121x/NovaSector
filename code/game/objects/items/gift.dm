// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/* Gifts
 * Contains:
 * Gifts
 */

/// Gifts to give to players, will contain a nice toy or other fun item for them to play with.
/obj/item/gift
	name = "gift"
	desc = "PRESENTS!!!! eek!"
	icon = 'icons/obj/storage/wrapping.dmi'
	icon_state = "giftdeliverypackage3"
	inhand_icon_state = "gift"
	resistance_flags = FLAMMABLE

	/// What type of thing are we guaranteed to spawn in with?
	var/obj/item/contains_type = null

/obj/item/gift/Initialize(mapload)
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	icon_state = "giftdeliverypackage[rand(1,5)]"

	if(isnull(contains_type))
		contains_type = get_gift_type()

/obj/item/gift/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.436073089f566200", list(user, src, user.p_them(), user.p_they(), user.p_were()))))
	return BRUTELOSS

/obj/item/gift/examine(mob/user)
	. = ..()
	if(HAS_MIND_TRAIT(user, TRAIT_PRESENT_VISION) || isobserver(user))
		. += span_notice(LANG("obj.eaca0139f8d2f814", list(initial(contains_type.name))))

/obj/item/gift/attack_self(mob/user)
	if(HAS_MIND_TRAIT(user, TRAIT_CANNOT_OPEN_PRESENTS))
		to_chat(user, span_warning(LANG("obj.1e92b2d191abde18", null)))
		return

	moveToNullspace()

	var/obj/item/thing = new contains_type(get_turf(user))

	if (QDELETED(thing)) //might contain something like metal rods that might merge with a stack on the ground
		user.visible_message(span_danger(LANG("obj.45dcd969147112c0", list(user))))
	else
		user.visible_message(span_notice(LANG("obj.e6d1a6be7f1dde02", list(user, src, thing))))
		user.investigate_log("has unwrapped a present containing [thing.type].", INVESTIGATE_PRESENTS)
		user.put_in_hands(thing)
		thing.add_fingerprint(user)
		SEND_SIGNAL(thing, COMSIG_ITEM_OPENED_FROM_GIFT, user)

	qdel(src)

/obj/item/gift/proc/get_gift_type()
	var/static/list/gift_type_list = null

	if(isnull(gift_type_list))
		gift_type_list = list(
			/obj/item/banhammer,
			/obj/item/bikehorn,
			/obj/item/book/manual/chef_recipes,
			/obj/item/book/manual/wiki/barman_recipes,
			/obj/item/clothing/head/costume/snowman,
			/obj/item/clothing/neck/tie/horrible,
			/obj/item/clothing/suit/costume/poncho,
			/obj/item/clothing/suit/costume/poncho/green,
			/obj/item/clothing/suit/costume/poncho/red,
			/obj/item/clothing/suit/costume/snowman,
			/obj/item/clothing/suit/jacket/leather,
			/obj/item/clothing/suit/jacket/leather/biker,
			/obj/item/food/grown/ambrosia/deus,
			/obj/item/food/grown/ambrosia/vulgaris,
			/obj/item/grenade/smokebomb,
			/obj/item/grown/corncob,
			/obj/item/instrument/guitar,
			/obj/item/instrument/violin,
			/obj/item/lipstick/random,
			/obj/item/pai_card,
			/obj/item/pen/invisible,
			/obj/item/pickaxe/diamond,
			/obj/item/poster/random_contraband,
			/obj/item/poster/random_official,
			/obj/item/soap/deluxe,
			/obj/item/sord,
			/obj/item/stack/sheet/mineral/coal,
			/obj/item/storage/backpack/holding,
			/obj/item/storage/belt/champion,
			/obj/item/storage/belt/utility/full,
			/obj/item/storage/box/snappops,
			/obj/item/storage/crayons,
			/obj/item/storage/photo_album,
			/obj/item/storage/wallet,
			/obj/item/toy/basketball,
			/obj/item/toy/beach_ball,
		)

		gift_type_list += subtypesof(/obj/item/clothing/head/collectable)
		//Add all toys, except for abstract types and syndicate cards.
		gift_type_list += subtypesof(/obj/item/toy) - (((typesof(/obj/item/toy/cards) - /obj/item/toy/cards/deck) + /obj/item/toy/figure + /obj/item/toy/ammo))

	var/gift_type = pick(gift_type_list)
	return gift_type

/// Gifts that typically only very OP stuff or admins or Santa Claus himself should be giving out, as they contain ANY valid subtype of `/obj/item`, including stuff like instagib rifles. Wow!
/obj/item/gift/anything
	name = "christmas gift"
	desc = "It could be anything!"
	/// Weak reference to who this gift is for and who can open it, if that's nobody then anyone can
	var/datum/weakref/recipient_ref = null

/obj/item/gift/anything/get_gift_type()
	var/static/list/obj/item/possible_gifts = null

	if(isnull(possible_gifts))
		possible_gifts = get_sane_item_types(/obj/item)

	var/gift_type = pick(possible_gifts)
	return gift_type

/obj/item/gift/anything/attack_self(mob/user)
	if (isnull(recipient_ref))
		return ..()

	var/datum/mind/recipient = recipient_ref.resolve()
	if(recipient && recipient != user?.mind)
		to_chat(user, span_notice(LANG("obj.b0988fa8c831be49", null)))
		return FALSE
	return ..()

/// Assign the mind of someone as the person this gift is for
/obj/item/gift/anything/proc/assign_recipient(datum/mind/recipient)
	if (ismob(recipient)) // You're presumably at this point because you are an admin who fucked up but I will save you
		var/mob/recipient_mob = recipient
		recipient = recipient_mob.mind

	if (isnull(recipient))
		return

	name = "[lang_reverse_text(initial(name))] for [recipient.name] ([recipient.assigned_role.title])"  // NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名 - ORIGINAL: name = "[initial(name)] for [recipient.name] ([recipient.assigned_role.title])"
	recipient_ref = WEAKREF(recipient)
