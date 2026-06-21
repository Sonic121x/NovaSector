/obj/item/seeds/banana/spider_banana
	name = "长腿香蕉种子包"
	desc = "这些种子会长成香蕉树。不过，那些香蕉可能是活的。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-spibanana"
	species = "spibanana"
	growing_icon = 'modular_nova/master_files/icons/obj/hydroponics/growing.dmi'
	icon_grow = "spibanana-grow"
	icon_dead = "spibanana-dead"
	icon_harvest = "spibanana-harvest"
	plantname = "Leggy Banana Tree"
	product = /obj/item/food/grown/banana/banana_spider_spawnable
	genes = list(/datum/plant_gene/trait/slip)

/obj/item/food/grown/banana/banana_spider_spawnable
	name = "香蕉蜘蛛"
	desc = "你不知道它是什么，但你可以肯定小丑会喜欢它。"
	icon = 'modular_nova/master_files/icons/obj/hydroponics/harvest.dmi'
	icon_state = "spibanana"
	foodtypes = GORE | MEAT | RAW | FRUIT
	var/awakening = FALSE

/obj/item/food/grown/banana/banana_spider_spawnable/attack_self(mob/user)
	if(awakening || isspaceturf(user.loc))
		return
	to_chat(user, span_notice("你决定叫醒这只香蕉蜘蛛……"))
	awakening = TRUE
	addtimer(CALLBACK(src, PROC_REF(spawnspider)), 8 SECONDS)

/obj/item/food/grown/banana/banana_spider_spawnable/proc/spawnspider()
	if(!QDELETED(src))
		var/mob/living/basic/banana_spider/banana_spider = new(get_turf(loc))
		banana_spider.visible_message(span_notice("香蕉蜘蛛伸展着腿，发出吱吱的叫声"))
		qdel(src)

