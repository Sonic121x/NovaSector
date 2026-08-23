// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
//These objects are used in the cardinal sin-themed ruins (i.e. Gluttony, Pride...)

/obj/effect/gluttony //Gluttony's wall: Used in the Gluttony ruin. Only lets the overweight through.
	name = "gluttony's wall"
	desc = "Only those who truly indulge may pass."
	anchored = TRUE
	density = TRUE
	icon_state = "blob"
	icon = 'icons/mob/nonhuman-player/blob.dmi'
	color = rgb(145, 150, 0)

/obj/effect/gluttony/CanAllowThrough(atom/movable/mover, border_dir)//So bullets will fly over and stuff.
	. = ..()
	if(ishuman(mover))
		var/mob/living/carbon/human/H = mover
		if(H.nutrition >= NUTRITION_LEVEL_FAT)
			H.visible_message(span_warning(LANG("obj.be923758f3ad7c0a", list(H, src))), span_notice(LANG("obj.886b200703a936aa", null)))
			return TRUE
		else
			to_chat(H, span_warning(LANG("obj.e9dc8df9d1563fb5", list(src))))
	if(istype(mover, /mob/living/basic/morph))
		return TRUE

//can't be bothered to do sloth right now, will make later

/obj/item/knife/envy //Envy's knife: Found in the Envy ruin. Attackers take on the appearance of whoever they strike.
	name = "envy's knife"
	desc = "Their success will be yours."
	icon = 'icons/obj/weapons/stabby.dmi'
	icon_state = "envyknife"
	inhand_icon_state = "envyknife"
	lefthand_file = 'icons/mob/inhands/equipment/kitchen_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/kitchen_righthand.dmi'
	force = 18
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	custom_materials = list(/datum/material/bone=SMALL_MATERIAL_AMOUNT)
	hitsound = 'sound/items/weapons/bladeslice.ogg'

/obj/item/knife/envy/afterattack(atom/target, mob/living/carbon/human/user, list/modifiers, list/attack_modifiers)
	if(!istype(user) || !ishuman(target) || QDELETED(target))
		return

	var/mob/living/carbon/human/H = target
	if(user.real_name == H.dna.real_name)
		return

	user.real_name = H.dna.real_name
	H.dna.copy_dna(user.dna, COPY_DNA_SE|COPY_DNA_SPECIES)
	user.updateappearance(mutcolor_update=1)
	user.domutcheck()
	user.visible_message(span_warning(LANG("obj.41e9148a6b0d452f", list(user, H))), \
	span_bolddanger(LANG("obj.282eb8903d967dcd", list(H.p_They(), H.p_s(), H.p_theyre(), H.p_they()))))
