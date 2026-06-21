/obj/item/seeds/cotton
	name = "棉花种子包"
	desc = "A pack of seeds that'll grow into a cotton plant."
	icon_state = "seed-cotton"
	species = "cotton"
	plantname = "Cotton"
	icon_harvest = "cotton-harvest"
	product = /obj/item/grown/cotton
	lifespan = 35
	endurance = 25
	maturation = 15
	production = 1
	yield = 2
	potency = 50
	instability = 15
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_dead = "cotton-dead"
	mutatelist = list(/obj/item/seeds/cotton/durathread)

/obj/item/grown/cotton
	seed = /obj/item/seeds/cotton
	name = "棉包"
	desc = "一捆毛茸茸的棉包."
	icon_state = "cotton"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 2
	throw_range = 3
	attack_verb_continuous = list("pomfs")
	attack_verb_simple = list("pomf")
	var/cotton_type = /obj/item/stack/sheet/cotton
	var/cotton_name = "raw cotton"

/obj/item/grown/cotton/attack_self(mob/user)
	var/cotton_count = 1
	if(seed)
		cotton_count += round(seed.potency / 25)

	user.balloon_alert(user, "扯出了 [cotton_count] piece\s")
	new cotton_type(user.drop_location(), cotton_count)
	qdel(src)


//reinforced mutated variant
/obj/item/seeds/cotton/durathread
	name = "耐拉线种子包"
	desc = "一包种子，如果按照正确的方法进行编织，将会长成一种极其坚固的线，其强度甚至可以与等离子钢相媲美。"
	icon_state = "seed-durathread"
	species = "durathread"
	plantname = "Durathread"
	icon_harvest = "durathread-harvest"
	product = /obj/item/grown/cotton/durathread
	lifespan = 80
	endurance = 50
	maturation = 15
	production = 1
	yield = 2
	potency = 50
	growthstages = 3
	growing_icon = 'icons/obj/service/hydroponics/growing.dmi'
	icon_dead = "cotton-dead"
	mutatelist = null

/obj/item/grown/cotton/durathread
	seed = /obj/item/seeds/cotton/durathread
	name = "杜拉棉包"
	desc = "这是一根结实的杜拉棉织带，祝你顺利解开它吧。"
	icon_state = "durathread"
	force = 5
	throwforce = 5
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 2
	throw_range = 3
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "whack")
	cotton_type = /obj/item/stack/sheet/cotton/durathread
	cotton_name = "raw durathread"
