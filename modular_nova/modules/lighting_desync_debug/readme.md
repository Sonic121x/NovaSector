## 静态光照失配修复 (Lighting Desync)

Module ID: LIGHTING_DESYNC_DEBUG

### Description:

给玩家一个自助按钮，修复「瞬移 / 下楼梯 / 鬼魂观察落地 / 新出生后整屏静态光照缺失呈灰色，且不会自愈」这个问题。

OOC 分类下的 **修复光照bug**，任何玩家都能用，10 秒冷却。按下后把视野内的静态光照强制重画一遍。

### 为什么是手动而不是自动

自动版本写过、能编译，但撤掉了：**根因没查清**——不知道为什么只有高人数服触发，也就无法断定触发点是否覆盖全部场景。在这种前提下让全服在每次视点跳变时都付出代价（约 225–361 个 turf、两趟外观写入、约 50ms 暗帧）不划算，交给真正撞上的玩家自己按更合适。

若日后根因清楚了，把这两趟逻辑挂到 `/datum/hud` 的 `COMSIG_HUD_EYE_CHANGED`、`COMSIG_HUD_Z_CHANGED` 和眼睛的 `COMSIG_MOVABLE_MOVED`（同层 ≥2 格）上即可自动化。

### 机制

生产环境实测过三种手段，只有第三种有效：

| 策略 | 做法 | 结果 |
| --- | --- | --- |
| 仅重算外观 | 调 `lighting_object.update()` | **无效** —— 外观算出来不变，BYOND 不重发 |
| 换容器 | 从 `turf.vis_contents` 摘除再加回 | **无效** —— 原以为结构变更必被传输，实测不然 |
| 强制 diff | 改成 `lighting_dark`，跨 tick 后 `update()` 还原 | **有效** |

结论：失配发生在**外观 ID 这一层**。既不是外观算错了（否则重算就该好），也不是容器关系问题（否则摘除再加回就该好），只有制造一次**跨越 tick 边界**的真实外观 diff 才能逼服务端重发。同一 tick 内改了又改回会被 BYOND 合并成「没有变化」，等于什么都没做——这正是策略一无效的原因。

已经排除的可能：

- 汉化层：`code/modules/lighting`、`code/_onclick/hud` 相对上游零差异
- BYOND 版本：升到 516.1686（含 1683 的 VIS_HIDE / 错误 appearance ID 修复）后依旧复现；1686 已是 516 线最新
- 服务端算不完：MC 面板 `Lighting Sources:0|Corners:73|Objects:3`，队列是空的，仅占 5% tick
- 渲染管线整体故障：手持光源（`OVERLAY_LIGHT_DIRECTIONAL`，走 `O_LIGHTING_VISUAL_PLANE`）的光斑正常可见

手持光源经过**不能**让灰格恢复，因为覆盖层光照根本不碰 turf 光照角落；开门可以，因为它触发 `reconsider_lights()` 真的改变了静态光照。

### 尚未解决的部分

**不知道为什么人少的服务器不触发。** 带宽和 CPU 都已排除（限带宽只造出会自愈的短暂灰屏；引擎内部 tick 占用仅 18.5%）。目前最好的推测是外观数量与 churn：光源一动，周围角落重算就生成新外观，生产上 `Corners` 长期非零而空服长期为 0，加上 128 万实例、数小时的局，外观表规模和翻搅速度差着数量级。**这只是推测，没有证据。**

如果推测成立，这个按钮是对症不对因——同样的污染可能打到别的外观类别（贴图错乱等）。上游同类问题：tgstation#95948（被官方标为 `BYOND Issue`）、#96002，均未修复。

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- N/A

### Defines:

- `modular_nova/modules/lighting_desync_debug/code/lighting_desync_debug.dm`：`LIGHTING_RESYNC_DARK_STATE`、`LIGHTING_RESYNC_COOLDOWN`，均在文件底部 `#undef`

### Included files that are not contained in this module:

- N/A

### Credits:

sernseek
