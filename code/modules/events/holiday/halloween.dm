/datum/round_event_control/spooky
	name = "2 重吓人！(万圣节)"
	holidayID = HALLOWEEN
	typepath = /datum/round_event/spooky
	weight = -1 //forces it to be called, regardless of weight
	max_occurrences = 1
	earliest_start = 0 MINUTES
	category = EVENT_CATEGORY_HOLIDAY
	description = "给每个人分发糖果，并将伊恩和波利变成节日版本。"

/datum/round_event/spooky/start()
	..()
	for(var/i in GLOB.human_list)
		var/mob/living/carbon/human/H = i
		var/obj/item/storage/backpack/b = locate() in H.contents
		if(b)
			new /obj/item/storage/spooky(b)

	for(var/mob/living/basic/pet/dog/corgi/ian/Ian in GLOB.mob_living_list)
		Ian.place_on_head(new /obj/item/bedsheet(Ian))
	for(var/mob/living/basic/parrot/poly/bird in GLOB.mob_living_list)
		new /mob/living/basic/parrot/poly/ghost(bird.loc)
		qdel(bird)

/datum/round_event/spooky/announce(fake)
	priority_announce(pick("我的骨头在咯咯作响！","这趟旅程永无止境！", "一具骷髅跳了出来！", "恐怖骷髅惊魂夜！", "船员们当心，你们要吓破胆了！") , "电话是从房子里面打来的")

//spooky foods (you can't actually make these when it's not halloween)
/obj/item/food/cookie/sugar/spookyskull
	name = "头骨饼干"
	desc = "好诡异！它还带有美味的钙味呢！"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "skeletoncookie"
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/cookie/sugar/spookyskull/Initialize(mapload, seasonal_changes = FALSE)
	// Changes default parameter of seasonal_changes to FALSE, pass to parent
	return ..(mapload, seasonal_changes)

/obj/item/food/cookie/sugar/spookycoffin
	name = "棺椁饼干"
	desc = "好诡异！它还带有美味的咖啡香味呢！"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "coffincookie"
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/cookie/sugar/spookycoffin/Initialize(mapload, seasonal_changes = FALSE)
	// Changes default parameter of seasonal_changes to FALSE, pass to parent
	return ..(mapload, seasonal_changes)

//spooky items

/obj/item/storage/spooky
	name = "不给糖就捣蛋篮"
	desc = "一个南瓜形状的袋子，里面装着各种各样的糖果"
	icon = 'icons/obj/holiday/halloween_items.dmi'
	icon_state = "treatbag"

/obj/item/storage/spooky/Initialize(mapload)
	. = ..()
	for(var/distrobuteinbag in 0 to 5)
		var/type = pick(/obj/item/food/cookie/sugar/spookyskull,
		/obj/item/food/cookie/sugar/spookycoffin,
		/obj/item/food/candy_corn,
		/obj/item/food/candy,
		/obj/item/food/candiedapple,
		/obj/item/food/chocolatebar,
		/obj/item/organ/brain ) // OH GOD THIS ISN'T CANDY!
		new type(src)
