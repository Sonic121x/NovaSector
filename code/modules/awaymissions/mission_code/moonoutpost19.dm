// moonoutpost19

/obj/structure/fluff/minepost
	name = "木桩"
	desc = "一根坚固的太空木桩，足以支撑起一个矿井。"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "minepost"
	density = FALSE

//Areas
/area/awaymission/moonoutpost19
	name = "太空空间"
	icon_state = "awaycontent1"

/area/awaymission/moonoutpost19/arrivals
	name = "MO19抵达"
	icon_state = "awaycontent2"

/area/awaymission/moonoutpost19/arrivals/shed
	name = "MO19 抵达棚屋"
	icon_state = "awaycontent9"

/area/awaymission/moonoutpost19/research
	name = "MO19研究"
	icon_state = "awaycontent3"

/area/awaymission/moonoutpost19/syndicate
	name = "辛迪加前哨站"
	icon_state = "awaycontent4"

/area/awaymission/moonoutpost19/main
	name = "孔苏 19"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = list('sound/ambience/ruin/ambimine.ogg')
	icon_state = "awaycontent5"
	outdoors = TRUE

/area/awaymission/moonoutpost19/hive
	name = "蜂巢"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	icon_state = "awaycontent6"

/area/awaymission/moonoutpost19/tent
	name = "研究帐篷"
	icon_state = "awaycontent7"

/area/awaymission/moonoutpost19/mines
	name = "矿物挖掘隧道"
	always_unpowered = TRUE
	power_environ = FALSE
	power_equip = FALSE
	power_light = FALSE
	ambientsounds = list('sound/ambience/ruin/ambimine.ogg')
	icon_state = "awaycontent8"

//Fluff objects/structures.
/obj/structure/fluff/meteor
	name = "陨石"
	desc = "孔苏19号以其相对较高的比重而闻名，这导致了持续的流星雨和撞击。"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small"
	density = TRUE

/obj/structure/fluff/meteor/large
	name = "大型陨石"
	desc = "这么大的东西可能会把空间站撕成两半。幸好它落在了这里！"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "large"

/obj/structure/fluff/meteor/sharp
	name = "岩石陨石"
	desc = "一大块岩石露头。在太空中比在这样的卫星上更常见。"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "sharp"

//Papers

