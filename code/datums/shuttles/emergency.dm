#define EMAG_LOCKED_SHUTTLE_COST (CARGO_CRATE_VALUE * 50)

/datum/map_template/shuttle/emergency // NOVA EDIT OVERRIDE - OVERRIDDEN IN ADVANCED_SHUTTLES - shuttles.dm
	port_id = "emergency"
	name = "基础穿梭机模板（紧急）"
	prefix = "_maps/shuttles/emergency/"
	///assoc list of shuttle events to add to this shuttle on spawn (typepath = weight)
	var/list/events
	///pick all events instead of random
	var/use_all_events = FALSE
	///how many do we pick
	var/event_amount = 1
	///do we empty the event list before adding our events
	var/events_override = FALSE

/datum/map_template/shuttle/emergency/New()
	. = ..()
	if(!occupancy_limit && who_can_purchase)
		CRASH("The [name] needs an occupancy limit!")
	if(HAS_TRAIT(SSstation, STATION_TRAIT_SHUTTLE_SALE) && credit_cost > 0 && prob(15))
		var/discount_amount = round(rand(25, 80), 5)
		name += " ([discount_amount]% Discount!)"
		var/discount_multiplier = 100 - discount_amount
		credit_cost = ((credit_cost * discount_multiplier) / 100)

///on post_load use our variables to change shuttle events
/datum/map_template/shuttle/emergency/post_load(obj/docking_port/mobile/mobile)
	. = ..()
	if(!events)
		return
	if(events_override)
		mobile.event_list.Cut()
	if(use_all_events)
		for(var/path in events)
			mobile.add_shuttle_event(path)
			events -= path
	else
		for(var/i in 1 to event_amount)
			var/path = pick_weight(events)
			events -= path
			mobile.add_shuttle_event(path)

/datum/map_template/shuttle/emergency/backup
	suffix = "backup"
	name = "备用穿梭机"
	who_can_purchase = null

/datum/map_template/shuttle/emergency/construction
	suffix = "construction"
	name = "自建穿梭机套件"
	description = "For the enterprising shuttle engineer! The chassis will dock upon purchase, but launch will have to be authorized as usual via shuttle call. Comes stocked with construction materials."
	admin_notes = "No brig, no medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 5
	who_can_purchase = list(ACCESS_CAPTAIN, ACCESS_CE)
	occupancy_limit = "Flexible"

/datum/map_template/shuttle/emergency/constructionbig
	suffix = "constructionbig"
	name = "Build your own CRUISER kit"
	description = "This is the big brother of the construction kit, with more space for your shuttle-building ideas! The chassis will dock upon purchase, but launch will have to be authorized as usual via shuttle call. Comes stocked with construction materials."
	admin_notes = "No brig, no medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 30
	who_can_purchase = list(ACCESS_CAPTAIN, ACCESS_CE)
	occupancy_limit = "Flexible and more"

/datum/map_template/shuttle/emergency/asteroid
	suffix = "asteroid"
	name = "小行星站紧急穿梭机"
	description = "一款体面的中型穿梭机，最初用于运送纳米传讯的船员往返于其小行星带内的设施。"
	credit_cost = CARGO_CRATE_VALUE * 6
	occupancy_limit = "50"

/datum/map_template/shuttle/emergency/venture
	suffix = "venture"
	name = "冒险号紧急穿梭机"
	description = "一款中型穿梭机，适合那些喜欢宽敞腿部空间的人。"
	credit_cost = CARGO_CRATE_VALUE * 10
	occupancy_limit = "45"

/datum/map_template/shuttle/emergency/humpback
	suffix = "humpback"
	name = "座头鲸紧急穿梭机"
	description = "一艘经过改造的货运和打捞船，用于观光和旅游。设有酒吧。附带一份前往鲤鱼领地的两分钟度假计划。"
	credit_cost = CARGO_CRATE_VALUE * 12
	occupancy_limit = "30"
	events = list(
		/datum/shuttle_event/simple_spawner/carp/friendly = 10,
		/datum/shuttle_event/simple_spawner/carp/friendly_but_no_personal_space = 2,
		/datum/shuttle_event/simple_spawner/carp = 2,
		/datum/shuttle_event/simple_spawner/carp/magic = 1,
	)

