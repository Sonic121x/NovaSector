/obj/item/clothing/accessory/medal
	name = "铜牌"
	desc = "一枚铜牌。"
	icon_state = "bronze"
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT)
	resistance_flags = FIRE_PROOF
	/// Sprite used for medalbox
	var/medaltype = "medal"
	/// Has this been use for a commendation?
	var/commendation_message
	/// Who was first given this medal
	var/awarded_to
	/// Who gave out this medal
	var/awarder

/obj/item/clothing/accessory/medal/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/pinnable_accessory, on_pre_pin = CALLBACK(src, PROC_REF(provide_reason)))

/// Input a reason for the medal for the round end screen
/obj/item/clothing/accessory/medal/proc/provide_reason(mob/living/carbon/human/distinguished, mob/user)
	commendation_message = tgui_input_text(user, "嘉奖理由？纳米传讯将记录此信息。", "嘉奖", max_length = 140)
	return !!commendation_message

/obj/item/clothing/accessory/medal/try_attach(obj/item/clothing/under/attach_to, mob/living/attacher)
	var/mob/living/distinguished = attach_to.loc
	if(isnull(attacher) || !istype(distinguished) || distinguished == attacher || awarded_to)
		// You can't be awarded by nothing, you can't award yourself, and you can't be awarded someone else's medal
		return ..()

	awarder = attacher.real_name
	awarded_to = distinguished.real_name

	update_appearance(UPDATE_DESC)
	add_memory_in_range(distinguished, 7, /datum/memory/received_medal, protagonist = distinguished, deuteragonist = attacher, medal_type = src, medal_text = commendation_message)
	distinguished.log_message("was given the following commendation by <b>[key_name(attacher)]</b>: [commendation_message]", LOG_GAME, color = "green")
	message_admins("<b>[key_name_admin(distinguished)]</b> was given the following commendation by <b>[key_name_admin(attacher)]</b>: [commendation_message]")
	GLOB.commendations += "[awarder] awarded <b>[awarded_to]</b> the <span class='medaltext'>[name]</span>! \n- [commendation_message]"
	SSblackbox.record_feedback("associative", "commendation", 1, list("commender" = "[awarder]", "commendee" = "[awarded_to]", "medal" = "[src]", "reason" = commendation_message))

	return ..()

/obj/item/clothing/accessory/medal/update_desc(updates)
	. = ..()
	if(commendation_message && awarded_to && awarder)
		desc += span_info("<br>The inscription reads: [commendation_message] - Awarded to [awarded_to] by [awarder]")

/obj/item/clothing/accessory/medal/conduct
	name = "杰出行为奖章"
	desc = "一枚授予杰出行为的铜质奖章。虽然是一项巨大的荣誉，但这是纳米传讯颁发的最基础的奖项。通常由舰长授予其船员。"

/obj/item/clothing/accessory/medal/bronze_heart
	name = "青铜之心勋章"
	desc = "一枚授予牺牲者的青铜心形勋章。通常追授给因公殉职或遭受重伤的人员。"
	icon_state = "bronze_heart"

/obj/item/clothing/accessory/medal/ribbon
	name = "绶带"
	desc = "一条绶带"
	icon_state = "cargo"

/obj/item/clothing/accessory/medal/ribbon/cargo
	name = "\"当班货运技术员\"奖"
	desc = "一项仅授予那些恪守货运尼亚最高传统、忠于职守的货运技术员的奖项。"