/obj/item/paper/crumpled/awaymissions/moonoutpost19/hastey_note
	name = "匆匆写下的便条"
	default_raw_text = "<i>19 06 2554</i><br><br><i>I fucking knew it. There was a major breach, that idiotic force field failed and the xenomorphs rushed out and took out the scientists. I've managed to make it to my office and closed the blast doors. I can hear them trying to pry open the doors. Probably don't have long. I have no clue what has happened to the rest of the crew, for all I know they've been killed to produce more of the fucks.</i>"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/larva_social
	name = "异形幼虫的社会互动及捕获程序"
	default_raw_text = "研究员：<u>佐野朔真博士    </u><br>日期：<u>2554年6月4日</u><br><br>报告：<br>正如预期，我们早些时候送进去的猴子只剩下了一群异形幼虫。很明显，抱脸虫在选择宿主方面并不挑剔，而且迄今为止，妊娠过程显示出100%的成功率。<br><br>这些幼虫本身的行为与我们最初观察到的单个幼虫大不相同，尽管它们会避开人类，但它们显然对同类感到舒适。我们之前对幼虫的怀疑已经通过它们表现出的玩耍行为得到证实：在蜕皮成年之前，它们在幼年时远没有那么具有攻击性或暴力性。<br><br>我们观察到的大部分玩耍行为涉及一种捉迷藏，偶尔还有通过缠绕在一起并挣扎脱身的摔跤。虽然通常我们会认为这是为了在蜕皮时磨练技能的本能性玩耍，但它们的生长期如此之快，而且它们仍然是如此娴熟的杀手，这没有任何实际目的。对此唯一的解释也许是为了彼此建立联系和友谊，如果这对于这样一个极具敌意的种族来说甚至可能的话。也许它们彼此之间比其他生命形式要合理得多。<br><br>现在已经很清楚，现在是提取一只异形进行解剖的最佳时机，因为这些都还是幼虫，而且女王仍然附着在其产卵器上，无法移动。在研究主任的批准下，我们派出了被戏称为'头部外科医生'的医疗机器人进入收容围栏，将护盾降下仅一瞬间以允许其进入。幼虫们很谨慎，但其中一只的好奇心使它进入了我们机器人的抓取范围。它被带了出来，并通过我们的机械医生提供的致命注射迅速实施了安乐死。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/xeno_queen
	name = "异形女王的生理和行为观察"
	default_raw_text = "研究员：<u>佐久间佐野博士    </u><br>日期：<u>2554年4月6日</u><br><br>报告：<br>作为一名异种生物学家，我研究过许多有趣多样的生命形式，从体型大如牛的生物，到肉眼难以观察的微小样本。这是我迄今为止见过的最大的外星生物。我们先前研究的外星生物已经蜕皮，变成了一个绝对庞大的生物。异形女皇站立时超过15英尺高，体重可能达到两吨或更多，是一个绝对令人惊叹的巨大而残忍的怪物。它的行为与作为工蜂时相比发生了巨大变化，变得更喜欢坐着注视我们，而不是撞击窗户。<br><br>从生理学上讲，女皇与其他异形相当相似，但有几个关键区别。其庞大的体型需要粗壮的腿部支撑，而背部似乎总是向前佝偻。背部的管状结构已转变为数根巨大的尖刺，我们观察到该生物现在胸部还有一对较小的手臂。这对次级手臂的用途尚不清楚。最后，女皇的头冠变得异常巨大，似乎有一个可伸缩的凹槽可以隐藏头部。穹顶前部显得极其厚重，很可能能够承受大量创伤。尽管体型已增长到如此巨大，它的速度却并未比过去慢多少。<br><br>在除了注视外几乎无所事事的两个小时后，女皇开始产生异常大量的树脂和杂草，迅速构筑了一个大型巢穴并躲藏其后。接着它打碎了所有灯光，导致我们的摄像机几乎无法观察。当我们通过后方摄像机查看时，发现它已长出一个大型产卵器，并正在向地面释放大型卵。这让我们一致认为生命周期的这个阶段就是女皇。<br><br>在接下来的几个小时内，卵发育到完整尺寸，我们为实验对象提供了新的猴子宿主。当猴子接近卵时，卵会打开释放更多抱脸虫。看来我们已经观察到了该物种完整的繁殖周期。预计未来几小时内会出现更多幼虫。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/xeno_adult
	name = "成年异形生理与行为观察"
	default_raw_text = "Researcher: <u>Dr. Sakuma Sano    </u><br>Date: <u>03/06/2554</u><br><br>Report:<br>The other scientists and I can hardly believe our eyes. The snake-like larva has molted into a 7 foot tall insectoid nightmare in just a few hours. It's obvious now as to why such heavy duty containment was needed. It immediately tried to escape however by flinging itself at the window in a flurry of swipes and stabs. It seems its behavior has returned to a state that is very similar to the facehugger, though I doubt with the same intent! Thankfully, our glass and shields have shown to be more than sturdy enough for such a violent creature, and so far, any attempts at the creature escaping have been in vain.<br><br>As for its physiology, the creature has an elongated head with what appears to be have an exoskeleton resembling an external rib-cage on the torso. The alien is also fairly skinny with a lean body. The little amount of meat on the alien appears to be entirely muscle.  We assume this makes it deceptively strong, while remaining agile at the same time.  One of the most interesting things we have seen is its pharyngeal jaw.  It has some what of an inner mouth capable of being fired externally at extremely high speeds. It has already caused many dents in the walls and a few small cracks in the window with it. The alien also has a couple of dorsal tubes on its back, their purpose unknown. Finally, this monster sports a long ridged tail, complete with a large and extremely sharp blade at the tip.<br><br>Normally I would be absolutely terrified of something like this, but I'm putting my trust in Nanotrasen with the containment. After all, they wouldn't build a cell that could fail to contain its subject, would they?"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/larva_psych
	name = "异形幼体生理与行为观察"
	default_raw_text = "研究员：<u>佐久间佐野博士    </u><br>日期：<u>2554年3月6日</u><br><br>报告：<br>当幼虫首次从猴子胸腔中钻出时，它似乎非常好奇。它会漫无目的地游荡一会儿，然后静止不动。我们无法确定幼虫的性别，甚至无法确定它是否有性别。一段时间后，它似乎对周围环境失去了兴趣，大部分时间静止不动，偶尔会摇动尾巴。我们决定投入一只活老鼠，看看它是否会捕食。幼虫迅速攻击并吃掉了老鼠，并且似乎突然变大了，这表明幼虫能够以先前认为不可能的速度代谢并将所有能量导向生长。遗憾的是，我们无法更近距离地观察这个过程，因为我们目前尚不清楚这种生物有多危险或暴力，也不清楚它完全成熟后会变成什么样。<br><br>不禁让人想象利用这种机制的可能性。例如，跳过儿童数年的生长时间、在瞬间修复身体损伤，甚至将其应用于现有的克隆技术中。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/facehugger
	name = "'Facehugger' Xenomorph Physiology & Behavior Observation"
	default_raw_text = "Researcher: <u>Dr. Sakuma Sano    </u><br>Date: <u>03/06/2554</u><br><br>Report:<br>The test subject we were provided with truly is alien. It is a small spider-like creature with bony legs leading to a smooth body. It has a long tail connected to it, and it has shown extremely aggressive behavior by flinging its entire body at the glass and shields to no avail. While doing so, we noticed there was a small pink hole in the middle of the body.<br><br>When we sent in a monkey through the crude but effective disposal tube, the alien immediately jumped at its face and latched on. The monkey was quickly suffocated by its constricting tail, unable to pry off the fingers. The monkey at first seemed to be dead, but was observed to be breathing. The recently named alien 'facehugger' fell off dead and curled its legs up like a spider moments after it had finished with the monkey's body.<br><br>While the monkey appeared to be unharmed, we kept it in the cell for a couple more hours until we were horrified to discover it screaming out in pain as a snake-like creature erupted from the monkey's chest! It appears that the 'facehugger' is only the start of this life cycle. The impregnation cycle involving the creatures growing inside the chests of their hosts seems to only be the beginning."

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/xeno_hivemind
	name = "群体思维假说"
	default_raw_text = "研究员：<u>马克·道格拉斯博士    </u><br>日期：<u>2554年6月17日</u><br><br>报告：<br>今天早些时候，我们在实验对象身上观察到了新现象。当我们用最后一只猴子喂食它们并扔掉箱子时，这些外星生物只是看着我们，没有立即感染猴子。它们看起来集体表现出不安，似乎意识到将不再获得宿主，而我们将进入实验的下一阶段。当我瞥了一眼通往它们观察室的气罐和管道，再回头时，发现它们全都紧贴着玻璃，连女王也不例外！就好像它们都明白即将发生什么，尽管我们知道只有女王具备这样的认知能力。<br><br>对此唯一的解释是外星生物之间存在某种形式的交流，但在此之前，我们从未在观察室内观察到任何此类行为。我们也知道普通的工蜂和猎手异形本身不具备个性或生存本能。或许女王与它们有直接联系？一种控制它们一举一动的指挥官或监督者形式？一种蜂巢思维？"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/xeno_behavior
	name = "\improper 外星人行为初步研究"
	default_raw_text = "研究员：<u>佐久间佐野博士    </u><br>日期：<u>2554年6月8日</u><br><br>报告：<br>我们在此研究的异形是一个非凡的物种。几乎所有阶级都普遍表现出攻击性，在暴力行为前后均无任何悔意、内疚或迟疑。它们似乎是一个完全为杀戮而设计的物种。奇怪的是，甚至连它们的繁殖方式也是一种残酷的'一换一'方法，在诞生新异形的同时杀死其宿主。<br><br>仅仅五天前我们研究的那个单独异形几乎没有表现出智力迹象。那只是一个简单的工蜂，反复将自己撞向安全玻璃和护盾，所幸没有成功。一旦该工蜂蜕变为女王，它变得冷静且富有算计，只是看着我们，等待并筑巢。随着蜂巢规模和数量的增长，普通猎手和工蜂的智力也随之提高。我们仍在研究它们如何相互交流，以及不同阶级与女王之间的关系。随着对该物种了解的深入，我们将继续更新研究。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/xeno_castes
	name = "The Xenomorph 'Castes'"
	default_raw_text = "研究员：<u>马克·道格拉斯博士    </u><br>日期：<u>2554年6月6日</u><br><br>报告：<br>在观察收容单元内不断增多的异形时，我们开始注意到一些持续重复出现的细微差异。如同蚂蚁一样，这些生物显然拥有不同的特化变体，决定了它们在巢群中的角色。我们将目前观察到的三个种姓命名为猎手、工蜂和哨兵。<br><br>据观察，猎手是三者中迄今为止最具攻击性和最敏捷的，它们不断在各个表面奔跑，并频繁抓挠观察窗。它们还非常擅长在黑暗中和它们自身的树脂结构上伪装自己，对于粗心的观察者来说几乎隐形。它们总是最先接触到我们投放的猴子，这使我们相信该种姓主要用于寻找和捕获宿主。<br><br>相比之下，工蜂则温顺得多，也显得更胆怯，尽管其攻击性并不亚于其他种姓。据观察，它们的头部更宽，且缺少背管。它们表现出比其他任何种姓都更低的敏捷性和明显更脆弱的体质。然而，从未观察到工蜂直接与猴子互动，它们更倾向于维护巢群，例如建造树脂墙和在巢穴内搬运卵。据我们所知，我们只观察到过工蜂转变为女王，并且无法确定其他种姓是否具备这种能力。<br><br>最后是哨兵，它们乍一看似乎是巢群的守卫。迄今为止，只观察到它们停留在女王和卵附近，经常蜷缩在墙边。我们仅观察到一次实例，当一只猴子过于靠近女王时，哨兵立即扑倒并压制住它，直到其被抱脸虫寄生。它们缺乏运动，这使得我们难以确定其确切目的是作为守卫、哨兵还是其他角色。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/larva_autopsy
	name = "异形幼虫尸检报告"
	default_raw_text = "研究员：<u>马克·道格拉斯博士    </u><br>日期：<u>2554年6月4日</u><br><br>报告：<br>经过一次极其危险、耗时且代价高昂的解剖后，我们成功记录并识别了异形生命周期第一阶段——幼虫体内的数个器官。这个程序花费了大量时间，因为这些生物拥有极其、甚至近乎滑稽的强酸性血液，能在片刻间熔化几乎任何东西。我们不得不使用超过一打的手术刀和牵开器才完成这次尸检。<br><br>幼虫似乎拥有的器官远比人类少，且差异很大。它有一个胃，但没有消化道；一个心脏，似乎缺乏任何血液-氧气循环功能；以及一个细长的大脑，尽管其智力水平与任何大型猫科动物无异。它还缺少肝脏、肾脏或其他基本器官。<br><br>我们无法确定这些生物生长的确切机制，也无法确定它们在成年时是否会获得新的器官。体型更大的异形品种过于危险，难以杀死和捕获，无法为我们解答这些问题提供准确的答案。我们所能得出的结论是，能够在器官如此之少的情况下正常运作，同时又如此致命，这意味着这些生物高度进化，并且很可能对各种对人类而言是致命性的危害具有极强的耐受性。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/research/evacuation
	name = "疏散程序"
	default_raw_text = "<h3><font color=red>若发生异种生物学泄露事件：疏散人员，封锁异种生物学区域，立即通知现场上级和/或中央指挥部。</h3></b><br><br><h3>当前异种生物学收容等级：<u><strike>安全</strike><i><b> 快跑                    </h3></b></i></u>"

