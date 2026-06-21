/datum/language/yangyu
	name = "洋语"
	desc = "亦广为人知地被称为“近音”，这一被正式视为轨道汉藏语系的语言群体，源于汉语、藏语、缅甸语及其他具有相似特征的人类语言之间的谱系关系，该关系最早于19世纪初被提出，即便在太空时代也极为流行。起源于亚洲，自太阳通用语诞生以来，这一语系是人类及人类衍生族群中使用第二广泛的语言——并且曾是太阳联邦官方语言的主要竞争者。许多来自日语、琉球语、韩语及其他社会的借词、习语和文化遗存得以在其中延续，尤其是在来自火星城市的说话者的日常生活中。"
	key = "Y"
	flags = TONGUELESS_SPEECH
	space_chance = 70
	sentence_chance = 0
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = -1
	additional_syllable_high = 1
	// Entirely Chinese save for the isolated 2 "nya" style syllables. I don't want to bloat the syllable list with other mixes, but they generally sound somewhat alike.
	syllables = list (
		"ai", "ang", "bai", "beng", "bian", "biao", "bie", "bing", "cai", "can", "cao", "cei", "ceng", "chai", "chan", "chang",
		"chen", "chi", "chong", "chou", "chu", "chuai", "chuang", "chui", "chun", "dai", "dao", "dang", "deng", "diao", "dong", "duan",
		"fain", "fang", "feng", "fou", "gai", "gang", "gao", "gong", "guai", "guang", "hai", "han", "hang", "hao", "heng", "huai", "ji", "jiang",
		"jiao", "jin", "jun", "kai", "kang", "kong", "kuang", "lang", "lao", "liang", "ling", "long", "luan", "mao", "meng", "mian", "miao",
		"ming", "miu", "nyai", "nang", "nao", "neng", "nyang", "nuan", "qi", "qiang", "qiao", "quan", "qing", "sen", "shang", "shao", "shuan", "song", "tai",
		"tang", "tian", "tiao", "tong", "tuan", "wai", "wang", "wei", "weng", "xi", "xiang", "xiao", "xie", "xin", "xing", "xiong", "xiu", "xuan", "xue", "yan", "yang",
		"yao", "yin", "ying", "yong", "yuan", "zang", "zao", "zeng", "zhai", "zhang",
		"zhen", "zhi", "zhuai", "zhui", "zou", "zun", "zuo"
	)
	icon_state = "hanzi"
	icon = 'modular_nova/master_files/icons/misc/language.dmi'
	default_priority = 94
	default_name_syllable_min = 1
	default_name_syllable_max = 2
