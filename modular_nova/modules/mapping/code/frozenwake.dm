/obj/item/paper/crumpled/bloody/fluff/stations/lavaland/frozenwake/
	name = "古老羊皮纸"
	desc = "一张用Ættmál语书写的便条。"
	default_raw_text = "<i>他们说神明不会陨落。但我亲眼所见。我听见巴德尔之光黯淡后的寂静。风停止了歌唱。火焰不再回应。连石头都在哭泣——我发誓。<br><br>我们用疼痛的双手雕刻这些墙壁，在冰与石中讲述他的故事，希望回声能抵达星辰。有人说，当族火再次熊熊燃烧时，他会归来。我已等待了太久。我的呼吸变得稀薄。我的梦境愈发寒冷。<br><br>如果你找到了这个，你正站在希望冻结之地。或许你仍携带着温暖。或许你还记得。</i><br><br>-失落大厅的埃尔德瓦恩·冰缚者"

/obj/item/paper/crumpled/bloody/fluff/stations/lavaland/frozenwake/ui_status(mob/user, datum/ui_state/state)
	if(!user.has_language(/datum/language/primitive_catgirl))
		to_chat(user, span_warning("这似乎是一种你不理解的语言！"))
		return UI_CLOSE
	. = ..()

/obj/structure/statue/hearthkin/frozenwake
	name = "巴德尔，陨落之光雕像"
	desc = "一尊庄严的巴德尔雕塑从风扫过的雪床中升起，他的身形披着雕刻的霜袍。他的面容安详——过于安详。裂缝贯穿石基，仿佛世界的悲伤随时间将其撕裂。他张开双臂，并非为了胜利，而是为了告别。基座周围，古老的符文在冰中半埋，微弱地闪烁。"
	icon = 'modular_nova/modules/primitive_catgirls/icons/gods_statue.dmi'
	icon_state = "odin_statue"
	anchored = 1
	impressiveness = 30
	///variable added to let people understanding Ættmál (icecat, people having read the babel book that can spawn in the ruins.) read the runes.
	var/added_desc = "Your understanding of Ættmál lets you read the runes. 'The light most pure was first to fade. We sang no songs loud enough to hold him here.'"
	///variables used for the puzzle controller.
	var/puzzle_id = ""
	resistance_flags = INDESTRUCTIBLE

/obj/structure/statue/hearthkin/frozenwake/stele
	name = "\improper 霜醒石碑"
	desc = "一块平坦的石板，被时间磨得光滑，表面布满古老的凹坑。炉族符文深深镌刻其中，阅读时边缘泛着微弱的余烬之光，仍散发着静谧的温暖。烟灰沾染的指纹划过表面——那是早已消失之手的痕迹，仿佛它所讲述的故事曾被一遍又一遍地虔诚描摹。"
	icon = 'modular_nova/modules/primitive_catgirls/icons/gods_statue.dmi' // needs its own sprite
	icon_state = "runestone"
	impressiveness = 30
	resistance_flags = INDESTRUCTIBLE

/obj/structure/statue/hearthkin/frozenwake/stele/dream
	name = "梦境石碑"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'In a season of shadowless sky, Baldr dreamt of his own demise. Kin gathered with worried breath, yet none could still the frost in his heart'."

/obj/structure/statue/hearthkin/frozenwake/stele/oath
	name = "族裔誓言石碑"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'All things that crawled or stood or flew were made to swear no harm. Stone, flame, beast, and breath — all but one'."

/obj/structure/statue/hearthkin/frozenwake/stele/weeping_spear
	name = "泣矛石碑"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'By a jest most cruel, the blind one threw — a lance of wood that wept no oath. It struck, and Baldr fell with no sound'."

/obj/structure/statue/hearthkin/frozenwake/stele/mourning
	name = "哀悼石碑"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'The cavern shook. Ice wept. Kin wailed songs the winds remember. His brother, hooded in grief, struck silence into the halls of the betrayer'."

/obj/structure/statue/hearthkin/frozenwake/stele/watch
	name = "守望石碑"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'Baldr was bound in a ring of runes. The cold held him, but the hearth remembered. One day, a voice may call him home'."

/obj/structure/statue/hearthkin/frozenwake/puzzle/dreamer
	name = "梦者雕像"
	desc = "一位高贵的炉族，双眼紧闭，双臂交叉于胸前。一缕微弱的雾气如蒸汽般从他额前盘旋升起。基座上刻有炉族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'He dreamed of a silence that could not be lifted.'"
	puzzle_id = "dreamer"

/obj/structure/statue/hearthkin/frozenwake/puzzle/circle
	name = "族裔之环雕像"
	desc = "多个身影在低垂的天空下连接成环，手掌相抵。基座上刻有炉族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'They bound the world in oaths for his safety.'"
	puzzle_id = "circle"

