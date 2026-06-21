/datum/mood_event/hug
	description = "拥抱的感觉真好。"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/hug/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/aloof))
		mood_change = -1
		description = "我宁愿不被碰触。"
		return
	if(HAS_PERSONALITY(owner, /datum/personality/callous))
		mood_change = 0
		description = "我讨厌拥抱。"
		return

/datum/mood_event/bear_hug
	description = "我被抱得很紧，但感觉相当不错。"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/bear_hug/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/aloof) \
		|| HAS_PERSONALITY(owner, /datum/personality/callous) \
	)
		mood_change = -2
		description = "他们抱得太紧了！"
		return

/datum/mood_event/betterhug
	description = "有人对我非常好。"
	mood_change = 3
	timeout = 4 MINUTES

/datum/mood_event/betterhug/add_effects(mob/friend)
	if(HAS_PERSONALITY(owner, /datum/personality/aloof))
		mood_change = 1
		description = "[friend.name] 人不错，但我希望他们别再碰我了。"
		return
	if(HAS_PERSONALITY(owner, /datum/personality/callous))
		mood_change = 0
		description = "[friend.name] 对这个空间站来说也太好了。"
		return

	description = "[friend.name] 对我非常好。"

/datum/mood_event/besthug
	description = "和某人在一起很棒，他们让我感到非常快乐！"
	mood_change = 5
	timeout = 4 MINUTES

/datum/mood_event/besthug/add_effects(mob/friend)
	if(HAS_PERSONALITY(owner, /datum/personality/aloof))
		mood_change = 2
		description = "[friend.name] 是个很好的伙伴，但我希望他们别再碰我了。"
		return
	if(HAS_PERSONALITY(owner, /datum/personality/callous))
		mood_change = 0
		description = "[friend.name] 对这个空间站来说太好了。"
		return

	description = "[friend.name] 是个很好的伙伴，[friend.p_they()] 让我感到非常快乐！"

/datum/mood_event/warmhug
	description = "温暖舒适的拥抱最棒了！"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/warmhug/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/aloof))
		mood_change = 0
		description = "我宁愿不被触碰，但温暖的感觉还不错……"
		return
	if(HAS_PERSONALITY(owner, /datum/personality/callous))
		mood_change = 0
		description = "我讨厌拥抱。我自己能暖和起来。"
		return

/datum/mood_event/tailpulled
	description = "我喜欢被拉尾巴！"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/tailpulled/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/aloof) \
		|| HAS_PERSONALITY(owner, /datum/personality/callous) \
	)
		mood_change = -2
		description = "到底是谁在碰我的尾巴？"

/datum/mood_event/arcade
	description = "我打赢了街机游戏！"
	mood_change = 3
	timeout = 8 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/arcade/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/industrious) || HAS_PERSONALITY(owner, /datum/personality/slacking/diligent))
		mood_change = -1
		description = "哇，我打赢了游戏。我本可以做任何更有意义的事的。"

/datum/mood_event/blessing
	description = "我受到了祝福。"
	mood_change = 1
	timeout = 8 MINUTES
	event_flags = MOOD_EVENT_SPIRITUAL

/datum/mood_event/maintenance_adaptation
	mood_change = 8

/datum/mood_event/maintenance_adaptation/add_effects()
	description = "[GLOB.deity] 帮助我适应了维护区管道！"

/datum/mood_event/book_nerd
	description = "我最近读了一本书。"
	mood_change = 1
	timeout = 5 MINUTES

/datum/mood_event/book_nerd/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/erudite))
		mood_change = 2
		description = "我爱读书！"
	if(HAS_PERSONALITY(owner, /datum/personality/uneducated))
		mood_change = -1
		description = "谁在乎书啊？"

/datum/mood_event/exercise
	description = "锻炼释放了那些内啡肽！"
	mood_change = 1

/datum/mood_event/exercise/add_effects(fitness_level)
	mood_change = fitness_level // the more fit you are, the more you like to work out
	if(HAS_PERSONALITY(owner, /datum/personality/slacking/lazy))
		mood_change *= -0.5
		description = "锻炼，真是件苦差事！"
	else if(!HAS_PERSONALITY(owner, /datum/personality/athletic))
		mood_change *= 0.5
		description = "锻炼是有点麻烦，但相当有成就感。"

/datum/mood_event/pet_animal
	description = "动物真可爱！我忍不住要抚摸它们！"
	timeout = 5 MINUTES
	/// Tracks the typepath of animal we last petted
	var/animal_type

