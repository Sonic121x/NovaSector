// Wiki books that are linked to the configured wiki link.

/// The size of the window that the wiki books open in.
#define BOOK_WINDOW_BROWSE_SIZE "970x710"
/// This macro will resolve to code that will open up the associated wiki page in the window.
#define WIKI_PAGE_IFRAME(title, wikiurl, link_identifier) {"
<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
		<title>[html_encode(title)]</title>
		<style>
			body {
				margin: 0;
			}
			p {
				margin: 8px;
			}
			iframe {
				border: 0;
				margin-left: -177px;
				margin-top: -80px;
				width: calc(100% + 177px);
				height: calc(100% + 80px);
				display: none;
			}
			body.loaded p {
				display: none;
			}
			body.loaded iframe {
				display: inline;
			}
		</style>
	</head>
	<body>
		<p>You start skimming through the manual...</p>
		<iframe src="[wikiurl]/[link_identifier]?useskin=vector" onload="document.body.classList.add('loaded')"></iframe>
	</body>
</html>
"}

// A book that links to the wiki
/obj/item/book/manual/wiki
	starting_content = "Nanotrasen presently does not have any resources on this topic. \
		If you would like to know more, contact your local Central Command representative." // safety
	abstract_type = /obj/item/book/manual/wiki
	/// The ending URL of the page that we link to.
	var/page_link = ""

/obj/item/book/manual/wiki/display_content(mob/living/user)
	var/wiki_url = CONFIG_GET(string/wikiurl)
	if(!wiki_url)
		user.balloon_alert(user, "这本书是空的！")
		return
	credit_book_to_reader(user)
	if(user.client.byond_version < 516) //Remove this once 516 is stable
		if(tgui_alert(user, "这本书的页面将在你的浏览器中打开。你确定吗？", "打开维基", list("Yes", "No")) != "Yes")
			return
		DIRECT_OUTPUT(user, link("[wiki_url]/[page_link]"))
	else
		DIRECT_OUTPUT(user, browse(WIKI_PAGE_IFRAME(name, wiki_url, page_link), "window=manual;size=[BOOK_WINDOW_BROWSE_SIZE]")) // if you change this GUARANTEE that it works.

/obj/item/book/manual/wiki/chemistry
	name = "化学教科书"
	icon_state ="chemistrybook"
	starting_author = "Nanotrasen"
	starting_title = "Chemistry Textbook"
	page_link = "Guide_to_chemistry"

/obj/item/book/manual/wiki/engineering_construction
	name = "空间站维修与建造"
	icon_state ="bookEngineering"
	starting_author = "Engineering Encyclopedia"
	starting_title = "Station Repairs and Construction"
	page_link = "Guide_to_construction"

/obj/item/book/manual/wiki/engineering_guide
	name = "工程学教科书"
	icon_state ="bookEngineering2"
	starting_author = "Engineering Encyclopedia"
	starting_title = "Engineering Textbook"
	page_link = "Guide_to_engineering"

/obj/item/book/manual/wiki/security_space_law
	name = "太空法"
	desc = "一套用于维持其空间站法律与秩序的纳米特拉森准则。"
	icon_state = "bookSpaceLaw"
	starting_author = "Nanotrasen"
	starting_title = "Space Law"
	page_link = "Space_Law"

/obj/item/book/manual/wiki/security_space_law/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 假装在认真阅读 \the [src]……然后立刻笑死了！"))
	return OXYLOSS

/obj/item/book/manual/wiki/infections
	name = "感染——创造你自己的大流行病！"
	icon_state = "bookInfections"
	starting_author = "Infections Encyclopedia"
	starting_title = "Infections - Making your own pandemic!"
	page_link = "Infections"

/obj/item/book/manual/wiki/telescience
	name = "传送科学——给傻瓜看的蓝空间！"
	icon_state = "book7"
	starting_author = "University of Bluespace"
	starting_title = "Teleportation Science - Bluespace for dummies!"
	page_link = "Guide_to_telescience"

/obj/item/book/manual/wiki/engineering_hacking
	name = "黑客技术"
	icon_state ="bookHacking"
	starting_author = "Engineering Encyclopedia"
	starting_title = "Hacking"
	page_link = "Hacking"

/obj/item/book/manual/wiki/detective
	name = "《黑色电影：调查工作规范流程》"
	icon_state ="bookDetective"
	starting_author = "Nanotrasen"
	starting_title = "The Film Noir: Proper Procedures for Investigations"
	page_link = "Detective"

/obj/item/book/manual/wiki/barman_recipes
	name = "《调酒师配方：调制饮品，改变人生》"
	icon_state = "barbook"
	starting_author = "Sir John Rose"
	starting_title = "Barman Recipes: Mixing Drinks and Changing Lives"
	page_link = "Guide_to_drinks"

