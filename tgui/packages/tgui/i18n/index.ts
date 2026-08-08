// THIS IS A NOVA SECTOR UI FILE
// 轻量、零运行时依赖的 TGUI 本地化助手。
//
// BYOND 内嵌的 CEF 浏览器在运行时无网络，所以生产环境用「内置 JSON 目录」而非在线
// 翻译服务。locale 取自全服 config.locale（由 code/modules/tgui/tgui.dm 的 get_payload 注入）。
// 这些 JSON 即在线本地化平台导入/导出的源/目标 —— 平台仅作开发期管理，运行时不需要其 SDK。
//
// 占位符语义与 DM 端 LANG 一致：{0}/{1}… 按位置替换，允许按中文语序重排。

import { createElement as reactCreateElement } from 'react';
import { useBackend } from '../backend';
import { translate } from './catalog';
import { localizeNode, localizeProps } from './localize';

export { translate, translateCurrent } from './catalog';

/** 在组件内获取翻译函数，locale 取自全服 config.locale。 */
export function useT(): (key: string, args?: Array<string | number>) => string {
  const { config } = useBackend();
  const locale = config?.locale ?? 'en';
  return (key, args) => translate(locale, key, args);
}

export function createElement(
  type: unknown,
  props: unknown,
  ...children: unknown[]
) {
  const localizedChildren = children.map((child) => localizeNode(child));
  return reactCreateElement(
    type as never,
    localizeProps(props, type) as never,
    ...(localizedChildren as never[]),
  );
}
