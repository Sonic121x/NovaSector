/**
 * # Paperwork
 *
 * Paperwork documents that can be stamped by their associated stamp to provide a bonus to cargo.
 *
 * Paperwork documents are a cargo item meant to provide the opportunity to make money.
 * Each piece of paperwork has its own associated stamp it needs to be stamped with. Selling a
 * properly stamped piece of paperwork will provide a cash bonus to the cargo budget. If a document is
 * not properly stamped it will instead drain a small stipend from the cargo budget.
 *
 */

/obj/item/paperwork
	name = "文书文件"
	desc = "一堆杂乱无章的文件、研究成果和调查发现。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_part"
	inhand_icon_state = "paper"
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_range = 1
	throw_speed = 1
	layer = MOB_LAYER
	///The stamp overlay, used to show that the paperwork is complete without making a bunch of sprites
	var/mutable_appearance/stamp_overlay
	///The specific stamp icon to be overlaid on the paperwork
	var/stamp_icon = "paper_stamp-void"
	///The stamp needed to "complete" this form.
	var/stamp_requested = /obj/item/stamp/void
	///Has the paperwork been properly stamped
	var/stamped = FALSE
	///The path to the job of the associated paperwork form
	var/stamp_job
	///Used to store the bonus text that displays when the paperwork's associated role reads it
	var/detailed_desc

/obj/item/paperwork/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("<i>当你翻阅这些文件时，你慢慢开始拼凑出你正在阅读的内容。</i>")

/obj/item/paperwork/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return

	if(stamped || !istype(attacking_item, /obj/item/stamp))
		return

	if(istype(attacking_item, stamp_requested))
		add_stamp()
		to_chat(user, span_notice("你快速翻阅文件，直到找到一个写着'在此盖章'的字段，然后完成了文书工作。"))
		return TRUE
	var/datum/action/item_action/chameleon/change/stamp/stamp_action = locate() in attacking_item.actions
	if(isnull(stamp_action))
		to_chat(user, span_warning("你在文件中翻找能使用[attacking_item]的地方，但什么也没找到。"))
		return TRUE

	to_chat(user, span_notice("[attacking_item] 变形为合适的印章，你用它完成了文书工作。"))
	stamp_action.update_look(stamp_requested)
	add_stamp()
	return TRUE

/obj/item/paperwork/examine_more(mob/user)
	. = ..()

	if(ishuman(user))
		var/mob/living/carbon/human/viewer = user
		if(istype(viewer.mind?.assigned_role, stamp_job)) //Examining the paperwork as the proper job gets you some bonus details
			. += detailed_desc
		else
			if(stamped)
				. += span_info("看起来这些文件已经盖过章了。现在可以将其交还给中央司令部了。")
			else
				var/datum/job/stamp_title = stamp_job
				var/title = initial(stamp_title.title)
				. += span_info("试图阅读它让你头晕目眩。从你能辨认出的几个词来看，这似乎是[title]的职责。")

/obj/item/paperwork/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 开始辱骂文书工作和官僚主义的低效。看起来 [user.p_theyre()] 试图自杀！"))

	var/obj/item/paper/new_paper = new /obj/item/paper(get_turf(src))
	var/turf/turf_to_throw_at = get_ranged_target_turf(get_turf(src), pick(GLOB.alldirs))
	new_paper.throw_at(turf_to_throw_at, 2)

	var/obj/item/bodypart/BP = user.get_bodypart(pick(BODY_ZONE_HEAD))
	if(BP?.dismember())
		new_paper.visible_message(span_alert("这[src]发射出一张纸，瞬间切掉了[user]的头！"))
	else
		user.visible_message(span_suicide("[user] 惊慌失措，开始窒息而死！"))
		return OXYLOSS

	return MANUAL_SUICIDE

/**
 * Adds the stamp overlay and sets "stamped" to true
 *
 * Adds the stamp overlay to a piece of paperwork, and sets "stamped" to true.
 * Handled as a proc so that an object may be marked as "stamped" even when a stamp isn't present (like the photocopier)
 */
/obj/item/paperwork/proc/add_stamp()
	stamp_overlay = mutable_appearance('icons/obj/service/bureaucracy.dmi', stamp_icon)
	add_overlay(stamp_overlay)
	stamped = TRUE