/obj/structure/statue/hearthkin/frozenwake/puzzle/betrayer
	name = "背叛者雕像"
	desc = "一个被蒙住双眼的身影站立着，手臂伸出，手持木矛。他们的面容因悲伤而扭曲。基座上刻有炉族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'One cast what he did not see.'"
	puzzle_id = "betrayer"

/obj/structure/statue/hearthkin/frozenwake/puzzle/fall
	name = "光陨之像"
	desc = "一位高贵的炉心族人倒在地上，身后雕刻着如破碎光环般的光线。符文从他的身体向外螺旋延伸。基座上刻有炉心族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'The silence that followed was deeper than death.'"
	puzzle_id = "fall"

/obj/structure/statue/hearthkin/frozenwake/puzzle/avenger
	name = "复仇者之像"
	desc = "一个炉心族人笼罩在厚重的兜帽下，紧握着一把带有霜痕的斧头。基座上刻有炉心族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'Grief made his hand swift.'"
	puzzle_id = "avenger"

/obj/structure/statue/hearthkin/frozenwake/puzzle/watcher
	name = "墓穴守望者之像"
	desc = "一位闭着眼睛的守护者雕像，站在冰封之剑旁，一只手举向天花板。基座上刻有炉心族符文。"
	added_desc = "Your understanding of Ættmál lets you read the runes. 'He watches still.'"
	puzzle_id = "watcher"

/obj/structure/statue/hearthkin/frozenwake/examine(mob/user)
	. = ..()
	if(user.has_language(/datum/language/primitive_catgirl))
		. += "<br>" + span_info(added_desc)

/obj/structure/ice_stasis/frozenwake
	name = "冰柱"
	desc = "在古老的冰柱内，封存着一座炉心族雕像，肃穆而骄傲。它伸出的双臂中托着一把巨剑，剑身宽阔，剑刃上蚀刻的符文在冰霜下微弱地脉动，宛如一段久已沉寂记忆的心跳。包裹着开裂皮革的剑柄，被饱经风霜的石手紧紧握住。尽管被禁锢于静止之中，剑与雕像似乎都在等待——并非等待自由，而是等待被铭记。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "frozen"
	density = TRUE
	max_integrity = 100
	armor_type = /datum/armor/structure_ice_stasis
	resistance_flags = INDESTRUCTIBLE
	anchored = TRUE

///Proc used to check if get_area returns the frozenwake puzzle area.
/proc/get_frozenwake_puzzle_area(atom/location)
	var/area/area_check = get_area(location)
	if (istype(area_check, /area/ruin/unpowered/frozenwake))
		return area_check
	return null

/obj/structure/ice_stasis/frozenwake/Initialize(mapload)
	. = ..()
	var/area/ruin/unpowered/frozenwake/puzzle_area = get_frozenwake_puzzle_area(src)
	if (puzzle_area)
		puzzle_area.frozenwake_stasis_target = src

//Used to check the progression of the puzzle.
/datum/frozenwake_puzzle
	/// what the expected order to solve the puzzle
	var/list/expected_order = list("dreamer", "circle", "betrayer", "fall")
	/// what has currently been selected to compare to the expected_order
	var/list/current_sequence = list()

///Compares the puzzle expected_order to current_sequence
/datum/frozenwake_puzzle/proc/lists_match(list/first_list, list/second_list)
	if(length(first_list) != length(second_list))
		return FALSE

	for(var/list_index = 1, list_index <= length(first_list), list_index++)
		if(first_list[list_index ] != second_list[list_index ])
			return FALSE

	return TRUE

///adds the last clicked statue to the current_sequence. Keeps only the last 4 stored.
/datum/frozenwake_puzzle/proc/register_click(statue_id, puzzle_area)
	if (!istype(puzzle_area, /area/ruin/unpowered/frozenwake))
		return
	var/area/ruin/unpowered/frozenwake/frozenwake_area = puzzle_area

	current_sequence += statue_id

	if(length(current_sequence) > length(expected_order))
		current_sequence.Cut(1, 2) // Keep last inputs

	if(lists_match(current_sequence, expected_order))
		trigger_success(frozenwake_area)



/obj/item/kinetic_crusher/runic_greatsword/vidrhefjandi
	name = "viðrhefjandi"
	desc = "这把巨剑微弱地脉动着余烬之光。其刃上铭刻着炉心族符文——一把并非为战争，而是为纪念而生的剑。握在手中感觉温暖，像一个被遗忘的承诺。"

///Breaks the ice and drops the sword if puzzle completed.
/datum/frozenwake_puzzle/proc/trigger_success(success_area)
	if (!istype(success_area, /area/ruin/unpowered/frozenwake))
		return

	var/area/ruin/unpowered/frozenwake/frozenwake_area = success_area

	if (frozenwake_area.frozenwake_stasis_target)
		var/turf/reward_loc = get_turf(frozenwake_area.frozenwake_stasis_target)
		for (var/mob/emoted in view(7, reward_loc))
			to_chat(emoted, span_notice("冰层伴随着深沉的呻吟裂开……然后粉碎了！"))
		qdel(frozenwake_area.frozenwake_stasis_target)
		new /obj/item/kinetic_crusher/runic_greatsword/vidrhefjandi(reward_loc)

