/datum/mood_event/handcuffed
	description = "看来我的胡闹终于让我自食其果了。"
	mood_change = -1

/datum/mood_event/broken_vow //Used for when mimes break their vow of silence
	description = "我玷污了自己的名声，违背了我们神圣的誓言，背叛了我的默剧演员同胞……"
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/on_fire
	description = "我着火了！！！"
	mood_change = -12
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/suffocation
	description = "无法……呼吸……"
	mood_change = -12
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/burnt_thumb
	description = "我不该玩打火机的……"
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/cold
	description = "这里太冷了。"
	mood_change = -5

/datum/mood_event/hot
	description = "这里越来越热了。"
	mood_change = -5

/datum/mood_event/creampie
	description = "我被奶油糊了一脸。尝起来像派的味道。"
	mood_change = -2
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_WHIMSY // if whimsical, no penalty

/datum/mood_event/inked
	description = "我被乌贼墨汁泼了一身。尝起来是咸的。"
	mood_change = -3
	timeout = 3 MINUTES

/datum/mood_event/slipped
	description = "我滑倒了。下次应该更小心点……"
	mood_change = -2
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_WHIMSY // if whimsical, no penalty

/datum/mood_event/eye_stab
	description = "我曾经也是个像你一样的冒险者，直到我的眼睛挨了一螺丝刀。"
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/delam //SM delamination
	description = "那些该死的工程师什么都做不好……"
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/cascade // Big boi delamination
	description = "我从没想过会目睹共振级联，更别说亲身经历了……"
	mood_change = -8
	timeout = 5 MINUTES

/datum/mood_event/depression
	description = "我感到莫名的悲伤。"
	mood_change = -12
	timeout = 2 MINUTES

/datum/mood_event/shameful_suicide //suicide_acts that return SHAME, like sord
	description = "我连自我了断都做不到！"
	mood_change = -15
	timeout = 60 SECONDS

/datum/mood_event/dismembered
	description = "啊！我的肢体！我还在用着呢！"
	mood_change = -10
	timeout = 8 MINUTES

/datum/mood_event/dismembered/add_effects(obj/item/bodypart/limb)
	if(limb)
		description = "啊！我的[uppertext(limb.plaintext_zone)]！我还在用着呢！"

/datum/mood_event/reattachment
	description = "哎哟！我的肢体感觉像睡着时压麻了一样。"
	mood_change = -3
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_PAIN

/datum/mood_event/reattachment/add_effects(obj/item/bodypart/limb)
	if(limb)
		description = "哎哟！我的[limb.plaintext_zone]感觉像睡着时压麻了一样。"

/datum/mood_event/tased
	description = "There's no \"z\" in \"taser\". It's in the zap."
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/embedded
	description = "把它拔出来！"
	mood_change = -7

/datum/mood_event/table
	description = "有人把我扔到桌子上了！"
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/table/add_effects()
	if(isfelinid(owner)) //Holy snowflake batman!
		var/mob/living/carbon/human/feline = owner
		feline.wag_tail(3 SECONDS)
		description = "他们想在桌子上玩！"
		mood_change = 2

/datum/mood_event/table_limbsmash
	description = "那张该死的桌子，伙计，真疼啊……"
	mood_change = -3
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_PAIN

/datum/mood_event/table_limbsmash/add_effects(obj/item/bodypart/banged_limb)
	if(banged_limb)
		description = "我操我的[banged_limb.plaintext_zone]，真他妈疼..."

/datum/mood_event/brain_damage
	mood_change = -3

/datum/mood_event/brain_damage/add_effects()
	var/damage_message = pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage")
	description = "呃呃呃... [damage_message]"

/datum/mood_event/hulk //Entire duration of having the hulk mutation
	description = "浩克砸烂一切！"
	mood_change = -4

/datum/mood_event/epilepsy //Only when the mutation causes a seizure
	description = "我当初真该注意那个癫痫警告的。"
	mood_change = -3
	timeout = 5 MINUTES