/obj/item/clothing/accessory/medal/silver
	name = "银质奖章"
	desc = "一枚银质奖章。"
	icon_state = "silver"
	medaltype = "medal-silver"
	custom_materials = list(/datum/material/silver = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/accessory/medal/silver/valor
	name = "英勇勋章"
	desc = "一枚授予英勇行为的银质奖章。"

/obj/item/clothing/accessory/medal/silver/security
	name = "安保部门杰出贡献奖章"
	desc = "为表彰在保卫纳米传讯商业利益中表现出的杰出战斗与牺牲精神而颁发的奖项。通常授予安保人员。"

/obj/item/clothing/accessory/medal/silver/excellence
	name = "\proper 人事主管颁发的卓越领域杰出成就奖"
	desc = "纳米传讯词典将卓越定义为\"the quality or condition of being excellent\"。这枚奖章授予那些符合此定义的稀有船员。"

/obj/item/clothing/accessory/medal/silver/bureaucracy
	name = "\improper 卓越官僚主义奖章"
	desc = "授予在与纳米传讯签订合同期间提供模范管理服务的人员。"

/obj/item/clothing/accessory/medal/gold
	name = "金牌"
	desc = "一枚尊贵的金色奖章。"
	icon_state = "gold"
	medaltype = "medal-gold"
	custom_materials = list(/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/accessory/medal/med_medal
	name = "模范表现奖章"
	desc = "授予那些在医疗部门展现出杰出品行、表现和主动性人员的奖章。"
	icon_state = "med_medal"

/obj/item/clothing/accessory/medal/med_medal2
	name = "医疗卓越奖章"
	desc = "授予那些在医疗部门展现出超越所有人期望的传奇表现、能力和主动性之人的奖章。"
	icon_state = "med_medal2"

/obj/item/clothing/accessory/medal/gold/captain
	name = "舰长任职勋章"
	desc = "一枚仅授予晋升为舰长之人的金质勋章。它象征着舰长对纳米传讯公司所负的成文责任，以及其对船员无可争议的权威。"
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/item/clothing/accessory/medal/gold/heroism
	name = "卓越英勇勋章"
	desc = "一枚极其罕见的金质勋章，仅由中央司令部颁发。获得此勋章是最高荣誉，因此存世极少。这枚勋章几乎只授予指挥官。"

/obj/item/clothing/accessory/medal/plasma
	name = "等离子体奖章"
	desc = "一枚由等离子体制成的奇特勋章。"
	icon_state = "plasma"
	medaltype = "medal-plasma"
	custom_materials = list(/datum/material/plasma = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/clothing/accessory/medal/plasma/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)

/obj/item/clothing/accessory/medal/plasma/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 300

/obj/item/clothing/accessory/medal/plasma/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	atmos_spawn_air("[GAS_PLASMA]=20;[TURF_TEMPERATURE(exposed_temperature)]")
	visible_message(span_danger("\The [src] 突然燃烧起来！"), span_userdanger("你的[src]突然着火了！"))
	qdel(src)

/obj/item/clothing/accessory/medal/plasma/nobel_science
	name = "诺贝尔科研奖"
	desc = "一枚等离子体奖章，代表着对科研或工程领域的重大贡献。"

/obj/item/clothing/accessory/medal/silver/emergency_services
	name = "应急服务奖章"
	desc = "一枚授予纳米传讯杰出应急服务人员的银质奖章，表彰他们在太空恶劣环境中，不畏艰险、不懈努力，共同守护船员安全与呼吸的奉献精神。"
	icon_state = "emergencyservices"

	/// Flavor text that is appended to the description.
	var/insignia_desc = null

/obj/item/clothing/accessory/medal/silver/emergency_services/Initialize(mapload)
	. = ..()
	if(istext(insignia_desc))
		desc += " [insignia_desc]"

/obj/item/clothing/accessory/medal/silver/emergency_services/engineering
	icon_state = "emergencyservices_engi"
	insignia_desc = "The back of the medal bears an orange wrench."

/obj/item/clothing/accessory/medal/silver/emergency_services/medical
	icon_state = "emergencyservices_med"
	insignia_desc = "The back of the medal bears a dark blue cross."

/obj/item/clothing/accessory/medal/silver/elder_atmosian
	name = "大气掌控成就奖章"
	desc = "通常被称为\"资深大气学家\"奖，这枚奖章授予那些突破界限、展现大气学领域精湛技艺的杰出科学家和技术人员。"
	icon_state = "elderatmosian"