/obj/item/paper/fluff/awaymissions/moonoutpost19/log/personal
	name = "个人日志"
	default_raw_text = "Log 1:<br>We got our promised supply drop today. We were only meant to get it, what, a week ago? This bloody gateway keeps desyncing itself, and that means subsisting off recycled water and carb packs. No clue where the damn thing connects to on its off days, and HQ say we are 'not to touch it if it isn't linking to command.' We dumped off the assload of crates Jim filled, got our boxes of oxygen, food and drink, and closed the portal.<br><br>Log 2:<br>Damn thing is acting up again. Three days no contact this time. I thought I heard clanking noises from it yesterday. Jim is going on about the NT base or some shit. We've been over this before - They don't know we're here, that engineer was too drunk to recognize his suit, especially since I had it painted orange. He's starting to get annoying. We're safe.<br><br>Log 3:<br>Gateway synced itself up automatically today. I opened it for an instant to spy through it, got a glimpse of the inside of a transport container. Either HQ's redecorating or something, or there's more than two of these things."

/obj/item/paper/fluff/awaymissions/moonoutpost19/log/personal_2
	name = "Personal Log"
	default_raw_text = "Log 1:<br>While mining today I noticed the NT station was finished with its renovations. They placed some huge reinforced tumor on the station, looks so ugly. I wouldn't be surprised if those pigs decided to turn that little astronomy outpost into a prison with that thing, it'd be pretty typical of them.<br><br>Log 2:<br>Really dumb of me but I just waved at an engineer in the outpost, and he waved back. I hope to god he was too dumb or drunk to recognize the suit, because if he isn't then we might have to pull out before they come looking for us.<br><br>Log 3:<br>That huge reinforced tumor in their science section has been making a lot of noise lately. I've been hearing some banging and scratching from the other side and I'm kind of glad now that they reinforced this thing so much. I'll be sleeping with my gun under my pillow from now on."

