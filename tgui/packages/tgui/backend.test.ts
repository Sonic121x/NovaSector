// THIS IS A NOVA SECTOR UI FILE
import { beforeEach, describe, expect, mock, test } from 'bun:test';

import type { Config } from './events/types';

// 全局 setup 把 events/act 整个 mock 成空函数；这里换成间谍，好看到 act 到底带了什么序号。
const sent: unknown[][] = [];
mock.module('./events/act', () => ({
  sendAct: (...args: unknown[]) => {
    sent.push(args);
  },
}));

const { useBackend } = await import('./backend');
const { configAtom, store } = await import('./events/store');

function openUi(uiId: number | undefined) {
  store.set(configAtom, { uiId } as Config);
}

describe('TGUI_STALE_ACT：act 按渲染时的 UI 实例序号绑定', () => {
  beforeEach(() => {
    sent.length = 0;
  });

  test('act 带上当前 UI 的序号', () => {
    openUi(5);
    useBackend().act('choose', { choice: 'Yes' });
    expect(sent).toEqual([['choose', { choice: 'Yes' }, 5]]);
  });

  test('窗口换成下一个 UI 之后，旧内容上的 act 仍带旧序号', () => {
    // 这正是连续 tgui_alert 串线的形态：第 2 个弹窗的按钮在第 3 个弹窗打开后才被点到。
    openUi(7);
    const staleAct = useBackend().act;
    openUi(8);
    staleAct('choose', { choice: 'Selected Character' });
    useBackend().act('choose', { choice: 'Bluespace Tech' });
    expect(sent).toEqual([
      ['choose', { choice: 'Selected Character' }, 7],
      ['choose', { choice: 'Bluespace Tech' }, 8],
    ]);
  });

  test('同一序号下 act 引用稳定（放进 hook 依赖不会每次渲染都变）', () => {
    openUi(11);
    expect(useBackend().act).toBe(useBackend().act);
    openUi(12);
    const next = useBackend().act;
    openUi(11);
    expect(useBackend().act).not.toBe(next);
  });

  test('服务端没下发序号时退回原来的 sendAct（不带序号，服务端照旧放行）', () => {
    openUi(undefined);
    useBackend().act('ping');
    expect(sent).toEqual([['ping']]);
  });
});
