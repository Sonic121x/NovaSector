///Smoke coming from cigarettes and fires
/datum/pollutant/smoke //and mirrors
	name = "烟雾"
	pollutant_flags = POLLUTANT_APPEARANCE | POLLUTANT_SMELL | POLLUTANT_BREATHE_ACT
	smell_intensity = 1
	descriptor = SCENT_DESC_SMELL
	scent = "smoke"

/datum/pollutant/smoke/breathe_act(mob/living/carbon/victim, amount)
	if(amount <= 50)
		return
	if(prob(20))
		victim.emote("cough")

///From smoking weed
/datum/pollutant/smoke/cannabis
	name = "大麻"
	smell_intensity = 2 //Stronger than the normal smoke
	scent = "cannabis"

/datum/pollutant/smoke/vape
	name = "电子烟烟雾"
	thickness = 2
	scent = "pleasant and soft vapour"

///Dust from mining drills
/datum/pollutant/dust
	name = "灰尘"
	pollutant_flags = POLLUTANT_APPEARANCE | POLLUTANT_BREATHE_ACT
	thickness = 2
	color = "#ffed9c"

/datum/pollutant/dust/breathe_act(mob/living/carbon/victim, amount)
	if(amount <= 10)
		return
	if(prob(40))
		victim.losebreath += 3 //Get in your lungs real bad
		victim.emote("cough")

///Sulphur coming from igniting matches
/datum/pollutant/sulphur
	name = "硫磺"
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 5 //Very pronounced smell (and good too, sniff sniff)
	descriptor = SCENT_DESC_SMELL
	scent = "sulphur"

///Splashing blood makes a tiny bit of this
/datum/pollutant/metallic_scent
	name = "金属气味"
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 1
	descriptor = SCENT_DESC_SMELL
	scent = "a metallic scent"

///A special "Quick Dispersal" smoke for special cigars
/datum/pollutant/bright_cosmos
	name = "宇宙烟雾"
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 1
	descriptor = SCENT_DESC_SMELL
	scent = "refreshing mint and inoffensive smoke"

///Green goo piles and medicine chemical reactions make this
/datum/pollutant/chemical_vapors
	name = "化学蒸汽"
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 1
	descriptor = SCENT_DESC_SMELL
	scent = "chemicals"

///Dangerous fires release this from the waste they're burning
/datum/pollutant/carbon_air_pollution
	name = "碳空气污染"
	pollutant_flags = POLLUTANT_BREATHE_ACT

/datum/pollutant/carbon_air_pollution/breathe_act(mob/living/carbon/victim, amount)
	if(victim.body_position == LYING_DOWN)
		amount *= 0.35 //The victim is inhaling roughly a third when laying down
	if(amount <= 10)
		return
	var/need_mob_update
	need_mob_update += victim.adjust_oxy_loss(rand(5,10), updating_health = FALSE)
	need_mob_update += victim.adjust_tox_loss(1, updating_health = FALSE)
	if(need_mob_update)
		victim.updatehealth()
	if(prob(amount))
		victim.losebreath += 3

//Food related smells
/datum/pollutant/food
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 0.5 //Low intensity because we want to carry it farther with more amounts
	descriptor = SCENT_DESC_SMELL

/datum/pollutant/food/fried_meat
	name = "煎肉"
	scent = "fried meat"

/datum/pollutant/food/fried_bacon
	name = "煎培根"
	scent = "fried bacon"

/datum/pollutant/food/fried_fish
	name = "煎鱼"
	scent = "fried fish"

/datum/pollutant/food/pancakes
	name = "煎饼"
	scent = "pancakes"

/datum/pollutant/food/coffee
	name = "咖啡"
	scent = "coffee"

/datum/pollutant/food/tea
	name = "茶"
	scent = "tea"

/datum/pollutant/food/chocolate
	name = "巧克力"
	scent = "chocolate"

/datum/pollutant/food/spicy_noodles
	name = "辣味面条"
	scent = "spicy noodles"

//Fragrances that we spray on thing to make them smell nice
/datum/pollutant/fragrance
	pollutant_flags = POLLUTANT_SMELL
	smell_intensity = 1
	descriptor = SCENT_DESC_FRAGRANCE

/datum/pollutant/fragrance/air_refresher
	name = "空气清新剂"
	scent = "a strong flowery scent"
	smell_intensity = 3

//Simple fragrances
/datum/pollutant/fragrance/cologne
	name = "古龙水"
	scent = "cologne"

/datum/pollutant/fragrance/wood
	name = "木质香水"
	scent = "aging wood"

/datum/pollutant/fragrance/rose
	name = "玫瑰香水"
	scent = "roses"

/datum/pollutant/fragrance/jasmine
	name = "茉莉香水"
	scent = "jasmine"

/datum/pollutant/fragrance/mint
	name = "薄荷香水"
	scent = "mint"

/datum/pollutant/fragrance/vanilla
	name = "香草香水"
	scent = "vanilla"

/datum/pollutant/fragrance/pear
	name = "梨子香水"
	scent = "pear"

/datum/pollutant/fragrance/strawberry
	name = "草莓香水"
	scent = "strawberries"

/datum/pollutant/fragrance/cherry
	name = "樱桃香水"
	scent = "cherries"

/datum/pollutant/fragrance/amber
	name = "琥珀香水"
	scent = "a sweet and powdery scent"