/obj/item/book/manual/wiki/robotics_cyborgs
	name = "《机器人学入门指南》"
	icon_state = "borgbook"
	starting_author = "XISC"
	starting_title = "Robotics for Dummies"
	page_link = "Guide_to_robotics"

/obj/item/book/manual/wiki/research_and_development
	name = "《研发基础入门》"
	icon_state = "rdbook"
	starting_author = "Dr. L. Ight"
	starting_title = "Research and Development 101"
	page_link = "Guide_to_Research_and_Development"

/obj/item/book/manual/wiki/experimentor
	name = "《实验指导手册》"
	icon_state = "rdbook"
	starting_author = "Dr. H.P. Kritz"
	starting_title = "Mentoring your Experiments"
	page_link = "Experimentor"

/obj/item/book/manual/wiki/cooking_to_serve_man
	name = "《供人食用》"
	desc = "这是本食谱！"
	icon_state ="cooked_book"
	starting_author = "the Kanamitan Empire"
	starting_title = "To Serve Man"
	page_link = "Guide_to_food"

/obj/item/book/manual/wiki/tcomms
	name = "《子空间通信与你》"
	icon_state = "book3"
	starting_author = "Engineering Encyclopedia"
	starting_title = "Subspace Telecommunications And You"
	page_link = "Guide_to_Telecommunications"

/obj/item/book/manual/wiki/atmospherics
	name = "《大气学词典》"
	icon_state = "book5"
	starting_author = "the City-state of Atmosia"
	starting_title = "Lexica Atmosia"
	page_link = "Guide_to_Atmospherics"

/obj/item/book/manual/wiki/medicine
	name = "《太空医学纲要，第638卷》"
	icon_state = "book8"
	starting_author = "Medical Journal"
	starting_title = "Medical Space Compendium, Volume 638"
	page_link = "Guide_to_medicine"

/obj/item/book/manual/wiki/surgery
	name = "《脑外科手术入门指南》"
	icon_state = "book4"
	starting_author = "Dr. F. Fran"
	starting_title = "Brain Surgery for Dummies"
	page_link = "Surgery"

/obj/item/book/manual/wiki/grenades
	name = "《自制化学手榴弹》"
	icon_state = "book2"
	starting_author = "W. Powell"
	starting_title = "DIY Chemical Grenades"
	page_link = "Grenade"

/obj/item/book/manual/wiki/ordnance
	name = "《军械入门指南：或：我如何学会停止担忧并爱上最大当量》"
	icon_state = "book6"
	starting_author = "Cuban Pete"
	starting_title = "Ordnance for Dummies or: How I Learned to Stop Worrying and Love the Maxcap"
	page_link = "Guide_to_toxins"

/obj/item/book/manual/wiki/ordnance/suicide_act(mob/living/user)
	var/mob/living/carbon/human/H = user
	user.visible_message(span_suicide("[user]开始跟着伦巴节奏跳舞！看起来[user.p_theyre()]想自杀！"))
	playsound(loc, 'sound/effects/spray.ogg', 10, TRUE, -3)
	if(QDELETED(H))
		return
	H.emote("spin")
	sleep(2 SECONDS)
	for(var/obj/item/W in H)
		H.dropItemToGround(W)
		if(prob(50))
			step(W, pick(GLOB.alldirs))
	var/obj/item/bodypart/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		ADD_TRAIT(head, TRAIT_DISFIGURED, TRAIT_GENERIC)
	for(var/obj/item/bodypart/part as anything in H.get_bodyparts())
		part.adjustBleedStacks(5)
	H.gib_animation()
	sleep(0.3 SECONDS)
	H.adjust_brute_loss(1000) //to make the body super-bloody
	// if we use gib() then the body gets deleted
	H.spawn_gibs()
	H.spill_organs(DROP_ALL_REMAINS)
	H.spread_bodyparts(DROP_BRAIN)
	return BRUTELOSS

/obj/item/book/manual/wiki/plumbing
	name = "《无毒品化学工厂》"
	icon_state ="plumbingbook"
	starting_author = "Nanotrasen"
	starting_title = "Chemical Factories Without Narcotics"
	page_link = "Guide_to_plumbing"

/obj/item/book/manual/wiki/cytology
	name = "《非伦理培育有机体》"
	icon_state ="cytologybook"
	starting_author = "Kryson"
	starting_title = "Unethically Grown Organics"
	page_link = "Guide_to_cytology"

/obj/item/book/manual/wiki/tgc
	name = "《战术游戏卡牌 - 玩家手册》"
	icon_state = "tgcbook"
	starting_author = "Nanotrasen Edu-tainment Division"
	starting_title = "Tactical Game Cards - Player's Handbook"
	page_link = "Tactical_Game_Cards"

#undef BOOK_WINDOW_BROWSE_SIZE
#undef WIKI_PAGE_IFRAME
