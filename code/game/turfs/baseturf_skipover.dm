// This is a typepath to just sit in baseturfs and act as a marker for other things.
/turf/baseturf_skipover
	name = "Baseturf 跳过占位符"
	desc = "这不应该存在"

/turf/baseturf_skipover/Initialize(mapload)
	. = ..()
	stack_trace("[src]([type]) was instanced which should never happen. Changing into the next baseturf down...")
	ScrapeAway()

/turf/baseturf_skipover/shuttle
	name = "穿梭机底草皮跳过"
	desc = "充当穿梭机的底部，如果这里不在这里，穿梭机地板就会被突破。"

/turf/baseturf_skipover/trapdoor
	name = "活板门基底地形跳过层"
	desc = "充当受活板门影响的基底地形堆栈的底部。"

/turf/baseturf_bottom
	name = "Z 层 baseturf 占位符"
	desc = "z 水平基层的标记，通常解析为空间。"
	baseturfs = /turf/baseturf_bottom
