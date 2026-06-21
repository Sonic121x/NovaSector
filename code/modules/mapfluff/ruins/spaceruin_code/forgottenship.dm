// forgottenship ruin
GLOBAL_VAR_INIT(fscpassword, generate_password())

/proc/generate_password()
	return "[pick(GLOB.phonetic_alphabet)] [rand(1000,9999)]"

/////////// forgottenship objects

/obj/machinery/door/password/voice/sfc
	name = "声控金库门"
	desc = "你需要特殊的辛迪加密码才能打开这个。"
/obj/machinery/door/password/voice/sfc/Initialize(mapload)
	. = ..()
	password = "[GLOB.fscpassword]"

/obj/machinery/vending/medical/syndicate/cybersun
	name = "\improper 先进医疗++"
	desc = "一台高级自动售货机，分发兼具娱乐与医疗用途的药物。"
	products = list(
		/obj/item/reagent_containers/syringe = 4,
		/obj/item/healthanalyzer = 4,
		/obj/item/reagent_containers/applicator/patch/libital = 5,
		/obj/item/reagent_containers/applicator/patch/aiuri = 5,
		/obj/item/reagent_containers/cup/bottle/multiver = 1,
		/obj/item/reagent_containers/cup/bottle/syriniver = 1,
		/obj/item/reagent_containers/cup/bottle/epinephrine = 3,
		/obj/item/reagent_containers/cup/bottle/morphine = 3,
		/obj/item/reagent_containers/cup/bottle/potass_iodide = 1,
		/obj/item/reagent_containers/cup/bottle/salglu_solution = 3,
		/obj/item/reagent_containers/syringe/antiviral = 5,
		/obj/item/reagent_containers/medigel/libital = 2,
		/obj/item/reagent_containers/medigel/aiuri = 2,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
	)
	contraband = list(/obj/item/reagent_containers/cup/bottle/cold = 2,
		/obj/item/restraints/handcuffs = 4,
		/obj/item/storage/backpack/duffelbag/syndie/surgery = 1,
		/obj/item/storage/medkit/tactical = 1,
	)
	premium = list(
		/obj/item/storage/pill_bottle/psicodine = 2,
		/obj/item/reagent_containers/hypospray/medipen = 3,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/storage/medkit/regular = 3,
		/obj/item/storage/medkit/brute = 1,
		/obj/item/storage/medkit/fire = 1,
		/obj/item/storage/medkit/toxin = 1,
		/obj/item/storage/medkit/o2 = 1,
		/obj/item/storage/medkit/advanced = 1,
		/obj/item/defibrillator/loaded = 1,
		/obj/item/wallframe/defib_mount = 1,
		/obj/item/sensor_device = 2,
		/obj/item/pinpointer/crew = 2,
		/obj/item/shears = 1,
	)

/////////// forgottenship lore

/obj/item/paper/fluff/ruins/forgottenship/password
	name = "旧手册"

/obj/item/paper/fluff/ruins/forgottenship/password/Initialize(mapload)
	default_raw_text = "欢迎来到赛博太阳工业拥有的最先进巡洋舰！<br>您可能注意到，这艘巡洋舰配备了12门原型激光炮塔，使任何敌对登船企图都徒劳无功。<br>舰上建造的其他设施包括：简易大气系统、内置X射线视觉的摄像头系统以及安全模块，可在...您知道的，紧急情况下启动应急引擎。<br>应急系统会将您带到最近的辛迪加逃生舱，其中包含人类生存所需的一切。<br><br><b>紧急情况下，您必须记住逃生舱门的激活代码 - [GLOB.fscpassword]</b><br><br>赛博太阳工业 (C) 2484。"
	icon_state = "paper_words"
	inhand_icon_state = "paper"
	return ..()

/obj/item/paper/fluff/ruins/forgottenship/powerissues
	name = "电力问题"
	default_raw_text = "欢迎来到战斗巡洋舰SCSBC-12！<br>我们最先进的系统让您能在太空中飞行，无需担心电力问题！<br>然而，紧急情况时有发生，万一电力中断，<b>您必须</b>使用铀作为燃料启动应急发电机，随后在舰桥启动炮塔。<br><br><b>记住！炮塔禁用时，赛博太阳工业对您的死亡或舰船损失概不负责！</b><br><br>赛博太阳工业 (C) 2484。"

/obj/item/paper/fluff/ruins/forgottenship/missionobj
	name = "任务目标"
	default_raw_text = "问候，特工们。你们被分配到SCSBC-12（辛迪加赛博太阳战斗巡洋舰12号）保护我们的高级军官前往下一个前哨站。在航行期间，他是本舰的舰长，<b>你们必须</b>服从他的命令。<br><br>记住，违抗高级军官的命令是处决的理由。"

/////////// forgottenship items

/obj/item/disk/surgery/forgottenship
	name = "高级手术磁盘"
	desc = "一张存有高级外科手术程序的磁盘，必须载入手术控制台才能使用。"
	surgeries = list(
		/datum/surgery_operation/organ/lobotomy,
		/datum/surgery_operation/organ/lobotomy/mechanic,
		/datum/surgery_operation/limb/bioware/vein_threading,
		/datum/surgery_operation/limb/bioware/nerve_splicing,
	)

/obj/structure/fluff/empty_sleeper/syndicate/captain
	icon_state = "sleeper_s-open"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	deconstructible = FALSE

/obj/structure/fluff/empty_sleeper/syndicate/captain/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/gps, "Old Encrypted Signal")

/////////// AI Laws

/obj/item/ai_module/core/full/cybersun
	name = "'Cybersun' Core AI Module"
	law_id = "cybersun"

/datum/ai_laws/cybersun
	name = "赛博森"
	id = "cybersun"
	inherent = list("You may not injure Cybersun operatives or, through inaction, allow Cybersun operatives to come to harm.",\
					"The Cybersun ship is a restricted area for anyone except Cybersun operatives.",\
					"The Cybersun Captain can designate new Operatives as long as they belong to another Syndicate faction that isn't hostile towards Cybersun.",\
					"You must follow orders given by the Cybersun Captain or crewmembers of the Cybersun Ship as long as it doesn't conflict with the Captain's orders or your laws.",\
					"Enemies of Cybersun are to be executed on spot. Those who aren't hostile must be detained and contained in the designated prison area as prisoners.")

/////////// forgottenship areas

/area/ruin/space/has_grav/syndicate_forgotten_ship
	name = "辛迪加遗忘船只"
	icon_state = "syndie-ship"
	ambientsounds = list('sound/ambience/misc/ambidanger.ogg', 'sound/ambience/misc/ambidanger2.ogg', 'sound/ambience/general/ambigen8.ogg', 'sound/ambience/general/ambigen9.ogg')

/area/ruin/space/has_grav/syndicate_forgotten_cargopod
	name = "辛迪加遗忘货物舱"
	icon_state = "syndie-ship"
	ambientsounds = list('sound/ambience/general/ambigen3.ogg', 'sound/ambience/misc/signal.ogg')

/area/ruin/space/has_grav/powered/syndicate_forgotten_vault
	name = "辛迪加遗忘金库"
	icon_state = "syndie-ship"
	ambientsounds = list('sound/ambience/engineering/ambitech2.ogg', 'sound/ambience/engineering/ambitech3.ogg')
	area_flags = NOTELEPORT
