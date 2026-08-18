## 静态光照失配修复 (Lighting Desync)

Module ID: LIGHTING_DESYNC_DEBUG

### Description:

给玩家一个自助按钮，修复「瞬移 / 下楼梯 / 鬼魂观察落地 / 新出生后整屏静态光照缺失呈灰色，且不会自愈」这个问题。

OOC 分类下的 **修复光照bug**，任何玩家都能用，10 秒冷却。按下后把视野内的静态光照强制重画一遍。

### 为什么是手动而不是自动

**根因仍未查清**：不知道为什么只有高人数服触发，也就无法断定任何自动触发点覆盖了全部场景。在这种前提下
让全服在每次视点跳变时都付出代价（约 225–361 个 turf、两趟外观写入、约 50ms 暗帧）不划算，交给真正撞上
的玩家自己按更合适。

若日后根因清楚了，把这两趟逻辑挂到 `/datum/hud` 的 `COMSIG_HUD_EYE_CHANGED`、`COMSIG_HUD_Z_CHANGED`
和眼睛的 `COMSIG_MOVABLE_MOVED`（同层 ≥2 格）上即可自动化。

### 机制

生产环境实测过三种手段，只有第三种有效：

| 策略 | 做法 | 结果 |
| --- | --- | --- |
| 仅重算外观 | 调 `lighting_object.update()` | **无效** —— 外观算出来不变，BYOND 不重发 |
| 换容器 | 从 `turf.vis_contents` 摘除再加回 | **无效** —— 原以为结构变更必被传输，实测不然 |
| 强制 diff | 改成 `lighting_dark`，跨 tick 后 `update()` 还原 | **有效** |

结论：失配发生在**外观 ID 这一层**。既不是外观算错了（否则重算就该好），也不是容器关系问题（否则摘除再加回就该好），只有制造一次**跨越 tick 边界**的真实外观 diff 才能逼服务端重发。同一 tick 内改了又改回会被 BYOND 合并成「没有变化」，等于什么都没做——这正是策略一无效的原因。

已经排除的可能：

- lighting 实现本身：`code/modules/lighting`、`code/_onclick/hud` 相对上游零差异
- BYOND 小版本：升到 516.1686（含 1683 的 VIS_HIDE / 错误 appearance ID 修复）后依旧复现
- 服务端算不完：MC 面板 `Lighting Sources:0|Corners:73|Objects:3`，队列为空，仅占 5% tick
- 渲染管线整体故障：手持光源（`OVERLAY_LIGHT_DIRECTIONAL`，走 `O_LIGHTING_VISUAL_PLANE`）的光斑正常可见

手持光源经过**不能**让灰格恢复，因为覆盖层光照不碰 turf 光照角落；开门可以，因为它触发
`reconsider_lights()` 并真实改变静态光照 appearance。

### 尚未解决的部分

**不知道为什么人少的服务器不触发。** 带宽和 CPU 都已排除（限带宽只造出会自愈的短暂灰屏；引擎内部 tick
占用仅 18.5%）。目前最好的推测仍是外观数量与 churn：光源一动，周围角落重算就生成新外观，生产上
`Corners` 长期非零而空服长期为 0，加上 128 万实例、数小时的局，外观表规模和翻搅速度差着数量级。
**这只是推测，没有证据。**

如果推测成立，这个按钮是对症不对因——同样的污染可能打到别的外观类别（贴图错乱等）。上游同类问题：
tgstation#95948（被官方标为 `BYOND Issue`）、#96002，均未修复。

### 与 i18n 原地反查的关系（假设，未验证）

i18n 曾在 `/atom/Initialize` 与不调用父级的 `/turf/Initialize` 里给每个实例改写 `name`/`desc`。这两个
字段属于 `appearance`，所以那是地图加载期对约 128 万个实例各做两次外观变更——**churn**，不是「每实例
一份外观」（appearance 内化 + 引用计数，同型实例改成同一个中文串后仍共享一份，净增大致是每种外观一条）。
churn 会加剧 appearance ID 复用，而上面的三策略实验已把失配定位在 ID 重传这一层，所以它**可能**是
汉化服触发更频繁的放大器之一。

这条链条里已经确定的只有「name/desc 属于 appearance」和「失配在 ID 重传层」两端，中间那一步没有数据：

- 未测量：开/关这个钩子时同一张图 post-init 的外观规模、灰屏上报频率。
- 不成立的旁证：崩溃回合那条 `memory allocation of 167772160 bytes failed` 是一次 160 MB 的**单次**分配，
  和逐实例改写 name/desc 没有可见因果；32 位进程启动 157 秒 RSS 就到 2,428,456 KiB 需要单独归因，
  别顺手挂到这条上。

即便如此，把整图初始化期的外观写入去掉本身是划算的（另外还消掉了 `name == initial(name)` 那一类反查
副作用），所以已经改成只在显示边界翻译，代价与缺口记在 `modular_nova/modules/i18n/readme.md`。
要证实或推翻这条假设，需要一次同图对照测量；在那之前它是假设，不是结论，本模块按钮照旧保留。

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
