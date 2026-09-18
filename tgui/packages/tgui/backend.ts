import { sendAct } from './events/act';
import { backendStateAtom, sharedAtom, store } from './events/store';
import type { BackendState } from './events/types';

// NOVA EDIT ADDITION START - TGUI_STALE_ACT
/**
 * 按服务端 UI 实例序号绑定的 act。
 *
 * 窗口是池化复用的：一个 UI 关掉、下一个立刻在同一窗口打开时，页面上还挂着上一个的内容。
 * 序号必须在**渲染时**绑定——按钮的 onClick 闭包拿到的是渲染它那一刻的 act，于是旧内容上的
 * 点击带着旧序号、被服务端丢弃。若在发送时再去读 store，store 可能已经换成新 UI 的 config，
 * 旧按钮就会带着新序号发出去，等于没防。
 *
 * 同一序号复用同一个函数：act 保持引用稳定，放进 hook 依赖也不会每次渲染都变。
 */
const boundActs = new Map<number, BackendState<any>['act']>();

function getBoundAct(uiId: number | undefined): BackendState<any>['act'] {
  if (uiId === undefined) {
    return sendAct;
  }
  let act = boundActs.get(uiId);
  if (!act) {
    // 一个窗口的生命期里序号只会前进，旧的留着只占内存。
    boundActs.clear();
    act = (action, payload) => sendAct(action, payload, uiId);
    boundActs.set(uiId, act);
  }
  return act;
}
// NOVA EDIT ADDITION END

/**
 * Reactive backend state hook. Please use a type to define what the data is
 * intended to be, e.g.:
 *
 * ```ts
 * type Data = {
 *  username: string;
 * };
 *
 * const { data } = useBackend<Data>();
 *
 * console.log(data.username); // You'll get type safety here
 * ```
 */
export function useBackend<
  TData extends Record<string, any>,
>(): BackendState<TData> {
  const state = store.get(backendStateAtom);

  return {
    act: getBoundAct(state.config?.uiId), // NOVA EDIT CHANGE - TGUI_STALE_ACT - ORIGINAL: act: sendAct,
    ...state,
    data: state.data as TData,
  };
}

/**
 * A tuple that contains the state and a setter function for it.
 */
type StateWithSetter<T> = [T, (nextState: T) => void];

/**
 * Allocates state in the Jotai store without sharing it with other clients.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists between renders, but will be forgotten after you close
 * the UI.
 *
 * It is a lot more performant than `setSharedState`.
 *
 * @param key Key which uniquely identifies this state in Zustand store.
 * @param initialState Initializes your global variable with this value.
 * @deprecated Use useState and useEffect when you can. Pass the state as a prop.
 */
export const useLocalState = <TState>(
  key: string,
  initialState: TState,
): StateWithSetter<TState> => {
  const sharedStates = store.get(sharedAtom);
  const sharedState = key in sharedStates ? sharedStates[key] : initialState;

  return [
    sharedState,
    (nextState) => {
      store.set(sharedAtom, (prev) => ({
        ...prev,
        [key]: nextState,
      }));
    },
  ];
};

/**
 * Allocates state on Jotai store, and **shares** it with other clients
 * in the game.
 *
 * Use it when you want to have a stateful variable in your component
 * that persists not only between renders, but also gets pushed to other
 * clients that observe this UI.
 *
 * This makes creation of observable UIs easier.
 *
 * @param key Key which uniquely identifies this state in Jotai store.
 * @param initialState Initializes your global variable with this value.
 */
export const useSharedState = <TState>(
  key: string,
  initialState: TState,
): StateWithSetter<TState> => {
  const sharedStates = store.get(sharedAtom);
  const sharedState = key in sharedStates ? sharedStates[key] : initialState;

  return [
    sharedState,
    (nextState) => {
      Byond.sendMessage({
        type: 'setSharedState',
        key,
        value:
          JSON.stringify(
            typeof nextState === 'function'
              ? nextState(sharedState)
              : nextState,
          ) || '',
      });
    },
  ];
};
