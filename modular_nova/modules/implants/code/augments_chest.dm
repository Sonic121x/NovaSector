// for readability's sake, define here to match the healthscan() proc's use of it
// if someone updates that upstream, fix that here too, wouldja?

/obj/item/organ/cyberimp/chest/scanner
	name = "内置健康分析仪"
	desc = "一种先进的健康分析仪植入体，设计用于直接与宿主体内接口，并按指令将扫描信息中继至大脑。"
	slot = ORGAN_SLOT_SCANNER
	icon = 'modular_nova/modules/implants/icons/chest_modular.dmi'
	icon_state = "internal_HA"
	actions_types = list(/datum/action/item_action/organ_action/use/internal_analyzer)
	w_class = WEIGHT_CLASS_SMALL
	/// Whether or not we have the chemical scan feature
	var/has_chem_scan = TRUE
	var/advanced_scan_allowed = TRUE

/datum/action/item_action/organ_action/use/internal_analyzer
	desc = "左键：健康扫描。右键：化学扫描。要求植入的分析仪未因电磁脉冲或其他原因失效。不提供治疗辅助。"

/datum/action/item_action/organ_action/use/internal_analyzer/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return
	var/obj/item/organ/cyberimp/chest/scanner/our_scanner = target
	if(our_scanner.organ_flags & ORGAN_FAILING)
		to_chat(owner, span_warning("你的健康分析仪报告了一个错误！它无法在你当前的身体状况下进行接口连接！"))
		return
	if(our_scanner.has_chem_scan && (trigger_flags & TRIGGER_SECONDARY_ACTION))
		chemscan(owner, owner)
	if(our_scanner.advanced_scan_allowed)
		healthscan(owner, owner, SCANNER_VERBOSE, TRUE)
	else
		healthscan(owner, owner, SCANNER_CONDENSED, TRUE)


/obj/item/organ/cyberimp/chest/scanner/lite
	actions_types = list(/datum/action/item_action/organ_action/use/internal_analyzer/lite)
	has_chem_scan = FALSE
	advanced_scan_allowed = FALSE

/datum/action/item_action/organ_action/use/internal_analyzer/lite
	desc = "左键：健康扫描。要求植入的分析仪未因电磁脉冲或其他原因失效。不提供治疗辅助。"

/obj/item/organ/cyberimp/chest/opticalcamo
	name = "光学迷彩植入体"
	desc = "一种植入体，能在激活时弯曲宿主身体周围的光线，使其近乎隐形。"
	icon = 'modular_nova/modules/implants/icons/chest_modular.dmi'
	icon_state = "opticalcamo"
	slot = ORGAN_SLOT_SPINE
	w_class = WEIGHT_CLASS_NORMAL
	actions_types = list(/datum/action/item_action/organ_action/toggle)
	var/on = FALSE /// Whether the implant is active or not
	var/bumpoff = TRUE /// Controls if getting 'bumped' or doing disallowed actions (shooting, hitting, etc) disables the implant
	var/stealth_alpha = 45 /// Controls the alpha of the use
	var/poison_amount = 3 /// The amount of poison you get from each emp_act

/obj/item/organ/cyberimp/chest/opticalcamo/ui_action_click()
	toggle()

/obj/item/organ/cyberimp/chest/opticalcamo/on_mob_remove(mob/living/carbon/organ_owner)
	if(on)
		deactivate(silent = TRUE)
	return ..()

/// Activates or deactivates the implant
/obj/item/organ/cyberimp/chest/opticalcamo/proc/toggle(silent = FALSE)
	if(on)
		deactivate()
	else
		activate()

/obj/item/organ/cyberimp/chest/opticalcamo/proc/activate(silent = FALSE)
	if(on)
		return
	if(organ_flags & ORGAN_FAILING)
		if(!silent)
			to_chat(owner, span_warning("你的光学迷彩似乎坏了！"))
		return
	if(bumpoff)
		RegisterSignal(owner, COMSIG_LIVING_MOB_BUMP, PROC_REF(unstealth))
	RegisterSignal(owner, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))
	RegisterSignal(owner, COMSIG_ATOM_BULLET_ACT, PROC_REF(on_bullet_act))
	RegisterSignals(owner,
		list(
			COMSIG_MOB_ITEM_ATTACK,
			COMSIG_ATOM_ATTACKBY,
			COMSIG_ATOM_ATTACK_HAND,
			COMSIG_ATOM_HITBY,
			COMSIG_ATOM_HULK_ATTACK,
			COMSIG_ATOM_ATTACK_PAW,
			COMSIG_CARBON_CUFF_ATTEMPTED,
			COMSIG_MOB_FIRED_GUN
		), PROC_REF(unstealth)
	)
	animate(owner, alpha = stealth_alpha, time = 15 SECONDS)
	on = TRUE
	if(!silent)
		to_chat(owner, span_notice("你开启了光学迷彩。"))

/obj/item/organ/cyberimp/chest/opticalcamo/proc/deactivate(silent = FALSE)
	if(!on)
		return
	if(bumpoff)
		UnregisterSignal(owner, COMSIG_LIVING_MOB_BUMP)
	UnregisterSignal(owner, list(
		COMSIG_LIVING_UNARMED_ATTACK,
		COMSIG_MOB_ITEM_ATTACK,
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_BULLET_ACT,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_HULK_ATTACK,
		COMSIG_ATOM_ATTACK_PAW,
		COMSIG_CARBON_CUFF_ATTEMPTED,
		COMSIG_MOB_FIRED_GUN
	))
	animate(owner, alpha = 255, time = 1.5 SECONDS)
	on = FALSE
	if(!silent)
		to_chat(owner, span_notice("你关闭了光学迷彩。"))

/// Handles removing their stealth when bump-off is triggered
/obj/item/organ/cyberimp/chest/opticalcamo/proc/unstealth(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_warning("[src] 因接触而放电了！"))
	do_sparks(2, TRUE, src)
	deactivate()

/obj/item/organ/cyberimp/chest/opticalcamo/proc/on_unarmed_attack(datum/source, atom/target)
	SIGNAL_HANDLER

	if(!isliving(target))
		return
	unstealth(source)

/obj/item/organ/cyberimp/chest/opticalcamo/proc/on_bullet_act(datum/source, obj/projectile/projectile)
	SIGNAL_HANDLER

	if(!projectile.is_hostile_projectile())
		return
	unstealth(source)

/obj/item/organ/cyberimp/chest/opticalcamo/emp_act(severity)
	. = ..()
	if(!owner || . & EMP_PROTECT_SELF)
		return
	owner.reagents.add_reagent(/datum/reagent/drug/saturnx, poison_amount / severity)
	owner.adjust_confusion(rand(8 SECONDS, 11 SECONDS))
	to_chat(owner, span_warning("你的皮肤感到刺痛，房间仿佛在旋转！"))
	unstealth()