/obj/item/paper/fluff/awaymissions/moonoutpost19/engineering
	name = "工程指令"
	default_raw_text = "Alright, listen up. If you're reading this, I'm either taking a shit or I've been recalled back to Command. Either way, you'll need to know how to restore power. We've stolen this stuff from Nanotrasen, so all the equipment is jury-rigged. We have generators that work on both plasma and uranium, about 50 sheets should power the outpost for quite a while. If the generators aren't working, which is very likely, take the power cell on the desk and put it into the APC in the hallway. That should get the place running, at least for a little while."

/obj/item/paper/fluff/awaymissions/moonoutpost19/log/kenneth
	name = "个人日志 - 肯尼斯·坎宁安"
	default_raw_text = "Entry One - 27/05/2554:<br>I just arrived, and already I hate my job. I'm stuck on this shithole of an outpost, trying to avoid these damn eggheads running all over the place preparing for god knows what. There's no crimes to stop, no syndies to kill, and I'm not even allowed to beat the fuckin' assistant senseless! They said I was transferred from Space Station 13 for 'good behavior', but this feels more like a punishment than a reward. All I know is that if I don't get some action soon, I'm going to go insane.<br><br>Entry Two - 03/06/2554:<br>Okay, so get this: we got a fuckin' deathsquad coming in today! I thought the day I saw one of them would be the day my employment was 'terminated', if you get my drift. They're escorting some sort of weird alien creature for the eggheads to study. I heard one of the docs telling the chef that this thing killed a whole security force before it was captured. I sure as hell hope that I don't have to fight it.<br><br>Entry Three - 08/06/2554:<br>My first real bit of 'action' today, if you could call it that. Crazy Ivan got in a fight with Kuester today about his Booze-O-Mat. Apparently one of the crewmembers had stolen a couple bottles of booze from the machine after Ivan disabled the ID lock. Tell you the truth, I don't blame the thief. Everyone is going a little stir-crazy in here, and the bartender is being damn stingy with the alcohol. Either way, once they started to pick a fight, I had to take them down. It's a damn shame that we don't have a brig, though. I had to lock Ivan in a fuckin' freezer, for god's sake. Let's hope that we can keep our sanity together, at least for a while.<br><br>Entry Four - 10/06/2554:<br>Jesus fucking Christ riding on a motorbike. These things the scientists are studying are terrifying! Fucking great huge purple bug things as tall as the ceiling, with blades for arms and drooling at the mouth. I don't think my taser will do jack shit against these damn things, but the eggheads say that they're safely contained. If they do, I have a feeling that it's only a matter of time before we're all screwed. These bastards look like walking death.<br><br>Entry Five - 18/06/2554:<br>Finally caught who stole the booze from Kuester. It was that fuckin' loser assistant Steve! He was in the dorms, chugging his worries away. I took one of the bottles back to the barkeep, but no one has to know about this second one. I think I'm gonna enjoy this while watching tomorrow's Thunderdome match.<br><br>Entry Six - 19/06/2554:<br>Oh, great. The chef is still sleeping, so we get Ivan's gruel for breakfast today. I overheard Sano and Douglas saying something about the aliens being restless, so we might get some action today. As long as it happens after the big game, I'm fine with it. I still got one beer to drink before I'm ready to die."