/datum/map_template/shuttle/emergency/bar
	suffix = "bar"
	name = "紧急逃生酒吧"
	description = "特色包括有知觉的酒吧员工（一个酒保机器人和一个女酒保）、卫生间、供主管使用的优质休息室，以及一张大型聚会桌。"
	admin_notes = "Bardrone and Barmaid have TRAIT_GODMODE (basically invincibility), will be automatically sentienced by the fun balloon at 60 seconds before arrival. \
	Has medical facilities."
	credit_cost = CARGO_CRATE_VALUE * 10
	occupancy_limit = "30"

/datum/map_template/shuttle/emergency/pod
	suffix = "pod"
	name = "紧急逃生舱"
	description = "我们没料到撤离会这么快。我们手头只有两个逃生舱可用。"
	admin_notes = "For player punishment."
	who_can_purchase = null
	occupancy_limit = "10"

/datum/map_template/shuttle/emergency/russiafightpit
	suffix = "russiafightpit"
	name = "母亲俄罗斯在流血"
	description = "这系一款高品质穿梭机，没错。座位多，空间大，设备齐全！甚至还有娱乐设施！比如很多酒水，还有一个供醉酒船员找乐子的格斗场！如果格斗场还不够好玩，直接按下放熊按钮就行。别担心，熊受过训练不会逃出格斗坑，所以只要没人蠢到或醉到把门打开，就绝对安全。尽量别让阿西莫夫小屁孩机器人毁了大家的兴致！"
	admin_notes = "Includes a small variety of weapons. And bears. Only captain-access can release the bears. Bears won't smash the windows themselves, but they can escape if someone lets them."
	credit_cost = CARGO_CRATE_VALUE * 10 // While the shuttle is rusted and poorly maintained, trained bears are costly.
	occupancy_limit = "40"

/datum/map_template/shuttle/emergency/meteor
	suffix = "meteor"
	name = "绑着引擎的小行星"
	description = "一个被掏空的小行星，上面绑着引擎，掏空过程使其极难被劫持，但成本高昂。由于其尺寸和操控困难，这艘穿梭机可能会损坏对接区域。"
	admin_notes = "This shuttle will likely crush escape, killing anyone there."
	credit_cost = CARGO_CRATE_VALUE * 30
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)
	occupancy_limit = "CONDEMNED"

/datum/map_template/shuttle/emergency/monastery
	suffix = "monastery"
	name = "宏伟企业修道院"
	description = "这座宏伟的宗教建筑原本是为一座公共空间站建造的，但由于预算削减，现在只要合适的……捐赠，就能作为逃生穿梭机使用。由于其庞大的尺寸和冷酷的所有者，这艘穿梭机可能会造成附带损害。"
	admin_notes = "WARNING: This shuttle WILL destroy a fourth of the station, likely picking up a lot of objects with it."
	emag_only = TRUE
	credit_cost = EMAG_LOCKED_SHUTTLE_COST * 1.8
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 5)
	occupancy_limit = "70"
	who_can_purchase = null //NOVA EDIT ADDITION

/datum/map_template/shuttle/emergency/luxury
	suffix = "luxury"
	name = "豪华穿梭机"
	description = "一艘豪华的金色穿梭机，配有室内游泳池。每位希望登机的船员必须携带500信用点，可用现金或矿物币支付。"
	extra_desc = "This shuttle costs 500 credits to board."
	admin_notes = "Due to the limited space for non paying crew, this shuttle may cause a riot."
	emag_only = TRUE
	credit_cost = EMAG_LOCKED_SHUTTLE_COST
	occupancy_limit = "75"

/datum/map_template/shuttle/emergency/medisim
	suffix = "medisim"
	name = "中世纪现实模拟穹顶"
	description = "一个最先进的模拟穹顶，装载到了你的穿梭机上！观看并嘲笑人类在迈向星辰大海之前是多么渺小。保证至少有40%的历史准确性。"
	prerequisites = "A special holodeck simulation must be loaded before this shuttle can be purchased."
	admin_notes = "Ghosts can spawn in and fight as knights or archers. The CTF auto restarts, so no admin intervention necessary."
	credit_cost = 20000
	occupancy_limit = "30"