/**
 * Copies the requested stamp, associated job, and associated icon of a given paperwork type
 *
 * Copies the stamp/job related info of a given paperwork type to the object
 * Used to mutate photocopied/ancient paperwork into behaving like their subtype counterparts without the extra details
 */
/obj/item/paperwork/proc/copy_stamp_info(obj/item/paperwork/paperwork_type)
	stamp_requested = initial(paperwork_type.stamp_requested)
	stamp_job = initial(paperwork_type.stamp_job)
	stamp_icon = initial(paperwork_type.stamp_icon)

//HEAD OF STAFF DOCUMENTS

/obj/item/paperwork/cargo
	stamp_requested = /obj/item/stamp/head/qm
	stamp_job = /datum/job/quartermaster
	stamp_icon = "paper_stamp-qm"

/obj/item/paperwork/cargo/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("这些文件是一堆混乱的货运订单文书。这些文件的排序方式毫无章法可言。")
	detailed_desc += span_info("看起来，除了一个高优先级的第二引擎请求外，这里没什么不寻常的。")
	detailed_desc += span_info("‘优先请求原因’一栏被涂掉了，但页边空白处有个注释写着‘我们只是想试试两个引擎，别担心’。")
	detailed_desc += span_info("尽管文件杂乱无章，但它们都填写得当。你或许应该盖个章。")

/obj/item/paperwork/security
	stamp_requested = /obj/item/stamp/head/hos
	stamp_job = /datum/job/head_of_security
	stamp_icon = "paper_stamp-hos"

/obj/item/paperwork/security/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("这叠文件与邻近设施正在处理的一起民事案件有关。")
	detailed_desc += span_info("文件要求你审阅由空间站律师提交的行为报告。")
	detailed_desc += span_info("案件档案详述了对空间站安保部门的指控，包括行为不当、骚扰，以-")
	detailed_desc += span_info("真是一派胡言，安保团队显然只是在做他们必须做的事。你或许应该盖个章。")

/obj/item/paperwork/service
	stamp_requested = /obj/item/stamp/head/hop
	stamp_job = /datum/job/head_of_personnel
	stamp_icon = "paper_stamp-hop"

/obj/item/paperwork/service/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("你开始浏览文件。这是一份标准的纳米传讯 NT-435Z3 表格，用于向中央指挥部提出请求。")
	detailed_desc += span_info("看起来附近一个空间站提交了一份最高优先级的煤炭请求，数量似乎相当离谱。")
	detailed_desc += span_info(" The reason listed for the request seems to be hastily filled in -- 'Seeking alternative methods to power the station.'")
	detailed_desc += span_info("像这样的最高优先级请求不容小觑。你或许应该盖个章。")

/obj/item/paperwork/medical
	stamp_requested = /obj/item/stamp/head/cmo
	stamp_job = /datum/job/chief_medical_officer
	stamp_icon = "paper_stamp-cmo"

/obj/item/paperwork/medical/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("这叠文件似乎是来自附近空间站的医疗报告，详细记录了对一种未知外星生物的尸检。")
	detailed_desc += span_info("直接翻到报告末尾，发现样本是空间站酒保的宠物猴子。")
	detailed_desc += span_info("样本在一次‘与引擎无关的事件’中暴露于辐射，导致其形态发生变异。")
	detailed_desc += span_info("无论如何，尸检结果看起来可能有用。你或许应该盖个章。")


/obj/item/paperwork/engineering
	stamp_requested = /obj/item/stamp/head/ce
	stamp_job = /datum/job/chief_engineer
	stamp_icon = "paper_stamp-ce"

/obj/item/paperwork/engineering/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("这些文件是来自邻近空间站的电力输出报告。它详细记录了空间站在一个典型班次期间的电力输出和其他工程数据。")
	detailed_desc += span_info("检查日志时，你注意到能量输出和引擎温度急剧飙升，随后不久，周围部门似乎因未知力量而失压。")
	detailed_desc += span_info("显然，空间站的工程部门当时正在测试一个实验性的引擎配置，并不得不利用附近房间的空气来帮助冷却引擎。完全如此。")
	detailed_desc += span_info("该死，这玩意儿真够厉害的。你大概应该给它盖个章。")