//what happen when you touch a statue.
/obj/structure/statue/hearthkin/frozenwake/puzzle/attack_hand(mob/user)
	var/area/ruin/unpowered/frozenwake/puzzle_area = get_frozenwake_puzzle_area(src)
	if (puzzle_area)
		puzzle_area.frozenwake_puzzle_controller.register_click(puzzle_id, puzzle_area)
		to_chat(user, "你触摸了雕像。石头发出柔和的嗡鸣。")
	else
		to_chat(user, "调试：雕像位于谜题区域外。")


//Initializing the glow for the steles.
/obj/structure/statue/hearthkin/frozenwake/stele/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

//Adding the glowing runes overlay to the steles.
/obj/structure/statue/hearthkin/frozenwake/stele/update_overlays()
	. = ..()
	. += add_runic_glow()

///selecting the correct file for the glow.
/obj/structure/statue/hearthkin/frozenwake/stele/proc/add_runic_glow()
	return emissive_appearance(
		'modular_nova/modules/primitive_catgirls/icons/gods_statue.dmi',
		"[icon_state]-emissive",
		src,
		alpha = src.alpha
	)

/mob/living/basic/ghost/swarm/frozenwake
	name = "符文束缚的回响"
	desc = "一个苍白的身影无声地飘过冰封的大厅。模糊的毛茸茸耳朵和拖曳的尾巴表明它曾是炉心族人，尽管它的脚步正沿着一条早已被遗忘的道路前行。"
	/// list of sayings that the echo can choose from
	var/emotional_damage = list(
		"The oath... it was broken...",
		"He was light. We let it die.",
		"Stone remembers what kin forget.",
		"I sang until my throat froze. No one heard.",
		"The spear wept. The hand did not.",
		"Even the fire turned its face away...",
		"Wake him... let the silence end.",
		"We were bound. We were blind.",
		"His name is carved in sorrow.",
		"I see him, still... waiting beneath the ice.",
		"I begged the wind to carry our grief.",
		"Who will avenge the fallen light?",
		"No oath spared him. No song saved him.",
		"He watched. He knew. He struck.",
		"I dream of warmth... but only snow answers.",
		"It was not supposed to end like this.",
		"Baldr... forgive us.",
		"We lit the fires. They would not burn.",
		"The betrayer weeps, but the wound remains.",
		"A voice... a voice in the dark... is it you?"
	)

/mob/living/basic/ghost/swarm/frozenwake/unproven
	name = "小型符文束缚的回响"
	desc = "这个小小的幽灵形态在冰柱间穿梭，绒毛耳朵抽动着，细长的尾巴在身后卷曲。它哼着不成调的旋律，没有察觉到你的存在。"
	emotional_damage = list(
		"Where did the sun go?",
		"He said he'd come back... he promised.",
		"It's cold. I'm still waiting.",
		"I made a song for him... but I forgot the end.",
		"Mama said the light would keep us safe...",
		"I held the rune tight... but it didn’t work.",
		"They told me not to look. I looked anyway.",
		"We played in the snow before the silence.",
		"I can't find my brothers. Have you seen them?",
		"I want to go home... but I don’t remember where it is.",
	)

//Initialize the ghosts speaking loop.
/mob/living/basic/ghost/swarm/frozenwake/Initialize(mapload)
	. = ..()
	start_quote_loop()

///Ghost speaking loop, hopefully not too spammy.
/mob/living/basic/ghost/swarm/frozenwake/proc/start_quote_loop()
	// Delay the first line randomly to desync mobs
	addtimer(CALLBACK(src, .proc/speak_emotion), rand(100, 300)) // 10-30 seconds

/// at a chance, allows the echo to say something from emotional_damage
/mob/living/basic/ghost/swarm/frozenwake/proc/speak_emotion()
	if(prob(40)) // 40% chance to speak when timer triggers
		var/message = pick(emotional_damage)
		say(message, language = /datum/language/primitive_catgirl)

	// Re-add the timer with a random interval to keep them from being predictable
	addtimer(CALLBACK(src, .proc/speak_emotion), rand(200, 600)) // 20-60 seconds

//Make sure the ref to the ice pillar is removed if the item is deleted.
/obj/structure/ice_stasis/frozenwake/Destroy()
	var/area/ruin/unpowered/frozenwake/puzzle_area = get_frozenwake_puzzle_area(src)
	if (puzzle_area)
		if (puzzle_area.frozenwake_stasis_target == src)
			puzzle_area.frozenwake_stasis_target = null
	return ..()
