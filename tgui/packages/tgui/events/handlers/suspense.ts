import { focusMap } from '../../focus';
// NOVA EDIT ADDITION - I18N
import { resetCatalogOverlay } from '../../i18n/catalog';
import { logger } from '../../logging';
import { suspendRenderer } from '../../renderer';
import {
  configAtom,
  resetStore,
  store,
  suspendedAtom,
  suspendingAtom,
} from '../store';

/// --------- Handlers ------------------------------------------------------///

let suspendInterval: NodeJS.Timeout | null = null;

/** Resets all state and refocuses byond window */
export function suspend(): void {
  suspendRenderer();
  resetStore();
  // NOVA EDIT ADDITION - I18N: 负载 overlay 与负载同生命周期。窗口被复用给另一个界面时不清，
  // 上一个界面的「英文 → 译文」词对会留下来，成为一小片会话内的误翻面。
  // 挂这里而不是 resetStore() 里：catalog.ts 要读 store 取 locale，反向 import 会成循环依赖。
  resetCatalogOverlay();

  if (suspendInterval) clearInterval(suspendInterval);

  store.set(configAtom, (prev) => ({
    ...prev,
    title: '',
    status: 1,
  }));
  store.set(suspendingAtom, false);
  store.set(suspendedAtom, Date.now());

  Byond.winset(Byond.windowId, {
    'is-visible': false,
  });

  focusMap();
}

/// --------- Helpers -------------------------------------------------------///

const TWO_SECONDS = 2000;

function suspendMsg(): void {
  Byond.sendMessage('suspend');
}

/** Signals Byond to dismiss the window */
export function suspendStart(): void {
  if (suspendInterval) clearInterval(suspendInterval);

  store.set(suspendingAtom, true);

  logger.log(`suspending (${Byond.windowId})`);
  suspendMsg();
  suspendInterval = setInterval(suspendMsg, TWO_SECONDS);
}
