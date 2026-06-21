#define SPELLBOOK_CATEGORY_ASSISTANCE "Assistance"
// Wizard spells that assist the caster in some way
/datum/spellbook_entry/summonitem
	name = "召唤物品"
	desc = "将之前标记的物品从宇宙中的任何地方召回到你的手中。"
	spell_type = /datum/action/cooldown/spell/summonitem
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	cost = 1

/datum/spellbook_entry/charge
	name = "Charge"
	desc = "这个法术可以用来给你手中的各种东西充能，从魔法神器到电子元件。一个富有创造力的巫师甚至可以用它来授予其他魔法使用者魔法力量。"
	spell_type = /datum/action/cooldown/spell/charge
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	cost = 1

/datum/spellbook_entry/shapeshift
	name = "野性变身"
	desc = "在一段时间内变成其他物种的形态来使用它们的天生能力。选择后无法更改。"
	spell_type = /datum/action/cooldown/spell/shapeshift/wizard
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	cost = 1

/datum/spellbook_entry/tap
	name = "灵魂汲取"
	desc = "用你自己的灵魂为你的法术提供能量！"
	spell_type = /datum/action/cooldown/spell/tap
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	cost = 1

/datum/spellbook_entry/item/staffanimation
	name = "赋生之杖"
	desc = "一根奥术权杖，能够射出一连串的邪术能量，使无生命的物体复活。这个魔法不会影响机器设备。"
	item_path = /obj/item/gun/magic/staff/animate
	category = SPELLBOOK_CATEGORY_ASSISTANCE

/datum/spellbook_entry/item/soulstones
	name = "灵魂石碎片套件"
	desc = "Soul Stone Shards are ancient tools capable of capturing and harnessing the spirits of the dead and dying. \
		The spell Artificer allows you to create arcane machines for the captured souls to pilot."
	item_path = /obj/item/storage/belt/soulstone/full
	category = SPELLBOOK_CATEGORY_ASSISTANCE

/datum/spellbook_entry/item/soulstones/try_equip_item(mob/living/carbon/human/user, obj/item/to_equip)
	var/was_equipped = user.equip_to_slot_if_possible(to_equip, ITEM_SLOT_BELT, disable_warning = TRUE)
	to_chat(user, span_notice("\A [to_equip.name] 已被召唤 [was_equipped ? "on your waist" : "at your feet"]。"))

/datum/spellbook_entry/item/soulstones/buy_spell(mob/living/carbon/human/user, obj/item/spellbook/book, log_buy = TRUE)
	. =..()
	if(!.)
		return

	var/datum/action/cooldown/spell/conjure/construct/bonus_spell = new(user.mind || user)
	bonus_spell.Grant(user)

/datum/spellbook_entry/item/necrostone
	name = "一块死灵石"
	desc = "死灵石能够让你复活三名死者，变成骷髅仆从供你指挥。"
	item_path = /obj/item/necromantic_stone
	category = SPELLBOOK_CATEGORY_ASSISTANCE

/datum/spellbook_entry/item/contract
	name = "契约学徒"
	desc = "一个魔法契约，能约束一个学徒巫师为你服务，使用后能将他们召唤到你身边。"
	item_path = /obj/item/antag_spawner/contract
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	refundable = TRUE

/datum/spellbook_entry/item/guardian
	name = "守护者套装"
	desc = "A deck of guardian tarot cards, capable of binding a personal guardian to your body. There are multiple types of guardian available, but all of them will transfer some amount of damage to you. \
	It would be wise to avoid buying these with anything capable of causing you to swap bodies with others."
	item_path = /obj/item/guardian_creator/wizard
	category = SPELLBOOK_CATEGORY_ASSISTANCE

/datum/spellbook_entry/item/bloodbottle
	name = "一瓶血"
	desc = "A bottle of magically infused blood, the smell of which will \
		attract extradimensional beings when broken. Be careful though, \
		the kinds of creatures summoned by blood magic are indiscriminate \
		in their killing, and you yourself may become a victim."
	item_path = /obj/item/antag_spawner/slaughter_demon
	limit = 3
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	refundable = TRUE

/datum/spellbook_entry/item/hugbottle
	name = "瓶装笑声"
	desc = "A bottle of magically infused fun, the smell of which will \
		attract adorable extradimensional beings when broken. These beings \
		are similar to slaughter demons, but they do not permanently kill \
		their victims, instead putting them in an extradimensional hugspace, \
		to be released on the demon's death. Chaotic, but not ultimately \
		damaging. The crew's reaction to the other hand could be very \
		destructive."
	item_path = /obj/item/antag_spawner/slaughter_demon/laughter
	cost = 1 //non-destructive; it's just a jape, sibling!
	limit = 3
	category = SPELLBOOK_CATEGORY_ASSISTANCE
	refundable = TRUE

/datum/spellbook_entry/item/vendormancer
	name = "Scepter of Vendormancy"
	desc = "A scepter containing the power of Runic Vendormancy.\
		It can summon up to 3 Runic Vendors that decay over time, but can be \
		throw around to squash oponents or be directly detonated. When out of \
		charges a long channel will restore the charges."
	item_path = /obj/item/runic_vendor_scepter
	category = SPELLBOOK_CATEGORY_ASSISTANCE

#undef SPELLBOOK_CATEGORY_ASSISTANCE