/datum/mood_event/photophobia
	description = "灯光太刺眼了..."
	mood_change = -3
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/nyctophobia
	description = "这周围可真够黑的..."
	mood_change = -3
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/claustrophobia
	description = "为什么我感觉被困住了？！放我出去！！！"
	mood_change = -7
	timeout = 1 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/bright_light
	description = "我讨厌光亮...我得找个更暗的地方..."
	mood_change = -12

/datum/mood_event/family_heirloom_missing
	description = "我的传家宝不见了..."
	mood_change = -4

/datum/mood_event/healsbadman
	description = "我感觉自己像被细线勉强缝在一起，随时都可能散架！"
	mood_change = -4
	timeout = 2 MINUTES

/datum/mood_event/healsbadman/long_term
	timeout = 10 MINUTES

/datum/mood_event/jittery
	description = "我紧张不安，坐立难安！！"
	mood_change = -2

/datum/mood_event/jittery/add_effects(...)
	if(HAS_PERSONALITY(owner, /datum/personality/paranoid))
		mood_change -= 1

/datum/mood_event/choke
	description = "我无法呼吸！！！"
	mood_change = -10
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/vomit
	description = "我刚吐了。真恶心。"
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/vomitself
	description = "我吐了自己一身。这太恶心了。"
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/painful_medicine
	description = "药可能对我有好处，但现在它疼得要命。"
	mood_change = -5
	timeout = 60 SECONDS
	event_flags = MOOD_EVENT_PAIN

/datum/mood_event/startled
	description = "听到那个词让我想起了可怕的东西。"
	mood_change = -1
	timeout = 1 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/phobia
	description = "我看到了非常可怕的东西！"
	mood_change = -4
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/spooked
	description = "那些骨头的嘎嘎声……它还在困扰着我。"
	mood_change = -4
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/notcreeping
	description = "那些声音不高兴了，它们痛苦地扭曲我的思想，让我回到任务上。"
	mood_change = -6
	timeout = 3 SECONDS
	hidden = TRUE

/datum/mood_event/notcreepingsevere//not hidden since it's so severe
	description = "他们需需需需需需要执念！！"
	mood_change = -30
	timeout = 3 SECONDS

/datum/mood_event/notcreepingsevere/add_effects(name)
	var/list/unstable = list(name)
	for(var/i in 1 to rand(3,5))
		unstable += copytext_char(name, -1)
	var/unhinged = uppertext(unstable.Join(""))//example Tinea Luxor > TINEA LUXORRRR (with randomness in how long that slur is)
	description = "他们需需需需需需要[unhinged]！！"

/datum/mood_event/tower_of_babel
	description = "我的交流能力变成了一团混乱的巴别塔……"
	mood_change = -1
	timeout = 15 SECONDS

/datum/mood_event/back_pain
	description = "背包在我背上从来都放不好，这疼得要命！"
	mood_change = -15
	event_flags = MOOD_EVENT_PAIN

/datum/mood_event/sacrifice_bad
	description = "那些该死的野蛮人！"
	mood_change = -5
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_SPIRITUAL

/datum/mood_event/artbad
	description = "我屁股里拉出来的都比那玩意儿艺术。"
	mood_change = -2
	timeout = 2 MINUTES
	event_flags = MOOD_EVENT_ART

/datum/mood_event/artbad/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/creative))
		mood_change = 0
		description = "每个人的艺术之旅都得有个起点嘛！"

/datum/mood_event/graverobbing
	description = "I just desecrated someone's grave... I can't believe I did that..."
	mood_change = -8
	timeout = 3 MINUTES

/datum/mood_event/deaths_door
	description = "就是现在了……我真的要死了。"
	mood_change = -20

/datum/mood_event/gunpoint
	description = "这家伙疯了！我最好小心点……"
	mood_change = -10
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/tripped
	description = "真不敢相信我居然中了这种最老套的把戏！"
	mood_change = -5
	timeout = 2 MINUTES