/obj/item/paperwork/research
	stamp_requested = /obj/item/stamp/head/rd
	stamp_job = /datum/job/research_director
	stamp_icon = "paper_stamp-rd"

/obj/item/paperwork/research/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("文件详细记录了在附近空间站进行的一次标准军械测试结果。")
	detailed_desc += span_info("继续往下读，你发现结果有些不对劲——震中位置似乎不对。")
	detailed_desc += span_info("如果你的计算没错，这次爆炸并非发生在空间站的军械测试场，而是发生在空间站的引擎室。")
	detailed_desc += span_info("尽管如此，它们仍然是完全可用的测试结果。你大概应该给它盖个章。")

/obj/item/paperwork/captain
	stamp_requested = /obj/item/stamp/head/captain
	stamp_job = /datum/job/captain
	stamp_icon = "paper_stamp-cap"

/obj/item/paperwork/captain/Initialize(mapload)
	. = ..()

	detailed_desc += span_info("这些文件是来自附近空间站舰长办公桌的一份未签名信函。")
	detailed_desc += span_info("看起来是一份标准的报到信息，报告称空间站正以最佳效率运行。")
	detailed_desc += span_info(" The message repeatedly asserts that the engine is functioning 'perfectly fine' and is generating 'buttloads' of power.")
	detailed_desc += span_info("一切都没问题。你大概应该给它盖个章。")

//Photocopied paperwork. These are created when paperwork, whether stamped or otherwise, is printed. If it is stamped, it can be sold to cargo at the risk of the paperwork not being accepted (which takes a small fee from cargo).
//If it is unstamped it will lose you money like normal, unless it has been marked with a VOID stamp
/obj/item/paperwork/photocopy
	name = "复印的文书文件"
	desc = "一堆更加杂乱无章的复印文件和文书。这些玩意儿复印的顺序对吗？"
	stamp_icon = "paper_stamp-pc"
	/// Has the photocopy been marked with a "void" stamp. Used to prevent documents from draining money if they somehow make their way to cargo.
	var/voided = FALSE

/obj/item/paperwork/photocopy/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("这份文书的打印效果让它几乎完全无法阅读。")

/obj/item/paperwork/photocopy/examine_more(mob/user)
	. = ..()

	if(stamped)
		if(voided)
			. += span_notice("It looks like it's been marked as 'VOID' on the front. It's unlikely that anyone will accept these now.")
		else
			. += span_notice("正面的印章似乎被弄脏且褪色了。中央指挥部大概还是会接受这些的，对吧？")
	else
		. += span_notice("这些看起来只是原始文件的复印件。")

/obj/item/paperwork/photocopy/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stamp/void) && !stamped && !voided)
		to_chat(user, span_notice("你将[attacking_item]牢牢地按在了文件正面。"))
		stamp_overlay = mutable_appearance('icons/obj/service/bureaucracy.dmi', "paper_stamp-void")
		add_overlay(stamp_overlay)
		voided = TRUE
		stamped = TRUE //It won't get you any money, but it also can't LOSE you money now.
		return

	return ..()

//Ancient paperwork is a subtype of paperwork, meant to be used for any paperwork not spawned by the event.
//It doesn't have any of the flavor text that the event ones spawn with.

/obj/item/paperwork/ancient
	name = "古老的文书"
	desc = "一堆布满灰尘、丑陋不堪的纸片。你认不出里面提到的任何一个名字、日期或主题。这些玩意儿有多古老了？"

/obj/item/paperwork/ancient/Initialize(mapload)
	. = ..()

	detailed_desc = span_notice("实在无法判断这些文件有多古老或者它们是干什么用的，但中央指挥部可能还是会欣赏它们。")

	var/static/list/paperwork_to_use //Make the ancient paperwork function like one of the main types
	if(!paperwork_to_use)
		paperwork_to_use = subtypesof(/obj/item/paperwork)
		paperwork_to_use -= (list(/obj/item/paperwork/ancient, /obj/item/paperwork/photocopy)) //Get rid of the uncopiable paperwork types

	var/obj/item/paperwork/paperwork_type = pick(paperwork_to_use)
	copy_stamp_info(paperwork_type)
