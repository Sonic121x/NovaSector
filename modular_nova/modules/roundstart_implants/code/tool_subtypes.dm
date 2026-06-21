// ENGINEERING

/obj/item/wrench/integrated
	name = "电动指尖扳手头"
	desc = "一种廉价的倒置指尖替换件，包含一个小型电机和扭矩扳手头。适用于大多数空间站标准应用，但通常比使用手动扳手慢。"
	toolspeed = 1.25

/obj/item/wrench/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/screwdriver/integrated
	name = "电动指尖螺丝头"
	desc = "一种廉价的倒置指尖替换件，可延伸出一个坚固的通用螺丝刀头，并配备一个小型电机。有点慢，但能完成任务。"
	toolspeed = 1.25

/obj/item/screwdriver/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/crowbar/integrated
	name = "集成撬棍"
	desc = "传闻有超过一千人死于围绕实现这一物理与杠杆原理奇迹所需精确角度尺寸的间谍活动。不使用时缩回佩戴者手臂内。"
	toolspeed = 1.25

/obj/item/crowbar/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/multitool/integrated
	name = "integrated 'multitool' diagnostics device"
	desc = "结合了一套反馈至内部协处理器的指尖探针，这个实用的小装置已进入全银河系工程师和维护技术员的手臂中。"
	toolspeed = 1.25

/obj/item/multitool/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/wirecutters/integrated
	name = "集成手指剪线钳"
	desc = "a rather simple and perhaps aftermarket addition to the electrician implant, a pair of tiny deployable blades between the index and middle finger, allowing one to strip and cut wire with a simple 'scissors' motion"
	toolspeed = 1.25

/obj/item/wirecutters/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_NAKAMURA)

/obj/item/weldingtool/electric/arc_welder/integrated
	name = "集成电弧焊枪"
	desc = "Stripped down enough to fit inside a standard humanoid arm, this specialized tool guzzles power like nobody's business and produces a slightly weaker arc. It gets the job done, but you're putting a power cell inside your arm and signing all the OHS waivers that comes with."
	toolspeed = 1.25 //25% slower. really fucking slow, since synths can repair themselves with this

/obj/item/weldingtool/electric/arc_welder/integrated/switched_on(mob/user)
	. = ..()
	force = 12 // paxil tells me it's not a HUGE issue to do this but i still think force 15 is too much so force 12 we do

// MEDICAL

/obj/item/surgical_drapes/integrated
	name = "硬光手术指示器"
	desc = "一套基础硬光标记阵列，用于缺乏更专业设备时的基本外科手术，由伤口分析仪硬件改造而来。对准目标时可为基础手术建立基础操作协议。"

/obj/item/surgical_drapes/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_INTERDYNE)

/obj/item/hemostat/integrated
	name = "集成式止血钳"
	desc = "本质上就是一套稍显花哨的镊子，带有轻微锯齿和专用互锁机构，全部微型化以适应手指内部空间。"
	toolspeed = 1.25 // this will directly affect how fast someone can tend wounds with this setup, balancejak accordingly

/obj/item/hemostat/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_INTERDYNE)

/obj/item/retractor/integrated
	name = "指尖牵开钳"
	desc = "一套专为野战手术设计的高抓握力组织扭转夹持套件。"
	toolspeed = 1.25

/obj/item/retractor/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_INTERDYNE)

// UTILITY

/obj/item/storage/bag/tray/integrated
	name = "伸缩式厨房载具"
	desc = "最初在飞蛾舰队上首创，后来在多臂物种中广泛使用。非常适合搬运大量食物，可以卷成一根伸缩式、密封的管状物，储存在使用者的手臂内。"
	storage_type = /datum/storage/bag/tray/integrated

/datum/storage/bag/tray/integrated
	max_slots = 3

/obj/item/lighter/integrated
	name = "拇指尖打火机"
	desc = "银河系民意调查显示，市场对这种特定的赛博格附加装置有着惊人的需求——具体来说，就是一个带有标准打火机外壳的铰链式假指尖，许多公司引用‘提高繁殖成功率’作为主要调查结果之一。翻译成太阳系通用语，意思就是用手指点烟有助于你吸引异性。据说是这样。"

/obj/item/rag/integrated
	name = "集成式清洁麂皮"
	desc = "保证能清除（大部分）污渍。这款民用赛博格增强装置附带一份冗长的免责声明，要求放弃因该设备对你手臂内部隔舱造成的任何液体损坏索赔。"

/obj/item/pen/fourcolor/integrated
	//no new desc for this one since it sets its own desc
	name = "集成式四色笔"

/obj/item/paper_bin/integrated
	name = "集成式纸沓"
	desc = "只有杰森特人才能具备如此纯粹的官僚作风，允许将一个小小的纸篓安装到人的手臂里。还附带一个内部固定夹，可以多放一支笔，以防万一你不知怎地用完了第一支。"
	total_paper = 10

/obj/item/universal_scanner/integrated
	name = "指尖通用扫描仪"
	desc = "Some deckhands working the FTU distribution centers popularized this cybernetic addon after the speed improvements it yielded let them claw back the ten minute lunch breaks they'd been deprived for thirty years. Replaces the pad of the user's fourth finger with a digitized universal scanner, capable of switching between export, price, and sales tagger modes."
	paper_count = 5
	max_paper_count = 5

/obj/item/boxcutter/extended/integrated
	name = "集成式开箱刀"
	desc = "这个集成设计是从旧地球数据库窃取的，最初是某种腕鞘式刺客工具，由一位匿名的比特跑者发布到公共领域。FTU发现它作为开箱刀非常好用，因此授权将其纳入他们的甲板水手工具集。"

/obj/item/stamp/granted/integrated
	name = "fingertip 'GRANTED' stamp"
	desc = "设计为可从专门的指垫底座中旋转伸出，这枚印章是各地预算紧缩者的克星——因为它敢于触碰之处，信用点损失必将随之而来。"

/obj/item/stamp/denied/integrated
	name = "fingertip 'DENIED' stamp"
	desc = "当电脑真的、真的说不行的时候。"

// FORGING (why are we doing this)

/obj/item/forging/hammer/integrated
	name = "集成式金属加工锤"
	desc = "应矮人族的要求，黑钢基金会生产了一套低成本工具组，最终成为了他们最受欢迎的产品之一。而这一切都始于这把孤零零的锤子。"

/obj/item/forging/hammer/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_BLACKSTEEL)

/obj/item/forging/tongs/integrated
	name = "隔热指尖钳"
	desc = "坚固的热处理金属和集成散热片使这两个指尖替换增强体能够像普通冶金钳一样使用，能抵抗除最猛烈熔炉外的所有灼伤。"
	toolspeed = 2

/obj/item/forging/tongs/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_BLACKSTEEL)

/obj/item/forging/billow/integrated
	name = "电动迷你风箱"
	desc = "莫被其尺寸所欺，这铰链式手风琴状增强体激活时产生的强风足以煽动最微弱的火焰陷入狂舞。其上贴有健康与安全警告，写着：'请勿放入口中'。"
	toolspeed = 2

/obj/item/forging/billow/integrated/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/manufacturer_examine, COMPANY_BLACKSTEEL)