/datum/map_template/shuttle/emergency/medisim/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_MEDISIM]

/datum/map_template/shuttle/emergency/discoinferno
	suffix = "discoinferno"
	name = "迪斯科地狱"
	description = "这是纳米传讯员工数百年等离子体研究的辉煌成果。这就是你在这里的原因。登上去，像着火一样跳舞吧，燃烧吧宝贝，燃烧！"
	admin_notes = "Flaming hot. The main area has a dance machine as well as plasma floor tiles that will be ignited by players every single time."
	emag_only = TRUE
	credit_cost = EMAG_LOCKED_SHUTTLE_COST
	occupancy_limit = "10"

/datum/map_template/shuttle/emergency/arena
	suffix = "arena"
	name = "竞技场"
	description = "船员必须穿过一个异界竞技场才能登上这艘穿梭机。预计会有大量伤亡。"
	prerequisites = "The source of the Bloody Signal must be tracked down and eliminated to unlock this shuttle."
	admin_notes = "RIP AND TEAR."
	credit_cost = CARGO_CRATE_VALUE * 20
	occupancy_limit = "1/2"
	/// Whether the arena z-level has been created
	var/arena_loaded = FALSE

/datum/map_template/shuttle/emergency/arena/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_BUBBLEGUM]

/datum/map_template/shuttle/emergency/arena/post_load(obj/docking_port/mobile/M)
	. = ..()
	if(!arena_loaded)
		arena_loaded = TRUE
		var/datum/map_template/arena/arena_template = new()
		arena_template.load_new_z()

/datum/map_template/arena
	name = "竞技场"
	mappath = "_maps/templates/the_arena.dmm"

/datum/map_template/shuttle/emergency/birdboat
	suffix = "birdboat"
	name = "鸟船空间站紧急穿梭机"
	description = "虽然尺寸有点偏小，但这艘穿梭机功能齐全，这比它被委托建造时所依据的空间站原型要好得多。"
	credit_cost = CARGO_CRATE_VALUE * 2
	occupancy_limit = "25"

/datum/map_template/shuttle/emergency/box
	suffix = "box"
	name = "箱式空间站紧急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "这是紧急撤离的黄金标准，这个久经考验的可靠设计配备了船员安全返航所需的一切。"
	occupancy_limit = "45"

/datum/map_template/shuttle/emergency/donut
	suffix = "donut"
	name = "甜甜圈空间站紧急穿梭机"
	description = "这是任何涉及空间站形状的粗俗笑话的完美矛头，这艘穿梭机支持一个独立的囚犯收容室和一个紧凑的医疗翼。"
	admin_notes = "Has airlocks on both sides of the shuttle and will probably intersect near the front on some stations that build past departures."
	credit_cost = CARGO_CRATE_VALUE * 5
	occupancy_limit = "60"

/datum/map_template/shuttle/emergency/clown
	suffix = "clown"
	name = "Snappop(tm)!"
	description = "Hey kids and grownups! \
	Are you bored of DULL and TEDIOUS shuttle journeys after you're evacuating for probably BORING reasons. Well then order the Snappop(tm) today! \
	We've got fun activities for everyone, an all access cockpit, and no boring security brig! Boo! Play dress up with your friends! \
	Collect all the bedsheets before your neighbour does! Check if the AI is watching you with our patent pending \"Peeping Tom AI Multitool Detector\" or PEEEEEETUR for short. \
	Have a fun ride!"
	admin_notes = "Brig is replaced by anchored greentext book surrounded by lavaland chasms, stationside door has been removed to prevent accidental dropping. No brig."
	credit_cost = CARGO_CRATE_VALUE * 16
	occupancy_limit = "HONK"

