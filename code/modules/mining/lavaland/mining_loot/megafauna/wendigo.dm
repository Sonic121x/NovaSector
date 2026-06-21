// Wendigo blood

/obj/item/wendigo_blood
	name = "一瓶温迪戈之血"
	desc = "一瓶粘稠的红色液体……你不会真的打算喝下它吧？"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "vial"

/obj/item/wendigo_blood/attack_self(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(!human_user.mind)
		return
	to_chat(human_user, span_danger("力量在你体内奔涌！你现在可以随心所欲地变换形态了。"))
	var/datum/action/cooldown/spell/shapeshift/polar_bear/transformation_spell = new(user.mind || user)
	transformation_spell.Grant(user)
	playsound(human_user.loc, 'sound/items/drink.ogg', rand(10,50), TRUE)
	qdel(src)

// Wendigo skull

/obj/item/wendigo_skull
	name = "温迪戈头骨"
	desc = "从一头嗜血野兽身上撕下的带血头骨，那空洞的眼窝似乎一直在追踪你的移动。"
	icon = 'icons/obj/mining_zones/artefacts.dmi'
	icon_state = "wendigo_skull"
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
