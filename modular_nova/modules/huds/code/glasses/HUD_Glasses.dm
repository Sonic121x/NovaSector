/obj/item/clothing/glasses/hud/health/prescription
	name = "处方健康扫描仪HUD"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其健康状况的准确数据。这款配有处方镜片。"
	icon = 'modular_nova/modules/huds/icons/huds.dmi'
	icon_state = "glasses_healthhud"
	worn_icon = 'modular_nova/modules/huds/icons/hudeyes.dmi'

/obj/item/clothing/glasses/hud/health/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/obj/item/clothing/glasses/hud/diagnostic/prescription
	name = "处方诊断HUD"
	desc = "一种能够分析机器人和外骨骼完整性与状态的平视显示器。这款配有处方镜片。"
	icon = 'modular_nova/modules/huds/icons/huds.dmi'
	icon_state = "glasses_diagnostichud"
	worn_icon = 'modular_nova/modules/huds/icons/hudeyes.dmi'

/obj/item/clothing/glasses/hud/diagnostic/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/obj/item/clothing/glasses/hud/security/prescription
	name = "处方安保HUD"
	desc = "一种平视显示器，可扫描视野内的人形生物并提供其身份状态和安保记录的准确数据。这款配有处方镜片。"
	icon = 'modular_nova/modules/huds/icons/huds.dmi'
	icon_state = "glasses_securityhud"
	worn_icon = 'modular_nova/modules/huds/icons/hudeyes.dmi'

/obj/item/clothing/glasses/hud/security/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/obj/item/clothing/glasses/science/prescription
	name = "处方科研眼镜"
	desc = "这些眼镜可扫描容器内容物，并以易于阅读的格式将其内容投影给用户。这款配有处方镜片。"
	icon = 'modular_nova/modules/huds/icons/huds.dmi'
	icon_state = "glasses_sciencehud"
	worn_icon = 'modular_nova/modules/huds/icons/hudeyes.dmi'
	glass_colour_type = /datum/client_colour/glass_colour/purple
	armor_type = /datum/armor/prescription_science

/obj/item/clothing/glasses/science/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/datum/armor/prescription_science
	fire = 80
	acid = 100

/obj/item/clothing/glasses/meson/prescription
	name = "处方光学介子扫描仪"
	desc = "供工程与采矿人员使用，可在任何光照条件下透视墙壁，观察基本结构与地形布局。此款配有处方镜片。"

/obj/item/clothing/glasses/meson/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/obj/item/clothing/glasses/meson/engine/prescription
	name = "处方工程扫描护目镜"
	desc = "工程师使用的护目镜。介子扫描模式可透视墙壁观察基本结构与地形布局；T射线扫描模式可观察地板下的电缆、管道等物体；辐射扫描模式可显示受辐射污染的物体。每片镜片均已更换为矫正镜片。"

/obj/item/clothing/glasses/meson/engine/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()

/obj/item/clothing/glasses/meson/engine/tray/prescription
	name = "处方光学T射线扫描仪"
	desc = "工程师使用的护目镜。介子扫描模式可透视墙壁观察基本结构与地形布局；T射线扫描模式可观察地板下的电缆、管道等物体；辐射扫描模式可显示受辐射污染的物体。此款配有帮助矫正视力的镜片。"

/obj/item/clothing/glasses/meson/engine/tray/prescription/Initialize(mapload)
	LAZYADD(clothing_traits, TRAIT_NEARSIGHTED_CORRECTED)
	return ..()
