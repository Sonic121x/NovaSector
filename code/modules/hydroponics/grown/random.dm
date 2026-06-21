//Random seeds; stats, traits, and plant type are randomized for each seed.

/obj/item/seeds/random
	name = "奇怪种子包"
	desc = "神秘的种子，正如其名字所暗示的那样充满诡异气息。令人毛骨悚然。"
	icon_state = "seed-x"
	species = "?????"
	plantname = "strange plant"
	product = /obj/item/food/grown/random
	icon_grow = "xpod-grow"
	icon_dead = "xpod-dead"
	icon_harvest = "xpod-harvest"
	growthstages = 4
	custom_premium_price = PAYCHECK_CREW * 2

/obj/item/seeds/random/Initialize(mapload)
	. = ..()
	randomize_stats()
	if(prob(60))
		add_random_reagents(1, 3)
	if(prob(50))
		add_random_traits(1, 2)
	add_random_plant_type(35)

/obj/item/food/grown/random
	seed = /obj/item/seeds/random
	name = "strange plant"
	desc = "它会长成什么呢？"
	icon_state = "crunchy"

/obj/item/food/grown/random/Initialize(mapload)
	. = ..()
	wine_power = rand(10,150)
	if(prob(1))
		wine_power = 200
