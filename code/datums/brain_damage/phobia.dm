/datum/brain_trauma/mild/phobia
	name = "Phobia"
	desc = "Patient is unreasonably afraid of something."
	scan_desc = "phobia"
	symptoms = "When exposed to a specific stimulus, experiences \
		an immediate anxiety or fear response far greater than typically expected, \
		leading to panic attacks or impaired social and occupational functioning. \
		Physical contact such as hugging, or medication such as Psicodine may lessen the severity of the reaction."
	gain_text = span_warning("You start finding default values very unnerving...")
	lose_text = span_notice("You no longer feel afraid of default values.")
	/// What do we fear exactly?
	var/phobia_type
	/// Specific terror handler to apply, in case we want
	var/terror_handler = /datum/terror_handler/phobia_source
	/// What mood event to apply when we see the thing & freak out.
	var/mood_event_type = /datum/mood_event/phobia

/datum/brain_trauma/mild/phobia/New(new_phobia_type)
	if(new_phobia_type)
		phobia_type = new_phobia_type

	if(!phobia_type)
		phobia_type = pick(GLOB.phobia_types)

	// NOVA EDIT CHANGE START - i18n: 三条句子的**模板**早就在目录里也译好了，缺的一直是填进去的
	// 那个类别词 —— 它是标识符（phobia_regexes 的下标、phobia.json 的匹配键），不能进全局反查表，
	// 所以在这里经域内表 lang_phobia_label() 换成显示标签再交给 LANG。
	// ORIGINAL: gain_text = span_warning("You start finding [phobia_type] very unnerving...")
	// ORIGINAL: lose_text = span_notice("You no longer feel afraid of [phobia_type].")
	var/phobia_label = lang_phobia_label(phobia_type)
	gain_text = span_warning(LANG("datum.dfd79bb138a5ec74", list(phobia_label)))
	lose_text = span_notice(LANG("datum.200091e90b512273", list(phobia_label)))
	// NOVA EDIT CHANGE START - i18n: 整条重建而不是追加后缀。原写法拼出来的 "phobia of space"
	// 是运行期产物、永远不是目录键，医疗扫描与 SDSM 手册那一列因此恒为英文；而中文语序是
	// 「太空恐惧症」，后缀式拼接排不出来，必须整条走模板。本类型及其全部子类都没有覆写
	// scan_desc（子类只设 phobia_type），所以把前缀写进模板是等价的。
	// ORIGINAL: scan_desc += " of [phobia_type]"
	scan_desc = LANG("datum.3ea1416777413765", list(phobia_label))
	// NOVA EDIT CHANGE END
	return ..()

/datum/brain_trauma/mild/phobia/on_gain()
	. = ..()
	var/datum/component/fearful/fear = owner.AddComponentFrom(REF(src), /datum/component/fearful, list(/datum/terror_handler/startle))
	var/datum/terror_handler/phobia_source/phobia = fear.add_handler(terror_handler, REF(src))
	phobia.trigger_regex = GLOB.phobia_regexes[phobia_type]
	phobia.trigger_regex_localized = construct_phobia_regex_localized(phobia_type) // NOVA EDIT ADDITION - i18n: 中文触发词（无词边界，另建正则）
	phobia.trigger_mobs = GLOB.phobia_mobs[phobia_type]
	phobia.trigger_objs = GLOB.phobia_objs[phobia_type]
	phobia.trigger_turfs = GLOB.phobia_turfs[phobia_type]
	phobia.trigger_species = GLOB.phobia_species[phobia_type]
	phobia.mood_event_type = mood_event_type

/datum/brain_trauma/mild/phobia/on_lose(silent)
	. = ..()
	owner.RemoveComponentSource(REF(src), /datum/component/fearful)

// Defined phobia types for badminry, not included in the RNG trauma pool to avoid diluting.

/datum/brain_trauma/mild/phobia/aliens
	phobia_type = "aliens"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/anime
	phobia_type = "anime"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/authority
	phobia_type = "authority"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/birds
	phobia_type = "birds"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/blood
	phobia_type = "blood"
	random_gain = FALSE
	terror_handler = /datum/terror_handler/phobia_source/blood

/datum/brain_trauma/mild/phobia/clowns
	phobia_type = "clowns"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/conspiracies
	phobia_type = "conspiracies"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/doctors
	phobia_type = "doctors"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/falling
	phobia_type = "falling"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/fish
	phobia_type = "fish"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/greytide
	phobia_type = "greytide"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/guns
	phobia_type = "guns"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/insects
	phobia_type = "insects"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/lizards
	phobia_type = "lizards"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/ocky_icky
	phobia_type = "ocky icky"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/robots
	phobia_type = "robots"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/security
	phobia_type = "security"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/skeletons
	phobia_type = "skeletons"
	mood_event_type = /datum/mood_event/spooked
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/snakes
	phobia_type = "snakes"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/space
	phobia_type = "space"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/spiders
	phobia_type = "spiders"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/strangers
	phobia_type = "strangers"
	random_gain = FALSE

/datum/brain_trauma/mild/phobia/supernatural
	phobia_type = "the supernatural"
	random_gain = FALSE