/datum/map_template/shuttle/emergency/cramped
	suffix = "cramped"
	name = "安全运输船5号（STV5）"
	description = "Well, looks like CentCom only had this ship in the area, they probably weren't expecting you to need evac for a while. \
	Probably best if you don't rifle around in whatever equipment they were transporting. I hope you're friendly with your coworkers, because there is very little space in this thing.\n\
	\n\
	Contains contraband armory guns, maintenance loot, and abandoned crates!"
	admin_notes = "Due to origin as a solo piloted secure vessel, has an active GPS onboard labeled STV5. Has roughly as much space as Hi Daniel, except with explosive crates."
	occupancy_limit = "5"

/datum/map_template/shuttle/emergency/meta
	suffix = "meta"
	name = "元空间站紧急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 8
	description = "一艘相当标准的穿梭机，虽然比箱式空间站型号更大，装备也稍好一些。"
	occupancy_limit = "45"

/datum/map_template/shuttle/emergency/kilo
	suffix = "kilo"
	name = "千吨空间站紧急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 10
	description = "一艘功能齐全的穿梭机，包括完整的医务室、存储设施和常规便利设施。"
	occupancy_limit = "55"

/datum/map_template/shuttle/emergency/mini
	suffix = "mini"
	name = "微型空间站紧急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 2
	description = "尽管名字叫“迷你”，但这艘穿梭机实际上只比标准型略小一点，仍然配有禁闭室和医疗舱。"
	occupancy_limit = "35"

/datum/map_template/shuttle/emergency/tram
	suffix = "tram"
	name = "电车空间站紧急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 4
	description = "一辆在太空中的火车，呜呼！"
	occupancy_limit = "35"

/datum/map_template/shuttle/emergency/birdshot
	suffix = "birdshot"
	name = "鸟弹站应急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 2
	description = "我们特意为你从封存中把它拖了出来！"
	occupancy_limit = "40"


/datum/map_template/shuttle/emergency/emergency_catwalk
	suffix = "catwalk"
	name = "猫步站应急穿梭机"
	credit_cost = CARGO_CRATE_VALUE * 5
	description = "一艘标准尺寸的穿梭机，配有医疗舱和禁闭室，以及一个抬高的驾驶舱。"
	occupancy_limit = "40"

/datum/map_template/shuttle/emergency/wawa
	suffix = "wawa"
	name = "Wawa 备用应急穿梭机"
	description = "由于资金部门最近的一次文书错误，大量资金流向了蜥蜴毛绒玩具。由于成本问题，纳米传讯提供了一辆附近的垃圾车作为替代。最好学会如何共享位置。"
	credit_cost = CARGO_CRATE_VALUE * 6
	occupancy_limit = "25"

/datum/map_template/shuttle/emergency/scrapheap
	suffix = "scrapheap"
	name = "备用疏散飞船 \"废料堆挑战\""
	credit_cost = CARGO_CRATE_VALUE * -18
	description = "同志！我们看你好像手头有点紧，是吧？如果你有金钱问题，钱很少，我们正在找好穿梭机，紧急穿梭机。你拿上本星区最好的穿梭机，我们拿你的，你拿钱，对吧？请别靠在窗户上，脆得像中国瓷器一样。-伊万"
	admin_notes = "A randomly assembled, modular abomination. May have no functional medbay, sections missing, and some very fragile windows. Surprisingly airtight. When bought, gives a good influx of money, but can only be bought if the budget is literally 0 credits."
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)
	occupancy_limit = "30"
	prerequisites = "This shuttle is only offered for purchase when the station is low on funds."

/datum/map_template/shuttle/emergency/scrapheap/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_SCRAPHEAP]

/obj/modular_map_root/scrapheapchallenge
	config_file = "strings/modular_maps/emergency_scrapheap.toml"

/datum/map_template/shuttle/emergency/narnar
	suffix = "narnar"
	name = "穿梭机 667"
	description = "看起来这艘穿梭机可能在前往空间站的途中迷失在了星辰间的黑暗里。我们最好别深究这些尸体都是从哪儿来的。"
	admin_notes = "Contains real cult ruins, mob eyeballs, and inactive constructs. Cult mobs will automatically be sentienced by fun balloon. \
	Cloning pods in 'medbay' area are showcases and nonfunctional."
	prerequisites = "A mysterious cult rune will need to be banished before this shuttle can be summoned."
	credit_cost = 6667 ///The joke is the number so no defines
	occupancy_limit = "666"