/obj/item/paper/fluff/awaymissions/moonoutpost19/log/ivan
	name = "个人日志 - 伊万·沃洛金"
	default_raw_text = "伊万·沃洛丁的故事：<br><br>记录一 - 2554年5月28日：<br>你好。我是疯狂伊万。老板说我必须写。我修理前哨站干得很好。是非常好的工作。比矿上好多了。很多好人。我没惹麻烦。<br><br>记录二 - 2554年6月5日：<br>我发现酒水自动贩卖机有问题。不是问题。我很容易就解决了。用黄色工具让紫色灯灭掉。我是好工程师！酒保会很高兴的。<br><br>记录三 - 2554年6月8日：<br>酒保不高兴。保安不高兴。感觉不到腿了，冷冻库里很冷。不好。桌子卡在门里，没有工具。非常不好。但是，往好处想，找到了肉！要嚼着保持精神。<br><br>记录四 - 2554年6月12日：<br>今天大只讨厌的紫色虫子看了我。让人紧张。蓝色墙线可以弄断，然后坏事发生。非常非常坏的事。今天穿橙色太空服的人也朝我挥手了。他看起来人不错。想知道是谁？<br><br>记录五 - 2554年6月15日：<br>我今天吃了玉米片。是好日子。太阳晒了一会儿。很好。我还坐了垃圾滑道。好玩，但很小。从管子里清出堵塞物，是伏特加瓶子。空的。这让人很伤心。<br><br>记录六 - 2554年6月19日：<br>紫色虫子今天很跳。挥手时，发出嘶嘶声。可能很糟。可能只是病了。不知道。是科学问题，不是工程师问题。我吃了三明治。是光荣的工作。希望永不结束。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/log/gerald
	name = "个人日志 - 杰拉尔德·罗斯韦尔"
	default_raw_text = "Personal Log for Research Director Gerald Rosswell<br><br>Entry One - 17/05/2554:<br>You know, I can't believe I took this position so suddenly. I saw that corporate needed a research director for one of it's outposts and thought it would be a cakewalk, there isn't going to be a lot of research to be done on a tiny outpost. Mainly just running scans on the gas giant we are orbiting or some basic RnD. However, they conveniently forgot to tell me that me and my science staff would have to pull double duty as medical staff and that there is no one higher up on the chain of command here, so I get to pull triple duty as acting captain as well! This shit is probably allowed in some 3 point fine print buried underneath the literally thousands of pages of contracts. Well, at least the research will be easy work.<br><br>Entry Two - 25/05/2554:<br>Well, we all expected it at the outpost, CentCom has decided to completely change what research we are doing. They've decided that we should be research the species known as 'xenomporphs'. They announced this change 4 days ago and along with it, sadly, the termination of our current science staff barring me. Not to mention the constant noise made by the construction detail they sent to staple on a xenobiology lab ensuring no one has been able to sleep decently ever since they announced the shift. To make matters worse our current security guard actually died of a heart attack today. Just goes to show that 75 year old men shouldn't be security guards. Still can't believe that they decided to do this major change less than a month after the outpost was established.<br><br>Entry Three - 27/05/2554:<br>The new security guard arrived today. Apparently transferred here from the research station that also is orbiting the gas giant. He seems to be rather angry about his transfer. Considering the rumors I've heard about the research station he's probably caught off guard by the fact that Steve hasn't tried to force an IED down his throat.<br><br>Entry Four - 06/06/2554:<br>My requests for additional security and containment measures for the 'xenomorph' has been denied. Does Central Command not notice how dangerous these creatures are? The only thing keeping them in is a force field, a minor problem with the power grid and the entire hive is loose. What would stop them then, the lone security guard with a dinky little taser? Kenneth can barely handle a short-tempered engineer. We are under equipped and under staffed, we are inevitably going to be destroyed unless we get the equipment and staff we need.<br><br>Entry Five - 10/06/2554:<br>Cunningham got a good look at the xenomorph in containment. He was frightened for the rest of the day, rather amusing if it wasn't for the fact that we are all trapped on this scrap heap with naught but a force field keeping those xenomorphs in.<br><br>Entry Six - 17/06/2554:<br>The reactions from the specimens today has shown that they possess strange mental properties. Mark hypothesizes that they possibly have a sort of hive mind, while nothing is certain this would explain how xenomorphs seem to have vastly increased intellect when a 'queen' is present. Of course, to test this hypothesis would require many complicated procedures which we will not be able to undertake. But we do not know the full extend of the xenomorph mind, it may or may not be able to find a way to circumvent our containment system. I will resend my request for additional security measures along with this new found information."

