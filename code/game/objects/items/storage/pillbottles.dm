
/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "药瓶"
	desc = "这是一个用于储存药物的密封容器。"
	icon_state = "pill_canister"
	icon = 'icons/obj/medical/chemical.dmi'
	inhand_icon_state = "contsolid"
	worn_icon_state = "nothing"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	pickup_sound = 'sound/items/handling/pill_bottle_pickup.ogg'
	drop_sound = 'sound/items/handling/pill_bottle_place.ogg'
	storage_type = /datum/storage/pillbottle

	///Number of pills to spawn
	VAR_PROTECTED/spawn_count
	///Pill type to spawn
	VAR_PROTECTED/obj/item/reagent_containers/applicator/pill/spawn_type

/obj/item/storage/pill_bottle/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正试图拧开[src]的盖子！看起来[user.p_theyre()]想要自杀！"))
	return TOXLOSS

/obj/item/storage/pill_bottle/PopulateContents()
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!spawn_count)
		return

	for(var/i in 1 to spawn_count)
		new spawn_type(src)

/obj/item/storage/pill_bottle/multiver
	name = "一瓶多效解毒药片"
	desc = "含有用于对抗毒素的药片。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/multiver

/obj/item/storage/pill_bottle/multiver/less
	spawn_count = 3

/obj/item/storage/pill_bottle/epinephrine
	name = "一瓶肾上腺素药片"
	desc = "含有用于稳定患者状态的药片。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/epinephrine

/obj/item/storage/pill_bottle/mutadone
	name = "一瓶突变矫正药片"
	desc = "含有用于治疗基因异常的药片。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/mutadone

/obj/item/storage/pill_bottle/potassiodide
	name = "一瓶碘化钾药片"
	desc = "含有用于减轻辐射损伤的药片。"
	spawn_count = 3
	spawn_type = /obj/item/reagent_containers/applicator/pill/potassiodide

/obj/item/storage/pill_bottle/probital
	name = "一瓶创伤治疗药片"
	desc = "含有用于治疗钝器损伤的药片。瓶内标签注明'服用前需进食，可能导致疲劳'。"
	spawn_count = 4
	spawn_type = /obj/item/reagent_containers/applicator/pill/probital

/obj/item/storage/pill_bottle/iron
	name = "一瓶铁质补充药片"
	desc = "含有用于缓慢减少失血的药片。瓶内标签注明'每五分钟仅能服用一片'。"
	spawn_count = 4
	spawn_type = /obj/item/reagent_containers/applicator/pill/iron

/obj/item/storage/pill_bottle/mannitol
	name = "一瓶甘露醇药片"
	desc = "含有用于治疗脑损伤的药片。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/mannitol

//Contains 4 pills instead of 7, and 5u pills instead of 50u (50u pills heal 250 brain damage, 5u pills heal 25)
/obj/item/storage/pill_bottle/mannitol/braintumor
	desc = "含有稀释药片，用于缓解脑肿瘤症状。感到头晕时服用一片。"
	spawn_count = 4
	spawn_type = /obj/item/reagent_containers/applicator/pill/mannitol/braintumor

/obj/item/storage/pill_bottle/stimulant
	name = "一瓶兴奋剂药片"
	desc = "保证在漫长轮班期间为您提供额外的能量爆发！"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/stimulant

/obj/item/storage/pill_bottle/sansufentanyl
	name = "一瓶实验性药物"
	desc = "一个由Interdyne Pharmaceuticals开发的药瓶。用于治疗遗传性多重疾病。"
	spawn_count = 6
	spawn_type = /obj/item/reagent_containers/applicator/pill/sansufentanyl

/obj/item/storage/pill_bottle/mining
	name = "一罐贴片"
	desc = "包含用于治疗钝器伤和烧伤的贴片。"
	spawn_count = 3
	spawn_type = /obj/item/reagent_containers/applicator/patch/libital

