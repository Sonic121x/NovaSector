import type { ExtractAtomValue } from 'jotai';
import type { sendAct } from './act';
import type { backendStateAtom } from './store';

type BinaryIO = 0 | 1;

type Client = {
  address: string;
  ckey: string;
  computer_id: string;
};

type IFace = {
  layout: string;
  name: string;
};

type TguiWindow = {
  fancy: BinaryIO;
  key: string;
  locked: BinaryIO;
  scale: BinaryIO;
  size: [number, number];
};

type User = {
  name: string;
  observer: number;
};

export type Config = {
  client: Client;
  interface: IFace;
  refreshing: BinaryIO;
  status: number;
  title: string;
  user: User;
  window: TguiWindow;
  locale: string; // NOVA EDIT ADDITION - i18n - 全服界面语言 (en / zh-Hans)，由 tgui.dm get_payload 注入
  i18nLogMisses?: boolean; // NOVA EDIT ADDITION - i18n - 前端漏翻采集开关（见 i18n/missLog.ts）
};

export type DebugState = {
  debugLayout: boolean;
  kitchenSink: boolean;
};

export type BackendState<TData> = ExtractAtomValue<typeof backendStateAtom> & {
  act: typeof sendAct;
  data: TData;
};
