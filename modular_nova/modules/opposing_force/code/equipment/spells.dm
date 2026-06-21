/datum/opposing_force_equipment/spells
	category = OPFOR_EQUIPMENT_CATEGORY_SPELLS

/datum/opposing_force_equipment/spells/fireball
	name = "火球术"
	item_type = /obj/item/book/granter/action/spell/fireball
	description = "这个法术会向目标发射一枚爆炸性的火球。"
	admin_note = "WARNING: This spells has a fairly short cooldown, and can KO/kill on its own."

/datum/opposing_force_equipment/spells/sacredflame
	name = "神圣火焰"
	item_type = /obj/item/book/granter/action/spell/sacredflame
	description = "使你周围的每个人都变得更易燃，并点燃你自己。"

/datum/opposing_force_equipment/spells/smoke
	name = "烟雾术"
	item_type = /obj/item/book/granter/action/spell/smoke
	description = "这个法术会在你的位置生成一团令人窒息的烟雾。"

/datum/opposing_force_equipment/spells/blind
	name = "致盲术"
	item_type = /obj/item/book/granter/action/spell/blind
	description = "这个法术会暂时致盲单个目标。"
	admin_note = "WARNING: Notably strong in 1-v-1s."

/datum/opposing_force_equipment/spells/mindswap
	name = "心灵交换"
	item_type = /obj/item/book/granter/action/spell/mindswap
	description = "这个法术允许使用者与身旁的目标交换身体。"
	admin_note = "WARNING: This spells allows the user to swap minds with someone else, and is overall very strong."

/datum/opposing_force_equipment/spells/forcewall
	name = "力场墙"
	item_type = /obj/item/book/granter/action/spell/forcewall
	description = "创造一个只有你能通过的魔法屏障。"

/datum/opposing_force_equipment/spells/knock
	name = "敲击术"
	item_type = /obj/item/book/granter/action/spell/knock
	description = "这个法术会打开附近的门和储物柜。"

/datum/opposing_force_equipment/spells/charge
	name = "充能术"
	item_type = /obj/item/book/granter/action/spell/charge
	description = "这个法术可用于为你手中的各种物品充能，从魔法神器到电子元件。有创意的巫师甚至可以用它来为其他魔法使用者赋予魔力。"
	admin_note = "This one can be used for some fuckery (such as recharging martial art granters, sometimes), be a bit careful."

/datum/opposing_force_equipment/spells/summonitem
	name = "物品召唤"
	item_type = /obj/item/book/granter/action/spell/summonitem
	description = "这个法术可用于将先前标记过的物品从宇宙任何地方召回至你手中。"
	admin_note = "WARNING: This spells lets them summon anything they can hold, for as long as it exists, or they can still cast the spells."

/datum/opposing_force_equipment/martial_art
	category = OPFOR_EQUIPMENT_CATEGORY_SCROLLS

/datum/opposing_force_equipment/martial_art/cqc
	name = "CQC手册"
	item_type = /obj/item/book/granter/martial/cqc
	description = "一本在自毁前教授单名使用者战术性近身格斗的手册。"
	admin_note = "CQC is capable of knocking out a target in 3 hits and is equivalent to 23 TC."

/datum/opposing_force_equipment/martial_art/carp
	name = "睡鲤卷轴"
	item_type = /obj/item/book/granter/martial/carp
	description = "This scroll contains the secrets of an ancient martial arts technique. You will master unarmed combat \
			and gain the ability to swat bullets from the air, but you will also refuse to use dishonorable ranged weaponry."
	admin_note = "Sleeping Carp is capable of letting you reflect bullets."

/datum/opposing_force_equipment/martial_art/kravmaga
	name = "马伽术植入器"
	item_type = /obj/item/implanter/kaza_ruk
	description = "不需要手套！这个方便的植入器会教你所有关于马伽术的知识。"

/datum/opposing_force_equipment/martial_art/wrestling
	name = "摔跤腰带"
	item_type = /obj/item/storage/belt/champion/wrestling
	description = "凭借这条腰带所蕴含的MACHO力量，学习MACHO的摔跤艺术！"
	admin_note = "Warning: Very powerful if questionably unbeatable in a 1v1, very capable of chain-stunning just about anyone (from range, if they can get on a table)"

/datum/opposing_force_equipment/martial_art/mushpunch
	name = "蘑菇拳蘑菇"
	item_type = /obj/item/mushpunch
	description = "吃下这颗蘑菇以学习蘑菇拳！这是一种强大的攻击，能将人击飞。"
