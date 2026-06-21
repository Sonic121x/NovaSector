#define SPELLBOOK_CATEGORY_OFFENSIVE "Offensive"
// Offensive wizard spells
/datum/spellbook_entry/fireball
	name = "火球"
	desc = "向目标发射一个爆炸火球。在所有巫师中被认为是经典技能。"
	spell_type = /datum/action/cooldown/spell/pointed/projectile/fireball
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/spell_cards
	name = "魔法卡"
	desc = "炽热疾速的追踪卡牌。用它们神秘的力量将你的敌人送入暗影领域！"
	spell_type = /datum/action/cooldown/spell/pointed/projectile/spell_cards
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/rod_form
	name = "Rod Form"
	desc = "化身为不动杆，摧毁你前方的一切。多次购买此法术还会增加杖的伤害和射程。"
	spell_type = /datum/action/cooldown/spell/rod_form
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/disintegrate
	name = "惩罚"
	desc = "用一种不祥的能量充盈你的手，可以用来让触碰的目标剧烈爆炸。"
	spell_type = /datum/action/cooldown/spell/touch/smite
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/summon_simians
	name = "Summon Simians"
	desc = "This spell reaches deep into the elemental plane of bananas (the monkey one, not the clown one), and \
		summons primal monkeys and lesser gorillas that will promptly flip out and attack everything in sight. Fun! \
		Their lesser, easily manipulable minds will be convinced you are one of their allies, but only for a minute. Unless you also are a monkey."
	spell_type = /datum/action/cooldown/spell/conjure/simian
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/blind
	name = "失明"
	desc = "暂时使单个目标失明。"
	spell_type = /datum/action/cooldown/spell/pointed/blind
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 1

/datum/spellbook_entry/tie_shoes
	name = "Tie Shoes"
	desc = "This unassuming spell first unties, then knots the target's shoes. While weak at first glance, each upgrade quietens the spell, allowing it to untie laceless footwear and even summon shoes to knot!"
	spell_type = /datum/action/cooldown/spell/pointed/untie_shoes
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 1

/datum/spellbook_entry/mutate
	name = "Mutate"
	desc = "会使你瞬间变成一个庞然大物，并且能短暂获得激光视力。"
	spell_type = /datum/action/cooldown/spell/apply_mutations/mutate
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/fleshtostone
	name = "点肉成石"
	desc = "赋予你的手强大的力量，能将受害者长时间变成毫无反应的雕像。"
	spell_type = /datum/action/cooldown/spell/touch/flesh_to_stone
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/teslablast
	name = "特斯拉爆炸"
	desc = "启动特斯拉电弧并将其释放到随机附近的目标上！在电弧充电期间您可以自由移动。电弧会在目标之间跳跃，并能将其击倒。"
	spell_type = /datum/action/cooldown/spell/charged/beam/tesla
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/lightningbolt
	name = "Lightning Bolt"
	desc = "向你的敌人发射闪电!它会在目标之间跳跃，但不能击倒他们。"
	spell_type = /datum/action/cooldown/spell/pointed/projectile/lightningbolt
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 1

/datum/spellbook_entry/infinite_guns
	name = "次级召唤枪"
	desc = "既然你有无限的枪，为什么还要重新装弹？召唤源源不断的栓动步枪，它们造成的伤害很小，但能击倒目标。使用时需要双手空闲。学习此法术后，你将无法学习奥术弹幕。"
	spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/gun
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 3
	no_coexistence_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage)

/datum/spellbook_entry/arcane_barrage
	name = "奥术齐射"
	desc = "使用此法术，你可以向敌人发射一股强大的神秘能量。其造成的伤害远超“次级召唤枪”，但不会使目标倒下。使用此法术时双手必须是空着的。学习此法术会使你无法再学习“次级召唤枪”。"
	spell_type = /datum/action/cooldown/spell/conjure_item/infinite_guns/arcane_barrage
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 3
	no_coexistence_typecache = list(/datum/action/cooldown/spell/conjure_item/infinite_guns/gun)

/datum/spellbook_entry/barnyard
	name = "牛棚诅咒"
	desc = "这个咒语会让不幸之人丧失理智，变得像牲畜一样，说话和表情都像牲畜一般。"
	spell_type = /datum/action/cooldown/spell/pointed/barnyardcurse
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/splattercasting
	name = "Splattercasting"
	desc = "Dramatically lowers the cooldown on all spells, but each one will cost blood, as well as it naturally \
		draining from you over time. You can replenish it from your victims, specifically their necks."
	spell_type =  /datum/action/cooldown/spell/splattercasting
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	no_coexistence_typecache = list(/datum/action/cooldown/spell/lichdom, /datum/spellbook_entry/ghostliness)

/datum/spellbook_entry/sanguine_strike
	name = "Exsanguinating Strike"
	desc = "Sanguine spell that enchants your next weapon strike to deal more damage, heal you for damage dealt, and refill blood."
	spell_type =  /datum/action/cooldown/spell/sanguine_strike
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/scream_for_me
	name = "Scream For Me"
	desc = "Sadistic sanguine spell that inflicts numerous severe blood wounds all over the victim's body."
	spell_type =  /datum/action/cooldown/spell/touch/scream_for_me
	cost = 1
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/staffchaos
	name = "混乱法杖"
	desc = "A capricious tool that can fire all sorts of magic without any rhyme or reason. Using it on people you care about is not recommended."
	item_path = /obj/item/gun/magic/staff/chaos
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/staffchange
	name = "变化法杖"
	desc = "一种能够释放出耀眼光芒的装置，其释放出的能量能使目标的自身形态发生改变。"
	item_path = /obj/item/gun/magic/staff/change
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/mjolnir
	name = "雷神之锤"
	desc = "A mighty hammer on loan from Thor, God of Thunder. It crackles with barely contained power. Requires wielding it in both hands to unleash its true potential."
	item_path = /obj/item/mjollnir
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/singularity_hammer
	name = "奇点锤"
	desc = "A hammer that creates an intensely powerful field of gravity where it strikes, pulling everything nearby to the point of impact. Requires wielding it in both hands to unleash its true potential."
	item_path = /obj/item/singularityhammer
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/spellblade
	name = "魔刃"
	desc = "一把能够发射能量冲击波的剑，其威力足以将敌人肢解成碎片。"
	item_path = /obj/item/gun/magic/staff/spellblade
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/highfrequencyblade
	name = "高频刃"
	desc = "一把极其锋利的魔法长剑，其振动频率极高，足以将任何物体斩断。"
	item_path = /obj/item/highfrequencyblade/wizard
	category = SPELLBOOK_CATEGORY_OFFENSIVE
	cost = 3

/datum/spellbook_entry/item/frog_contract
	name = "Frog Contract"
	desc = "Sign a pact with the frogs to have your own destructive pet guardian!"
	item_path = /obj/item/frog_contract
	category = SPELLBOOK_CATEGORY_OFFENSIVE

/datum/spellbook_entry/item/staffshrink
	name = "Staff of Shrinking"
	desc = "An artefact that can shrink anything for a reasonable duration. Small structures can be walked over, and small people are very vulnerable (often because their armour no longer fits)."
	item_path = /obj/item/gun/magic/staff/shrink
	category = SPELLBOOK_CATEGORY_OFFENSIVE


#undef SPELLBOOK_CATEGORY_OFFENSIVE