/datum/map_template/shuttle/emergency/narnar/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_NARNAR]

/datum/map_template/shuttle/emergency/pubby
	suffix = "pubby"
	name = "帕比站应急穿梭机"
	description = "一辆在太空中的火车！配备有一等舱、二等舱、禁闭室和储物区。"
	admin_notes = "Choo choo motherfucker!"
	credit_cost = CARGO_CRATE_VALUE * 2
	occupancy_limit = "50"

/datum/map_template/shuttle/emergency/cere
	suffix = "cere"
	name = "塞雷站应急穿梭机"
	description = "The large, beefed-up version of the box-standard shuttle. Includes an expanded brig, fully stocked medbay, enhanced cargo storage with mech chargers, \
	an engine room stocked with various supplies, and a crew capacity of 80+ to top it all off. Live large, live Cere."
	admin_notes = "Seriously big, even larger than the Delta shuttle."
	credit_cost = CARGO_CRATE_VALUE * 20
	occupancy_limit = "110"

/datum/map_template/shuttle/emergency/supermatter
	suffix = "supermatter"
	name = "超分形巨型穿梭机"
	description = "\"I dunno, this seems kinda needlessly complicated.\"\n\
	\"This shuttle has very a very high safety record, according to CentCom Officer Cadet Yins.\"\n\
	\"Are you sure?\"\n\
	\"Yes, it has a safety record of N-A-N, which is apparently larger than 100%.\""
	admin_notes = "Supermatter that spawns on shuttle is special anchored 'hugbox' supermatter that cannot take damage and does not take in or emit gas. \
	Outside of admin intervention, it cannot explode. \
	It does, however, still dust anything on contact, emits high levels of radiation, and induce hallucinations in anyone looking at it without protective goggles. \
	Emitters spawn powered on, expect admin notices, they are harmless."
	emag_only = TRUE
	credit_cost = EMAG_LOCKED_SHUTTLE_COST
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)
	occupancy_limit = "15"

/datum/map_template/shuttle/emergency/imfedupwiththisworld
	suffix = "imfedupwiththisworld"
	name = "哦，嗨，丹尼尔"
	description = "How was space work today? Oh, pretty good. We got a new space station and the company will make a lot of money. What space station? I cannot tell you; it's space confidential. \
	Aw, come space on. Why not? No, I can't. Anyway, how is your space roleplay life?"
	admin_notes = "Tiny, with a single airlock and wooden walls. What could go wrong?"
	emag_only = TRUE
	credit_cost = EMAG_LOCKED_SHUTTLE_COST
	movement_force = list("KNOCKDOWN" = 3, "THROW" = 2)
	occupancy_limit = "5"

/datum/map_template/shuttle/emergency/goon
	suffix = "goon"
	name = "NES 港"
	description = "纳米传讯紧急穿梭机港口（简称NES Port）是用于其他不太知名的纳米传讯设施的穿梭机，内部更开阔以容纳更多人群，但船上的穿梭机设施较少。"
	credit_cost = CARGO_CRATE_VALUE
	occupancy_limit = "40"

/datum/map_template/shuttle/emergency/rollerdome
	suffix = "rollerdome"
	name = "皮特叔叔的轮滑馆"
	description = "Developed by a member of Nanotrasen's R&D crew that claims to have travelled from the year 2028. \
	He says this shuttle is based off an old entertainment complex from the 1990s, though our database has no records on anything pertaining to that decade."
	admin_notes = "ONLY NINETIES KIDS REMEMBER. Uses the fun balloon and drone from the Emergency Bar."
	credit_cost = CARGO_CRATE_VALUE * 30
	occupancy_limit = "5"

/datum/map_template/shuttle/emergency/basketball
	suffix = "bballhooper"
	name = "篮球运动员体育馆"
	description = "Hoop, man, hoop! Get your shooting game on with this sleek new basketball stadium! Do keep in mind that several other features \
	that you may expect to find common-place on other shuttles aren't present to give you this sleek stadium at an affordable cost. \
	It also wasn't manufactured to deal with the form-factor of some of your stations... good luck with that."
	admin_notes = "A larger shuttle built around a basketball stadium: entirely impractical but just a complete blast!"
	credit_cost = CARGO_CRATE_VALUE * 10
	occupancy_limit = "30"