/datum/mood_event/pet_animal/add_effects(mob/animal)
	animal_type = animal?.type

	if(HAS_PERSONALITY(owner, /datum/personality/animal_disliker))
		mood_change = -1
		description = "呃，[animal] 太脏了！我不想碰它！"
		return

	var/dog_fan = HAS_PERSONALITY(owner, /datum/personality/dog_fan)
	var/isdog = istype(animal, /mob/living/basic/pet/dog)
	var/cat_fan = HAS_PERSONALITY(owner, /datum/personality/cat_fan)
	var/iscat = istype(animal, /mob/living/basic/pet/cat)
	if((dog_fan && isdog) || (cat_fan && iscat) || HAS_PERSONALITY(owner, /datum/personality/animal_friend))
		mood_change = 3
		description = "我太爱[animal]了，[animal.p_theyre()]这么可爱！我忍不住要抚摸[animal.p_them()]！"
		return
	if(dog_fan && iscat)
		mood_change = -1
		description = "我不喜欢[animal]！我更喜欢狗！"
		return
	if(cat_fan && isdog)
		mood_change = -1
		description = "我不喜欢[animal]！我更喜欢猫！"
		return

	mood_change = 1
	description = "[animal]真可爱！"

// Change the moodlet if we get refreshed (we may have pet another type of animal)
/datum/mood_event/pet_animal/be_refreshed(datum/mood/home, mob/animal)
	. = ..()
	if(animal_type == animal?.type)
		return
	add_effects(animal)

/datum/mood_event/honk
	description = "我被按喇叭了！"
	mood_change = 2
	timeout = 4 MINUTES
	special_screen_obj = "honked_nose"
	special_screen_replace = FALSE
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/saved_life
	description = "拯救生命的感觉真好。"
	mood_change = 6
	timeout = 8 MINUTES

/datum/mood_event/saved_life/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/callous))
		mood_change = 0
		description = "我对拯救生命没什么兴趣。"
	if(HAS_PERSONALITY(owner, /datum/personality/misanthropic))
		mood_change = -1
		description = "拯救生命是浪费时间。"

/datum/mood_event/oblivious
	description = "多么美好的一天。"
	mood_change = 3

/datum/mood_event/jolly
	description = "我无缘无故地感到开心。"
	mood_change = 6
	timeout = 2 MINUTES

/datum/mood_event/focused
	description = "我有一个目标，无论付出什么代价，我都要实现它！" //Used for syndies, nukeops etc so they can focus on their goals
	mood_change = 8
	hidden = TRUE

/datum/mood_event/badass_antag
	description = "I'm a fucking badass and everyone around me knows it. Just look at them; they're all fucking shaking at the mere thought of having me around."
	mood_change = 8
	hidden = TRUE
	special_screen_obj = "badass_sun"
	special_screen_replace = FALSE

/datum/mood_event/ling
	description = "我们有一个目标，无论付出什么代价，我们都要实现它！"
	mood_change = 12
	hidden = TRUE

/datum/mood_event/creeping
	description = "那些声音已经从我脑海中松开了钩子！我又感到自由了！" //creeps get it when they are around their obsession
	mood_change = 18
	timeout = 3 SECONDS
	hidden = TRUE

/datum/mood_event/revolution
	description = "革命万岁！"
	mood_change = 3
	hidden = TRUE

/datum/mood_event/cult
	description = "我已目睹真相，赞美全能之主！"
	mood_change = 12 //maybe being a cultist isn't that bad after all
	hidden = TRUE

/datum/mood_event/heretics
	description = "我攀升得越高，所见便越多。"
	mood_change = 12 //maybe being a heretic isnt that bad after all
	hidden = TRUE

/datum/mood_event/rift_fishing
	description = "我钓得越多，攀升得越高。"
	mood_change = 6
	timeout = 5 MINUTES

/datum/mood_event/blood_worm
	description = "杀戮，吞噬，繁衍，征服。"
	mood_change = 999 // Makes it bold green and gives the special obj a higher priority. Blood worm hosts are apathetic, so this is otherwise meaningless.
	hidden = TRUE

/datum/mood_event/family_heirloom
	description = "我的家族传家宝在我这里很安全。"
	mood_change = 1

/datum/mood_event/clown_enjoyer_pin
	description = "我喜欢炫耀我的小丑徽章！"
	mood_change = 1

/datum/mood_event/mime_fan_pin
	description = "我喜欢炫耀我的默剧演员徽章！"
	mood_change = 1