/datum/mood_event/untied
	description = "我最讨厌鞋带松开了！"
	mood_change = -3
	timeout = 60 SECONDS

/datum/mood_event/gates_of_mansus
	description = "我瞥见了这个世界之外的恐怖。现实在我眼前瓦解了！"
	mood_change = -25
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/high_five_full_hand
	description = "天啊，我连击掌都不会……"
	mood_change = -1
	timeout = 45 SECONDS

/datum/mood_event/too_slow
	description = "不！我怎么会……太慢了？？？"
	mood_change = -2 // multiplied by how many people saw it happen, up to 8, so potentially massive. the ULTIMATE prank carries a lot of weight
	timeout = 2 MINUTES

/datum/mood_event/too_slow/add_effects(param)
	var/people_laughing_at_you = 1 // start with 1 in case they're on the same tile or something
	for(var/mob/living/carbon/iter_carbon in oview(owner, 7))
		if(iter_carbon.stat == CONSCIOUS)
			people_laughing_at_you++
			if(people_laughing_at_you > 7)
				break

	mood_change *= people_laughing_at_you
	return ..()

/datum/mood_event/surgery
	description = "他们在切开我！！"
	mood_change = -8
	event_flags = MOOD_EVENT_FEAR
	var/surgery_completed = FALSE

/datum/mood_event/surgery/success
	description = "那手术真疼……不过好歹成功了，我想……"
	timeout = 3 MINUTES
	surgery_completed = TRUE

/datum/mood_event/surgery/failure
	description = "啊啊啊啊啊！他们活活把我片了！"
	timeout = 10 MINUTES
	surgery_completed = TRUE

/datum/mood_event/bald
	description = "我需要点东西遮住我的头……"
	mood_change = -3

/datum/mood_event/bald_reminder
	description = "我又想起来我的头发再也长不回来了！这太糟了！"
	mood_change = -5
	timeout = 4 MINUTES

/datum/mood_event/bad_touch
	description = "我不喜欢别人碰我。"
	mood_change = -3
	timeout = 4 MINUTES

/datum/mood_event/very_bad_touch
	description = "我真的非常不喜欢别人碰我。"
	mood_change = -5
	timeout = 4 MINUTES

/datum/mood_event/noogie
	description = "嗷！这感觉就像又回到了太空高中时代……"
	mood_change = -2
	timeout = 60 SECONDS

/datum/mood_event/noogie_harsh
	description = "嗷！！这比普通的指节钻头还疼！"
	mood_change = -4
	timeout = 60 SECONDS

/datum/mood_event/aquarium_negative
	description = "所有的鱼都死了……"
	mood_change = -3
	timeout = 90 SECONDS

/datum/mood_event/tail_lost
	description = "我的尾巴！！为什么？！"
	mood_change = -8
	timeout = 10 MINUTES

/datum/mood_event/tail_balance_lost
	description = "没了尾巴我感觉身体不平衡。"
	mood_change = -2

/datum/mood_event/tail_regained_wrong
	description = "这是什么恶心的玩笑吗？！这根本就不是我原来的尾巴。"
	mood_change = -12 // -8 for tail still missing + -4 bonus for being frakenstein's monster
	timeout = 5 MINUTES

/datum/mood_event/tail_regained_species
	description = "这条尾巴不是我的，但至少它能让我保持平衡……"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/tail_regained_right
	description = "我的尾巴回来了，但那过程太痛苦了……"
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/burnt_wings
	description = "我宝贵的翅膀啊！！"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/holy_smite //punished
	description = "我被我的神明惩罚了！"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/banished //when the chaplain is sus! (and gets forcably de-holy'd)
	description = "我被逐出教会了！"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/heresy
	description = "到处都是异端邪说，我快喘不过气了！"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/soda_spill
	description = "酷！没关系，我本来就想把苏打水穿在身上，而不是喝掉……"
	mood_change = -2
	timeout = 1 MINUTES