/datum/map_template/shuttle/emergency/wabbajack
	suffix = "wabbajack"
	name = "NT 轻子紫罗兰号"
	description = "The research team based on this vessel went missing one day, and no amount of investigation could discover what happened to them. \
	The only occupants were a number of dead rodents, who appeared to have clawed each other to death. \
	Needless to say, no engineering team wanted to go near the thing, and it's only being used as an Emergency Escape Shuttle because there is literally nothing else available."
	admin_notes = "If the crew can solve the puzzle, they will wake the wabbajack statue. It will likely not end well. There's a reason it's boarded up. Maybe they should have just left it alone."
	credit_cost = CARGO_CRATE_VALUE * 30
	occupancy_limit = "30"
	prerequisites = "This shuttle requires an act of magical polymorphism to occur before it can be purchased."

/datum/map_template/shuttle/emergency/wabbajack/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_WABBAJACK]

/datum/map_template/shuttle/emergency/omega
	suffix = "omega"
	name = "奥米加站应急穿梭机"
	description = "这款穿梭机尺寸较小，设计现代，适合那些喜欢更舒适环境，同时仍能伸展腿脚的船员。"
	credit_cost = CARGO_CRATE_VALUE * 2
	occupancy_limit = "30"

/datum/map_template/shuttle/emergency/cruise
	suffix = "cruise"
	name = "NTSS 独立号"
	description = "Ordinarily reserved for special functions and events, the Cruise Shuttle Independence can bring a summery cheer to your next station evacuation for a 'modest' fee!"
	admin_notes = "This motherfucker is BIG. You might need to force dock it."
	credit_cost = CARGO_CRATE_VALUE * 100
	occupancy_limit = "80"

/datum/map_template/shuttle/emergency/monkey
	suffix = "nature"
	name = "动态环境交互穿梭机"
	description = "一艘大型穿梭机，中心有一个生机勃勃的生物穹顶。和猴子们一起嬉戏吧！（额外的猴子存放在舰桥上。）"
	admin_notes = "Pretty freakin' large, almost as big as Raven or Cere. Exercise caution with it."
	credit_cost = CARGO_CRATE_VALUE * 16
	occupancy_limit = "45"

/datum/map_template/shuttle/emergency/casino
	suffix = "casino"
	name = "幸运头奖赌场穿梭机"
	description = "一个豪华的赌场，里面塞满了开启新赌博成瘾所需的一切！"
	admin_notes = "The ship is a bit chunky, so watch where you park it."
	credit_cost = 7777
	occupancy_limit = "85"

/datum/map_template/shuttle/emergency/shadow
	suffix = "shadow"
	name = "NTSS 暗影号"
	description = "保证能让你快速到达某处。凭借定制的等离子引擎，这艘穿梭机能比其他任何穿梭机都更快地让你远离危险！"
	admin_notes = "The aft of the ship has a plasma tank that starts ignited. May get released by crew. The plasma windows next to the engine heaters will also erupt into flame, and also risk getting released by crew."
	credit_cost = CARGO_CRATE_VALUE * 50
	occupancy_limit = "40"

/datum/map_template/shuttle/emergency/fish
	suffix = "fish"
	name = "垂钓者之选应急穿梭机"
	description = "舍弃了“储物空间”和“充足座位”等便利设施，换来一个适合钓鱼的人工环境，外加充足的补给（也是用来钓鱼的）。"
	admin_notes = "There's a chasm in it, it has railings but that won't stop determined players."
	credit_cost = CARGO_CRATE_VALUE * 10
	occupancy_limit = "35"

/datum/map_template/shuttle/emergency/lance
	suffix = "lance"
	name = "长矛号船员疏散系统"
	description = "由纳米传讯最顶尖的穿梭机工程团队打造的全新穿梭机，旨在战术性地撞击被摧毁的空间站，同时清除威胁并营救船员！请小心避开其行进路线。"
	admin_notes = "WARNING: This shuttle is designed to crash into the station. It has turrets, similar to the raven."
	credit_cost = CARGO_CRATE_VALUE * 70
	occupancy_limit = "50"