/datum/mood_event/goodmusic
	description = "这音乐有种令人平静的东西。"
	mood_change = 3
	timeout = 60 SECONDS
	event_flags = MOOD_EVENT_ART

/datum/mood_event/chemical_euphoria
	description = "呵……呵呵呵……呵呵……"
	mood_change = 4

/datum/mood_event/chemical_laughter
	description = "欢笑真的是最好的良药！还是说不是呢？"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/chemical_superlaughter
	description = "*喘气*"
	mood_change = 12
	timeout = 3 MINUTES

/datum/mood_event/religiously_comforted
	description = "一位圣洁之人的存在让我感到安慰。"
	mood_change = 3
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_SPIRITUAL

/datum/mood_event/clownshoes
	description = "这双鞋是小丑的遗产，我永远不想脱下它们！"
	mood_change = 3

/datum/mood_event/sacrifice_good
	description = "众神对这个祭品很满意！"
	mood_change = 5
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_SPIRITUAL

/datum/mood_event/artok
	description = "看到人们在这里创作艺术真好。"
	mood_change = 2
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_ART

/datum/mood_event/artgood
	description = "多么发人深省的艺术品。我会记住它一阵子。"
	mood_change = 4
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_ART

/datum/mood_event/artgreat
	description = "那件艺术品太棒了，让我相信了人性的善良。在这种地方，这意义重大。"
	mood_change = 6
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_ART

/datum/mood_event/bottle_flip
	description = "瓶子那样落地真让人满足。"
	mood_change = 2
	timeout = 3 MINUTES

/datum/mood_event/hope_lavaland
	description = "多么奇特的徽记。它让我对自己的未来充满希望。"
	mood_change = 6

/datum/mood_event/hope_lavaland/add_effects(...)
	if(HAS_PERSONALITY(owner, /datum/personality/pessimistic))
		mood_change = 0
		description = "这个徽记是个谎言。对我来说没有希望。"
		return

/datum/mood_event/confident_mane
	description = "一头浓密的头发让我充满自信。"
	mood_change = 2

/datum/mood_event/holy_consumption
	description = "这真是神圣的食物！"
	mood_change = 1 // 1 + 5 from it being liked food makes it as good as jolly
	timeout = 3 MINUTES

/datum/mood_event/high_five
	description = "我喜欢击掌！"
	mood_change = 2
	timeout = 45 SECONDS

/datum/mood_event/helped_up
	description = "扶他们起来感觉真好！"
	timeout = 45 SECONDS

/datum/mood_event/helped_up/can_effect_mob(datum/mood/home, mob/living/who, ...)
	if(!HAS_PERSONALITY(owner, /datum/personality/compassionate) \
		&& !HAS_PERSONALITY(owner, /datum/personality/callous) \
		&& !HAS_PERSONALITY(owner, /datum/personality/misanthropic))
		return FALSE

	return ..()

/datum/mood_event/helped_up/add_effects(mob/other_person, helper)
	if(!other_person)
		return

	if(HAS_PERSONALITY(owner, /datum/personality/callous) || HAS_PERSONALITY(owner, /datum/personality/misanthropic))
		mood_change = -2
		if(helper)
			description = "他们应该自己起来的。"
		else
			description = "我自己也能起来。"

	else if(HAS_PERSONALITY(owner, /datum/personality/compassionate))
		mood_change = 2
		if(helper)
			description = "扶[other_person]起来感觉真好！"
		else
			description = "[other_person]扶我起来了，[other_person.p_them()]真好！"

/datum/mood_event/high_ten
	description = "太棒了！一个击掌十连！"
	mood_change = 3
	timeout = 45 SECONDS
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/down_low
	description = "哈！真是个傻瓜，他们毫无胜算……"
	mood_change = 4
	timeout = 90 SECONDS
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/aquarium_positive
	description = "看着水族箱里的鱼让人平静。"
	mood_change = 3
	timeout = 90 SECONDS

/datum/mood_event/gondola
	description = "我感到内心平和，不想做出任何突然或鲁莽的举动。"
	mood_change = 6

/datum/mood_event/kiss
	description = "有人对我飞吻，我一定是个抢手货！"
	mood_change = 1.5
	timeout = 2 MINUTES

/datum/mood_event/kiss/add_effects(mob/beau, direct)
	if(!beau)
		return
	if(direct)
		description = "[beau.name]给了我一个吻，啊！！"
	else
		description = "[beau.name]给了我一个飞吻，我肯定是个抢手货！"

