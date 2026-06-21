/obj/item/seeds/nettle
	name = "荨麻种子包"
	desc = "能长成荨麻的种子。"
	icon_state = "seed-nettle"
	plant_icon_offset = 0
	species = "nettle"
	plantname = "Nettles"
	product = /obj/item/food/grown/nettle
	lifespan = 30
	endurance = 40 // tuff like a toiger
	yield = 4
	instability = 25
	growthstages = 5
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/attack/nettle_attack, /datum/plant_gene/trait/backfire/nettle_burn)
	mutatelist = list(/obj/item/seeds/nettle/death)
	reagents_add = list(/datum/reagent/toxin/acid = 0.5)
	graft_gene = /datum/plant_gene/trait/plant_type/weed_hardy

/obj/item/seeds/nettle/death
	name = "死亡荨麻种子包"
	desc = "能长成死亡荨麻的种子。"
	icon_state = "seed-deathnettle"
	species = "deathnettle"
	plantname = "Death Nettles"
	product = /obj/item/food/grown/nettle/death
	endurance = 25
	maturation = 8
	yield = 2
	genes = list(/datum/plant_gene/trait/repeated_harvest, /datum/plant_gene/trait/plant_type/weed_hardy, /datum/plant_gene/trait/stinging, /datum/plant_gene/trait/attack/nettle_attack/death, /datum/plant_gene/trait/backfire/nettle_burn/death)
	mutatelist = null
	reagents_add = list(/datum/reagent/toxin/acid/fluacid = 0.5, /datum/reagent/toxin/acid = 0.5)
	rarity = PLANT_MODERATELY_RARE
	graft_gene = /datum/plant_gene/trait/stinging

/obj/item/food/grown/nettle // "snack"
	seed = /obj/item/seeds/nettle
	name = "\improper 荨麻"
	desc = "徒手去摸它可能并<B>不是</B>个明智的做法……"
	icon_state = "nettle"
	inhand_icon_state = "nettle"
	bite_consumption_mod = 2
	lefthand_file = 'icons/mob/inhands/weapons/plants_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/plants_righthand.dmi'
	damtype = BURN
	force = 15
	hitsound = 'sound/items/weapons/bladeslice.ogg'
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 1
	throw_range = 3
	attack_verb_continuous = list("stings")
	attack_verb_simple = list("sting")

/obj/item/food/grown/nettle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正在吃一些[src]！看起来[user.p_theyre()]想自杀！"))
	return (BRUTELOSS|TOXLOSS)

/obj/item/food/grown/nettle/death
	seed = /obj/item/seeds/nettle/death
	name = "\improper 死亡荨麻"
	desc = "The <span class='danger'>glowing</span> nettle incites <span class='bolddanger'>rage</span> in you just from looking at it!"
	icon_state = "deathnettle"
	inhand_icon_state = "deathnettle"
	bite_consumption_mod = 4 // I guess if you really wanted to
	force = 30
	wound_bonus = CANT_WOUND
	throwforce = 15