/datum/map_template/shuttle/emergency/tranquility
	suffix = "tranquility"
	name = "宁静号转移穿梭机"
	description = "一艘大型穿梭机，覆盖着植物和舒适的休息区。是结束一个平静班次的完美方式。"
	admin_notes = "it's pretty big, and comfy. Be careful when placing it down!"
	credit_cost = CARGO_CRATE_VALUE * 25
	occupancy_limit = "40"

/datum/map_template/shuttle/emergency/hugcage
	suffix = "hugcage"
	name = "拥抱放松穿梭机"
	description = "一艘小巧舒适的穿梭机，为疲惫或敏感的太空人准备了充足的床位，还有一个用于枕头大战的箱子。"
	admin_notes = "Has a sentience fun balloon for pets."
	credit_cost = CARGO_CRATE_VALUE * 16
	occupancy_limit = "20"

/datum/map_template/shuttle/emergency/fame
	suffix = "fame"
	name = "名人堂穿梭机"
	description = "一艘宏伟的穿梭机，铺着通往名人堂的红地毯。你有资格站在最优秀的太空人之中吗？"
	admin_notes = "Designed around persistence from memories, trophies, photos, and statues."
	credit_cost = CARGO_CRATE_VALUE * 25
	occupancy_limit = "55"

/datum/map_template/shuttle/emergency/delta
	suffix = "delta"
	name = "德尔塔站紧急穿梭机"
	description = "为大型空间站准备的大型穿梭机，可以舒适地容纳你所有的人口过剩和拥挤需求。配备所有设施及额外设备。"
	admin_notes = "Go big or go home."
	credit_cost = CARGO_CRATE_VALUE * 15
	occupancy_limit = "75"

/datum/map_template/shuttle/emergency/northstar
	suffix = "northstar"
	name = "北极星紧急穿梭机"
	description = "A rugged shuttle meant for long-distance transit from the tips of the frontier to Central Command and back. \
	moderately comfortable and large, but cramped."
	credit_cost = CARGO_CRATE_VALUE * 14
	occupancy_limit = "55"

/datum/map_template/shuttle/emergency/nebula
	suffix = "nebula"
	name = "星云站紧急穿梭机"
	description = "AAn excellent luxury shuttle for transporting a large number of passengers. \
	It is richly equipped with bushes and free oxygen"
	credit_cost = CARGO_CRATE_VALUE * 18
	occupancy_limit = "80"

/datum/map_template/shuttle/emergency/raven
	suffix = "raven"
	name = "中央司令部渡鸦号巡洋舰"
	description = "The CentCom Raven Cruiser is a former high-risk salvage vessel, now repurposed into an emergency escape shuttle. \
	Once first to the scene to pick through warzones for valuable remains, it now serves as an excellent escape option for stations under heavy fire from outside forces. \
	This escape shuttle boasts shields and numerous anti-personnel turrets guarding its perimeter to fend off meteors and enemy boarding attempts."
	admin_notes = "Comes with turrets that will target anything without the neutral faction (nuke ops, xenos etc, but not pets)."
	credit_cost = CARGO_CRATE_VALUE * 60
	occupancy_limit = "CLASSIFIED"

/datum/map_template/shuttle/emergency/zeta
	suffix = "zeta"
	name = "Tr%nPo2r& Z3TA"
	description = "A glitch appears on your monitor, flickering in and out of the options laid before you. \
	It seems strange and alien..."
	prerequisites = "You will need to research special alien technology to access the signal."
	admin_notes = "Has alien surgery tools, and a void core that provides unlimited power."
	credit_cost = CARGO_CRATE_VALUE * 16
	occupancy_limit = "xxx"

/datum/map_template/shuttle/emergency/zeta/prerequisites_met()
	return SSshuttle.shuttle_purchase_requirements_met[SHUTTLE_UNLOCK_ALIENTECH]

#undef EMAG_LOCKED_SHUTTLE_COST