/datum/mood_event/watersprayed
	description = "我讨厌被水喷！"
	mood_change = -1
	timeout = 30 SECONDS

/datum/mood_event/gamer_withdrawal
	description = "真希望我现在正在打游戏……"
	mood_change = -5
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/gamer_lost
	description = "如果我电子游戏玩得不好，还能算是个真正的玩家吗？"
	mood_change = -6
	timeout = 10 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/lost_52_card_pickup
	description = "这太尴尬了！把地上这些牌都捡起来真让我感到羞愧……"
	mood_change = -3
	timeout = 3 MINUTES
	event_flags = MOOD_EVENT_WHIMSY | MOOD_EVENT_GAMING

/datum/mood_event/russian_roulette_lose_cheater
	description = "我赌输了！幸好我没瞄准自己的脑袋……"
	mood_change = -10
	timeout = 10 MINUTES

/datum/mood_event/russian_roulette_lose
	description = "我赌上了自己的性命，结果输了！我想这就是结局了……"
	mood_change = -20
	timeout = 10 MINUTES

/datum/mood_event/russian_roulette_lose/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/gambler))
		mood_change *= 0.5
		description = "我赌上了自己的性命，结果却输了！真相是，这场游戏从一开始就是被操纵的……"
		return

/datum/mood_event/bad_touch_bear_hug
	description = "我刚才被抱得太紧了。"
	mood_change = -1
	timeout = 2 MINUTES

/datum/mood_event/rippedtail
	description = "我把他们的尾巴扯下来了，我都干了些什么！"
	mood_change = -5
	timeout = 30 SECONDS

/datum/mood_event/sabrage_fail
	description = "该死！那个特技没按计划进行！"
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/body_purist
	description = "我感觉到了身上的赛博植入体，我讨厌它！"

/datum/mood_event/body_purist/add_effects(power)
	mood_change = power

/datum/mood_event/unsatisfied_nomad
	description = "我在这里待得太久了！我想出去探索太空！"
	mood_change = -3

/datum/mood_event/moon_insanity
	description = "月亮在审判我，并发现我一无是处！！！"
	mood_change = -3
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/moon_insanity/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/spiritual))
		mood_change *= 2

/datum/mood_event/amulet_insanity
	description = "我看见了那道光，必须阻止它！"
	mood_change = -6
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/mallet_humiliation
	description = "被这么愚蠢的武器击中感觉相当丢脸……"
	mood_change = -3
	timeout = 10 SECONDS

///Wizard cheesy grand finale - what everyone but the wizard gets
/datum/mood_event/madness_despair
	description = "不配，不配，不配！！！"
	mood_change = -200
	special_screen_obj = "mood_despair"

/datum/mood_event/all_nighter
	description = "I didn't sleep at all last night. I'm exhausted."
	mood_change = -5

//Used by the Veteran Advisor trait job
/datum/mood_event/desentized
	description = "没有什么能比得上我过去所见的……"
	mood_change = -3
	special_screen_obj = "mood_desentized"

//Used for the psychotic brawling martial art, if the person is a pacifist.
/datum/mood_event/pacifism_bypassed
	description = "我不是故意伤害他们的！"
	mood_change = -20
	timeout = 10 MINUTES

//Gained when you're hit over the head with wrapping paper or cardboard roll
/datum/mood_event/bapped
	description = "噢……我的头，我现在感觉有点蠢！"
	mood_change = -1
	timeout = 3 MINUTES

/datum/mood_event/bapped/add_effects()
	// Felinids apparently hate being hit over the head with cardboard
	if(isfelinid(owner))
		mood_change = -2

/datum/mood_event/encountered_evil
	description = "我本不想相信，但世上确实存在真正邪恶的人。"
	mood_change = -1
	timeout = 1 MINUTES

/datum/mood_event/smoke_in_face
	description = "香烟的烟雾令人作呕。"
	mood_change = -3
	timeout = 30 SECONDS