/datum/mood_event/honorbound
	description = "遵循我的荣誉准则令人满足！"
	mood_change = 4

/datum/mood_event/et_pieces
	description = "嗯……我爱花生酱……"
	mood_change = 50
	timeout = 10 MINUTES

/datum/mood_event/memories_of_home
	description = "这味道有种奇怪的怀旧感……"
	mood_change = 3
	timeout = 5 MINUTES

/datum/mood_event/observed_soda_spill
	description = "啊哈哈！看到有人被汽水罐喷到总是很好笑。"
	mood_change = 2
	timeout = 30 SECONDS
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/observed_soda_spill/add_effects(mob/spilled_mob, atom/soda_can)
	if(!spilled_mob)
		return

	description = "啊哈哈！[spilled_mob]把[spilled_mob.p_their()] [soda_can ? soda_can.name : "soda"]洒了[spilled_mob.p_them()]自己一身！经典场面。"

/datum/mood_event/gaming
	description = "我正在享受愉快的游戏时光！"
	mood_change = 2
	timeout = 30 SECONDS
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/gaming/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/industrious) || HAS_PERSONALITY(owner, /datum/personality/slacking/diligent))
		mood_change = -1
		description = "现在真的是玩游戏的时候吗？我应该在工作。"

/datum/mood_event/gamer_won
	description = "我爱赢电子游戏！"
	mood_change = 6
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/love_reagent
	description = "这食物让我想起了美好的旧时光。"
	mood_change = 5

/datum/mood_event/love_reagent/add_effects(duration)
	if(HAS_PERSONALITY(owner, /datum/personality/pessimistic))
		mood_change = 0
		description = "这食物还行吧，我觉得。"
		return

	if(isnum(duration))
		timeout = duration

/datum/mood_event/won_52_card_pickup
	description = "哈！那个输家可有得捡牌了！"
	mood_change = 3
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_WHIMSY | MOOD_EVENT_GAMING

/datum/mood_event/playing_cards
	description = "我喜欢和别人一起打牌！"
	mood_change = 2
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/playing_cards/add_effects(param)
	var/card_players = 1
	for(var/mob/living/carbon/player in viewers(COMBAT_MESSAGE_RANGE, owner))
		var/player_has_cards = player.is_holding(/obj/item/toy/singlecard) || player.is_holding_item_of_type(/obj/item/toy/cards)
		if(player_has_cards)
			card_players++
			if(card_players > 5)
				break

	mood_change *= card_players
	return ..()

/datum/mood_event/garland
	description = "这些花让人相当平静。"
	mood_change = 1

/datum/mood_event/russian_roulette_win
	description = "我赌上了性命并且赢了！能活下来真是幸运……"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/russian_roulette_win/add_effects(loaded_rounds)
	var/base = HAS_PERSONALITY(owner, /datum/personality/gambler) ? 2 : 1.8
	mood_change = round(base ** loaded_rounds, 1)

/datum/mood_event/fishing
	description = "钓鱼很放松。"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/fish_released
	description = "去吧，鱼儿，游向自由！"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/fish_released/add_effects(morbid, obj/item/fish/fish)
	if(!morbid)
		description = "去吧，[fish.name]，游向自由！"
		return
	if(fish.status == FISH_DEAD)
		description = "总会有拾荒者能找到[fish.name]遗骸的用处的。多么务实啊。"
	else
		description = "回归深海的负担。但这真的是仁慈吗，[fish.name]？总会有更大的鱼……"

/datum/mood_event/fish_petting
	description = "抚摸鱼儿的感觉很好。"
	mood_change = 2
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/fish_petting/add_effects(obj/item/fish/fish, morbid)
	if(!morbid)
		description = "It felt nice to pet \the [fish]."
	else
		description = "I caress \the [fish] as [fish.p_they()] squirms under my touch, blissfully unaware of how cruel this world is."

/datum/mood_event/kobun
	description = "你们都被宇宙所爱。我并不孤单，你也不是。"
	mood_change = 14
	timeout = 10 SECONDS

/datum/mood_event/sabrage_success
	description = "我成功完成了那个军刀开瓶的绝活！炫耀的感觉真好。"
	mood_change = 2
	timeout = 4 MINUTES

/datum/mood_event/sabrage_witness
	description = "我看到有人用一种相当激进的方式打开了香槟瓶塞。"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/it_was_on_the_mouse
	description = "嘿嘿。\"It's on the mouse\"。真是双关妙语。"
	mood_change = 1
	timeout = 2 MINUTES

