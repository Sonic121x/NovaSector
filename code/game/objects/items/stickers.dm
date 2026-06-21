#define MAX_STICKER_COUNT 15

/**
 * What stickers can do?
 *
 * - They can be attached to any object.
 * - They inherit cursor position when attached.
 * - They are unclickable by mouse, I suppose?
 * - They can be washed off.
 * - They can be burnt off.
 * - They can be attached to the object they collided with.
 * - They play "attack" animation when attached.
 *
 */

/obj/item/sticker
	name = "贴纸"
	desc = "一张背面带有强力粘合剂的贴纸，可以粘在各种东西上！"

	icon = 'icons/obj/toys/stickers.dmi'

	max_integrity = 50
	resistance_flags = FLAMMABLE

	throw_range = 3
	pressure_resistance = 0

	item_flags = NOBLUDGEON
	w_class = WEIGHT_CLASS_TINY

	/// `list` or `null`, contains possible alternate `icon_states`.
	var/list/icon_states
	/// This sticker won't be generated inside random sticker packs.
	var/exclude_from_random = FALSE
	/// Text added to the atom's examine when stickered.
	var/examine_text

/obj/item/sticker/Initialize(mapload)
	. = ..()

	if(length(icon_states))
		icon_state = pick(icon_states)

/obj/item/sticker/Bump(atom/bumped_atom)
	if(prob(50) && attempt_attach(bumped_atom))
		bumped_atom.balloon_alert_to_viewers("sticker landed on sticky side!")

/obj/item/sticker/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isatom(interacting_with))
		return NONE

	var/cursor_x = text2num(LAZYACCESS(modifiers, ICON_X))
	var/cursor_y = text2num(LAZYACCESS(modifiers, ICON_Y))

	if(isnull(cursor_x) || isnull(cursor_y))
		return NONE

	if(attempt_attach(interacting_with, user, cursor_x, cursor_y))
		return ITEM_INTERACT_SUCCESS

	return NONE

/**
 * Attempts to attach sticker to an object. Returns `FALSE` if atom has more than
 * `MAX_STICKER_COUNT` stickers, `TRUE` otherwise. If no `px` or `py` were passed
 * picks random coordinates based on a `target`'s icon.
 */
/obj/item/sticker/proc/attempt_attach(atom/target, mob/user, px, py)
	if(COUNT_TRAIT_SOURCES(target, TRAIT_STICKERED) >= MAX_STICKER_COUNT)
		balloon_alert_to_viewers("sticker won't stick!")
		return FALSE

	if(isnull(px) || isnull(py))
		var/icon/target_mask = icon(target.icon, target.icon_state)

		if(isnull(px))
			px = rand(1, target_mask.Width())

		if(isnull(py))
			py = rand(1, target_mask.Height())

	if(!isnull(user))
		user.do_attack_animation(target, used_item = src)
		target.balloon_alert(user, "贴纸已粘贴")
		var/mob/living/victim = target
		if(istype(victim) && !isnull(victim.client))
			user.log_message("stuck [src] to [key_name(victim)]", LOG_ATTACK)
			victim.log_message("had [src] stuck to them by [key_name(user)]", LOG_ATTACK)

	target.AddComponent(/datum/component/sticker, src, get_dir(target, src), px, py, null, null, examine_text)
	return TRUE

#undef MAX_STICKER_COUNT

/obj/item/sticker/smile
	name = "笑脸贴纸"
	icon_state = "smile"

/obj/item/sticker/frown
	name = "哭脸贴纸"
	icon_state = "frown"

/obj/item/sticker/left_arrow
	name = "左箭头贴纸"
	icon_state = "arrow-left"

/obj/item/sticker/right_arrow
	name = "右箭头贴纸"
	icon_state = "arrow-right"

/obj/item/sticker/star
	name = "星星贴纸"
	icon_state = "star"

/obj/item/sticker/heart
	name = "爱心贴纸"
	icon_state = "heart"

/obj/item/sticker/googly
	name = "咕噜眼贴纸"
	icon_state = "googly"
	icon_states = list("googly", "googly-alt")

/obj/item/sticker/rev
	name = "蓝色R贴纸"
	desc = "一张FUCK THE SYSTEM的贴纸，他们是银河系顶级的硬核朋克乐队。"
	icon_state = "revhead"
	examine_text = "There is a sticker displaying <b>FUCK THE SYSTEM</b>, the galaxy's premiere hardcore punk band."

/obj/item/sticker/pslime
	name = "史莱姆毛绒玩具贴纸"
	icon_state = "pslime"

/obj/item/sticker/pliz
	name = "蜥蜴毛绒玩具贴纸"
	icon_state = "plizard"

/obj/item/sticker/pbee
	name = "蜜蜂毛绒玩具贴纸"
	icon_state = "pbee"

/obj/item/sticker/psnake
	name = "蛇毛绒玩具贴纸"
	icon_state = "psnake"

/obj/item/sticker/robot
	name = "机器人贴纸"
	icon_state = "tile"
	icon_states = list("tile", "medbot", "clean")

/obj/item/sticker/toolbox
	name = "工具箱贴纸"
	icon_state = "soul"

/obj/item/sticker/chief_engineer
	name = "CE认证贴纸"
	icon_state = "ce_approved"
	exclude_from_random = TRUE
	examine_text = "There is a sticker displaying the <b>Chief Engineer's SEAL OF APPROVAL.</b>"

/obj/item/sticker/clown
	name = "小丑贴纸"
	icon_state = "honkman"

/obj/item/sticker/mime
	name = "默剧演员贴纸"
	icon_state = "silentman"

/obj/item/sticker/assistant
	name = "助理贴纸"
	icon_state = "tider"

/obj/item/sticker/skub
	name = "史卡布贴纸"
	icon_state = "skub"
	examine_text = "There is a sticker displaying <b>Skubtide, Stationwide!</b>"

/obj/item/sticker/anti_skub
	name = "反史卡布贴纸"
	icon_state = "anti_skub"
	examine_text = "There is an <b>anti-skub</b> sticker."

/obj/item/sticker/syndicate
	name = "辛迪加贴纸"
	icon_state = "synd"
	exclude_from_random = TRUE

/obj/item/sticker/syndicate/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/sticker/syndicate/c4
	name = "C-4贴纸"
	icon_state = "c4"

/obj/item/sticker/syndicate/bomb
	name = "辛迪加炸弹贴纸"
	icon_state = "sbomb"

/obj/item/sticker/syndicate/apc
	name = "损坏的APC贴纸"
	icon_state = "milf"

/obj/item/sticker/syndicate/larva
	name = "幼虫贴纸"
	icon_state = "larva"

/obj/item/sticker/syndicate/cult
	name = "血纸贴纸"
	icon_state = "cult"

/obj/item/sticker/syndicate/flash
	name = "闪光贴纸"
	icon_state = "flash"

/obj/item/sticker/syndicate/op
	name = "特工贴纸"
	icon_state = "newcop"

/obj/item/sticker/syndicate/trap
	name = "捕熊夹贴纸"
	icon_state = "trap"

/obj/item/sticker/purity_seal
	name = "纯洁印记"
	icon_state = "purity_seal_1"
	desc =  "Looking closer, you realize it's actually a mass produced sticker. You suppose it's the holiness that counts."

/obj/item/sticker/purity_seal/purity_seal_2
	icon_state = "purity_seal_2"