/datum/mood_event/smoke_in_face/add_effects(param)
	if(HAS_TRAIT(owner, TRAIT_ANOSMIA))
		description = "香烟的烟雾令人不快。"
		mood_change = -1
	if(HAS_TRAIT(owner, TRAIT_SMOKER))
		description = "真的要把烟吹到我脸上吗？"
		mood_change = 0

/datum/mood_event/slots/loss
	description = "噢，真该死！"
	mood_change = -2
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_GAMING

/datum/mood_event/slots/loss/add_effects()
	if(HAS_PERSONALITY(owner, /datum/personality/gambler))
		mood_change = 0
		description = "噢，真该死。"
	if(HAS_PERSONALITY(owner, /datum/personality/industrious) || HAS_PERSONALITY(owner, /datum/personality/slacking/diligent))
		mood_change *= 1.5

/datum/mood_event/lost_control_of_life
	description = "我已经失去了对生活的掌控。"
	mood_change = -5
	timeout = 5 MINUTES

/datum/mood_event/empathetic_sad
	description = "看到悲伤的人让我也感到悲伤。"
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/misanthropic_sad
	description = "看到快乐的人让我感到不安。"
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/paranoid/one_on_one
	description = "我和某人独处——万一他们想杀我怎么办？"
	mood_change = -3
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/paranoid/large_group
	description = "周围人太多了——他们中的任何一个都可能想害我！"
	mood_change = -3
	event_flags = MOOD_EVENT_FEAR

/datum/mood_event/nt_disillusioned
	description = "我恨这家公司，以及它所代表的一切。"
	mood_change = -2

/datum/mood_event/disillusioned_revs_lost
	description = "革命失败了……真棒。"
	mood_change = -2
	timeout = 10 MINUTES

/datum/mood_event/loyalist_revs_win
	description = "革命成功了……这会损害季度利润的。"
	mood_change = -2
	timeout = 10 MINUTES

/datum/mood_event/slacking_off_diligent
	description = "我该回去工作了。"
	mood_change = -1

/datum/mood_event/unimaginative_patronage
	description = "感觉那钱白花了。"
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/unimaginative_framing
	description = "我本可以在那儿挂点更有用的东西。"
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/unimaginative_sculpting
	description = "感觉那些材料白费了。"
	mood_change = -2
	timeout = 5 MINUTES

/datum/mood_event/splattered_with_blood
	description = "呃，我刚刚被血糊了一身！"
	mood_change = -4
	timeout = 4 MINUTES

/datum/mood_event/splattered_with_blood/can_effect_mob(datum/mood/home, mob/living/who, ...)
	if(isvampire(who))
		return FALSE

	return ..()

/datum/mood_event/splattered_with_blood/add_effects(...)
	if(HAS_TRAIT(owner, TRAIT_CULT_HALO))
		mood_change = 2
		description = "血，血！几何学家会满意的。"
		return
	if(HAS_TRAIT(owner, TRAIT_MORBID) || HAS_TRAIT(owner, TRAIT_EVIL))
		mood_change = 0
		description = "我刚刚被血糊了一身。真有趣！"
		return
	if(IS_DESENSITIZED(owner))
		mood_change *= 0.5

/datum/mood_event/teetotal_hangover
	description = "多么可耻的表现！这就是沉溺于酒精的下场！"
	mood_change = -4
	timeout = 10 MINUTES

/datum/mood_event/normal_hangover
	description = "呃，昨晚真是够呛。"
	mood_change = 0
	timeout = 10 MINUTES

/datum/mood_event/jabbed_with_tester
	description = "老兄，被那玩意儿戳一下可真难受。"
	mood_change = -4
	timeout = 5 MINUTES

/datum/mood_event/gizmo_negative
	description = "I hear a voice whispering, and I don't like what it says."
	mood_change = -3
	timeout = 30 SECONDS