/datum/mood_event/birthday
	description = "今天是我的生日！"
	mood_change = 2
	special_screen_obj = "birthday"
	special_screen_replace = FALSE

/datum/mood_event/basketball_score
	description = "唰！空心入网。"
	mood_change = 2
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_WHIMSY | MOOD_EVENT_GAMING

/datum/mood_event/basketball_dunk
	description = "大力灌篮！砰，沙卡拉卡！"
	mood_change = 2
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_WHIMSY | MOOD_EVENT_GAMING

/datum/mood_event/moon_smile
	description = "月亮向我展示了真相，它的微笑正对着我！！！"
	mood_change = 10
	timeout = 2 MINUTES

///Wizard cheesy grand finale - what the wizard gets
/datum/mood_event/madness_elation
	description = "疯狂确实是最大的恩赐……"
	mood_change = 200

/datum/mood_event/prophat
	description = "这顶帽子让我充满了奇思妙想的快乐！"
	mood_change = 2
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/slots
	description = "让我们去赌博吧！"
	mood_change = 1
	timeout = 1 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/slots/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/gambler))
		mood_change *= 2
	else if(HAS_PERSONALITY(owner, /datum/personality/industrious) || HAS_PERSONALITY(owner, /datum/personality/slacking/diligent))
		mood_change *= -1
		description = "我为什么要把时间和金钱浪费在赌博上？"


/datum/mood_event/slots/win
	description = "噢耶，我赢了！"
	mood_change = 2
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/slots/win/be_replaced(datum/mood/home, datum/mood_event/new_event, ...)
	if(istype(new_event, /datum/mood_event/slots/all_gone))
		return ALLOW_NEW_MOOD
	if(new_event.mood_change < mood_change)
		return BLOCK_NEW_MOOD
	return ..()

/datum/mood_event/slots/win/big
	mood_change = 3
	timeout = 10 MINUTES

/datum/mood_event/slots/win/jackpot
	description = "头奖！噢耶！"
	mood_change = 4

/datum/mood_event/slots/all_gone
	description = "NOOOOOOO! IT'S ALL GONE!!!"
	mood_change = -2
	timeout = 20 MINUTES

/datum/mood_event/slots/all_gone/be_replaced(datum/mood/home, datum/mood_event/new_event, ...)
	if(istype(new_event, /datum/mood_event/slots/win/jackpot))
		return ALLOW_NEW_MOOD
	description = "I'll never get it back..."
	return BLOCK_NEW_MOOD

/datum/mood_event/empathetic_happy
	description = "看到别人开心，我也开心。"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/misanthropic_happy
	description = "看到别人难过，我就高兴。"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/paranoid/alone
	description = "和平与宁静，周围没人能威胁我。"
	mood_change = 1

/datum/mood_event/paranoid/small_group
	description = "在这个小团体里我感觉更安全。我们互相照应。"
	mood_change = 2

/datum/mood_event/nt_loyalist
	description = "身为NT™大家庭的一员，我感到自豪！"
	mood_change = 2

/datum/mood_event/loyalist_revs_lost
	description = "革命被击败了！纳米传讯万岁！"
	mood_change = 4
	timeout = 10 MINUTES

/datum/mood_event/disillusioned_revs_win
	description = "革命成功了！革命万岁！"
	mood_change = 4
	timeout = 10 MINUTES

/datum/mood_event/enjoying_department_area
	description = "我爱我的工作。"
	mood_change = 1

/datum/mood_event/slacking_off_lazy
	description = "Boss makes a dollar, I make a dime. That's why I slack on company time."
	mood_change = 1

/datum/mood_event/working_diligent
	description = "努力工作本身就是一种回报。"
	mood_change = 1

/datum/mood_event/creative_patronage
	description = "支持艺术家！"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/creative_framing
	description = "挂上艺术品真的让房间变得完整了。"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/creative_sculpting
	description = "雕塑是一种绝佳的创意表达方式。"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/whimsical_slip
	description = "哈哈！那家伙摔倒了！"
	mood_change = 3
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_WHIMSY

/datum/mood_event/bibulous_hangover
	description = "多么美妙的夜晚！我已经等不及再来一次了！"
	mood_change = 2
	timeout = 10 MINUTES

/datum/mood_event/gizmo_positive
	description = "I hear a voice whispering kind words in my ear!"
	mood_change = 3
	timeout = 30 SECONDS
