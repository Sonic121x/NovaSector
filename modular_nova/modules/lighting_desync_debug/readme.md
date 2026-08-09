## 静态光照失配诊断 (Lighting Desync Debug)

Module ID: LIGHTING_DESYNC_DEBUG

### Description:

诊断用管理员 verb，用来排查「瞬移 / 下楼梯 / 鬼魂观察落地后整屏静态光照缺失呈灰色，且不会自愈」这个问题。

**这个模块不修复任何东西**，它只提供一次判别实验的手段。加它是因为该现象只在生产服（高人数、公网延迟）稳定复现，本地空服复现不出等效形态，无法离线验证修法。

已经排除的可能：

- 汉化层：`code/modules/lighting`、`code/_onclick/hud` 相对上游零差异
- BYOND 版本：升到 516.1686（含 1683 的 VIS_HIDE / 错误 appearance ID 修复）后依旧复现；1686 已是 516 线最新
- 服务端算不完：MC 面板显示 `Lighting Sources:0|Corners:73|Objects:3`，队列是空的，仅占 5% tick
- 渲染管线整体故障：手持光源（`OVERLAY_LIGHT_DIRECTIONAL`，走 `O_LIGHTING_VISUAL_PLANE`）的光斑正常可见

现有事实指向：服务端算好了，客户端没收到 `turf.vis_contents` 里 `lighting_object` 的外观，而服务端认为已发送、不再重发。只有静态光照真正变化（开门 → `reconsider_lights()`）或格子重新进入视野才会恢复；手持光源经过**不能**恢复，因为覆盖层光照根本不碰 turf 光照角落。

### 用法

管理员（`R_DEBUG`，即 Coder 及以上）在 Debug 分类下调用 **调试-刷新视野静态光照**，选择三种策略之一：

| 策略 | 做法 | 预期 |
| --- | --- | --- |
| 仅重算外观 (update) | 调 `lighting_object.update()` | 若外观算出来不变，BYOND 不重发 → **无效** |
| vis_contents 摘除再加回 | 从 `turf.vis_contents` 移除再添加 | 结构变更，BYOND 必须传输 → **有效** |
| 强制改变外观再还原 | 先改成 `lighting_dark`，跨 tick 后 `update()` 还原 | 必定产生外观 diff → 有效但粗暴 |

三者成败互为对照。**若「仅重算外观」无效而「vis_contents 摘除再加回」有效，即证实重发被外观 diff 抑制**，届时再决定把哪种手段挂到哪个时机（`client.eye` 大跳 / 换 z 层 / Login）上自动执行，并评估成本（一屏约 225–361 个 turf）。

结论确定后，这个模块应当被真正的修复取代或删除。

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- N/A

### Defines:

- `modular_nova/modules/lighting_desync_debug/code/lighting_desync_debug.dm`：`LIGHTING_REFRESH_UPDATE`、`LIGHTING_REFRESH_VIS_CONTENTS`、`LIGHTING_REFRESH_FORCE_DIFF`，均在文件底部 `#undef`

### Included files that are not contained in this module:

- N/A

### Credits:

sernseek