/obj/item/paper/fluff/awaymissions/moonoutpost19/food_specials
	name = "本周特惠"
	default_raw_text = "<b><h2>‘我真不敢相信这不是意面’：周三半价</h2></b><br><br><b><h2><font color=blue>每周五晚6点至10点汉堡之夜，购餐即赠免费饮品！</font></h2></b><br><br><b><h2><font color=red>今晚首演：‘抢鞋威利’的喜剧表演！上午11点至晚上7点</font></h2></b>"

/obj/item/paper/fluff/awaymissions/moonoutpost19/welcome
	name = "欢迎通知"
	default_raw_text = "<p><p align=center><h2>欢迎来到月球前哨站19！纳米特拉森公司所有</h2></p><hr><br><br>人员名单：<br>-杰拉尔德·罗斯韦尔博士：研究主管兼代理船长<br>-佐久间佐野博士：外星生物学家<br>-马克·道格拉斯博士：外星生物学家<br>-肯尼斯·坎宁安：安全官员-伊万·沃洛丁：工程师<br>-马蒂亚斯·库斯特：酒保<br>-斯文·埃德林：厨师<br>-史蒂夫：助理<br><br>请享受您的停留，如有任何异常情况请向官员报告。"

/obj/item/paper/fluff/awaymissions/moonoutpost19/goodbye_note
	name = "笔记"
	default_raw_text = "<i>虫子爆发了。我跑到这里锁上了门。我听到旁边的门被撞开和尖叫声。这里所有好人都死了。我不想被吃掉，虽然药瓶总被说是懦夫的出路，但说这话的人才是蠢货。米拉，我已经无路可逃了，告诉亚历克西斯和埃琳娜，爸爸再也回不了家了，我爱你们所有人。</i>"


