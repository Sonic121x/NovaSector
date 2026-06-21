/datum/instrument/tones
	name = "理想音色"
	category = "Tones"
	abstract_type = /datum/instrument/tones

/datum/instrument/tones/square_wave
	name = "理想方波"
	id = "square"
	real_samples = list("81"='sound/runtime/instruments/synthesis_samples/tones/Square.ogg')

/datum/instrument/tones/sine_wave
	name = "理想正弦波"
	id = "sine"
	real_samples = list("81"='sound/runtime/instruments/synthesis_samples/tones/Sine.ogg')

/datum/instrument/tones/saw_wave
	name = "理想锯齿波"
	id = "saw"
	real_samples = list("81"='sound/runtime/instruments/synthesis_samples/tones/Sawtooth.ogg')
