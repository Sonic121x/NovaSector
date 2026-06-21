/obj/item/instrument/violin/festival
	name = "思弦"
	desc = "一把对其琴弦演奏出的乐曲抱有特殊兴趣的小提琴。"
	icon_state = "holy_violin"
	inhand_icon_state = "holy_violin"

/obj/item/instrument/violin/festival/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_INSTRUMENT_START, PROC_REF(on_instrument_start))

/// signal fired when the festival instrument starts to play.
/obj/item/instrument/violin/festival/proc/on_instrument_start(datum/source, datum/song/starting_song, atom/player)
	SIGNAL_HANDLER

	if(!starting_song || !isliving(player))
		return
	analyze_song(starting_song, player)

///Reports some relevant information when the song begins playing.
/obj/item/instrument/violin/festival/proc/analyze_song(datum/song/song, mob/living/playing_song)
	var/list/analysis = list()
	//check tempo and lines
	var/song_length = song.lines.len * song.tempo
	analysis += span_revenbignotice("[src] 对你低语...")
	analysis += span_revennotice("这首乐曲有 <b>[song.lines.len]</b> 行，节拍为 <b>[song.tempo]</b>。")
	analysis += span_revennotice("将两者相乘，得到乐曲长度为 <b>[song_length]</b>。")
	analysis += span_revennotice("要在一场演奏结束时从 [GLOB.deity] 那里获得增益效果，你需要一首长度达到 <b>[FESTIVAL_SONG_LONG_ENOUGH]</b> 的乐曲。")

	to_chat(playing_song, analysis.Join("\n"))