/obj/item/storage/pill_bottle/zoom
	name = "可疑的药瓶"
	desc = "标签相当陈旧，几乎无法辨认，你认出了一些化学化合物。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/zoom

/obj/item/storage/pill_bottle/happy
	name = "可疑的药瓶"
	desc = "瓶顶上有一个笑脸。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/happy

/obj/item/storage/pill_bottle/lsd
	name = "可疑的药瓶"
	desc = "上面有一个粗糙的图画，可能是一个蘑菇，也可能是一个变形的月亮。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/lsd

/obj/item/storage/pill_bottle/aranesp
	name = "可疑的药瓶"
	desc = "标签上用黑色记号笔潦草地写着'去他妈的电击枪'。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/aranesp

/obj/item/storage/pill_bottle/psicodine
	name = "一瓶赛可定药片"
	desc = "包含用于治疗精神困扰和创伤的药片。"
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/psicodine

/obj/item/storage/pill_bottle/penacid
	name = "一瓶喷替酸药片"
	desc = "包含用于清除辐射和毒素的药片。"
	spawn_count = 3
	spawn_type = /obj/item/reagent_containers/applicator/pill/penacid

/obj/item/storage/pill_bottle/neurine
	name = "一瓶神经碱药片"
	desc = "包含用于治疗非严重精神创伤的药片。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/neurine

/obj/item/storage/pill_bottle/maintenance_pill
	name = "一瓶维护药片"
	desc = "一个旧药瓶。闻起来有霉味。"
	spawn_type = /obj/item/reagent_containers/applicator/pill/maintenance

/obj/item/storage/pill_bottle/maintenance_pill/Initialize(mapload)
	if(!spawn_count)
		spawn_count = rand(1,7)
	. = ..()
	var/obj/item/reagent_containers/applicator/pill/P = locate() in src
	name = "一瓶[P.name]"

/obj/item/storage/pill_bottle/maintenance_pill/full
	spawn_count = 7

///////////////////////////////////////// Psychologist inventory pillbottles
/obj/item/storage/pill_bottle/happinesspsych
	name = "快乐药丸"
	desc = "内含用于作为最后手段暂时稳定抑郁和焦虑的药丸。警告：副作用可能包括言语不清、流口水和严重成瘾。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/happinesspsych

/obj/item/storage/pill_bottle/lsdpsych
	name = "致幻毒素药丸"
	desc = "！仅供治疗使用！内含用于缓解现实解离综合征症状的药丸。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/lsdpsych

/obj/item/storage/pill_bottle/paxpsych
	name = "和平药丸"
	desc = "内含用于暂时安抚被认为对自己或他人构成伤害的患者的药丸。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/paxpsych

/obj/item/storage/pill_bottle/naturalbait
	name = "新鲜度罐"
	desc = "装满天然鱼饵。"
	spawn_count = 7
	spawn_type = /obj/item/food/bait/natural

/obj/item/storage/pill_bottle/ondansetron
	name = "昂丹司琼贴片"
	desc = "一瓶装有昂丹司琼贴片，这是一种用于治疗恶心和呕吐的药物。可能导致嗜睡。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/patch/ondansetron

/obj/item/storage/pill_bottle/immunodeficiency
	name = "免疫增强剂瓶"
	desc = "内含免疫系统增强剂，用于管理慢性免疫缺陷。"
	spawn_count = 5
	spawn_type = /obj/item/reagent_containers/applicator/pill/spaceacillin

/obj/item/storage/pill_bottle/prescription_stimulant
	name = "处方兴奋剂药丸瓶"
	desc = "A bottle of mild and medicinally approved stimulants to help prevent drowsiness. \n\
		The list of substances reads: Contains 3u modafinil, 5u synaptizine and 5u glucose. \n\
		A warning label reads: <b>Take in moderation</b>."
	spawn_count = 7
	spawn_type = /obj/item/reagent_containers/applicator/pill/prescription_stimulant
