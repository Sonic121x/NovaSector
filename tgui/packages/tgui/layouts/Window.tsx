/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import {
  type ComponentProps,
  type PropsWithChildren,
  type ReactNode,
  useEffect,
  useLayoutEffect,
  useState,
} from 'react';
import { type Box, KeyListener } from 'tgui-core/components';
import { UI_DISABLED, UI_INTERACTIVE } from 'tgui-core/constants';
import { globalEvents } from 'tgui-core/events';
import { KEY_ALT } from 'tgui-core/keycodes';
import { type BooleanLike, classes } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';
import { useBackend } from '../backend';
import {
  dragStartHandler,
  recallWindowGeometry,
  resizeStartHandler,
  setWindowKey,
  setWindowPosition,
  storeWindowGeometry,
} from '../drag';
import { suspendStart } from '../events/handlers/suspense';
import { createLogger } from '../logging';
import { Layout } from './Layout';
import { TitleBar } from './TitleBar';

const logger = createLogger('Window');
const DEFAULT_SIZE: [number, number] = [400, 600];

type Props = Partial<{
  buttons: ReactNode;
  canClose: BooleanLike;
  height: number;
  theme: string;
  title: string;
  width: number;
}> &
  PropsWithChildren;

export function Window(props: Props) {
  const {
    canClose = true,
    theme,
    title,
    children,
    buttons,
    width,
    height,
  } = props;

  const { config, suspended, debug } = useBackend();

  const [isReadyToRender, setIsReadyToRender] = useState(false);

  // We need to set the window to be invisible before we can set its geometry
  // Otherwise, we get a flicker effect when the window is first rendered
  useLayoutEffect(() => {
    Byond.winset(Byond.windowId, {
      'is-visible': false,
    });
    setIsReadyToRender(true);
  }, []);

  const { scale } = config?.window || false;

  useEffect(() => {
    if (!suspended && isReadyToRender) {
      const updateGeometry = () => {
        const options = {
          ...config.window,
          size: DEFAULT_SIZE,
        };

        if (width && height) {
          options.size = [width, height];
        }
        if (config.window?.key) {
          setWindowKey(config.window.key);
        }
        recallWindowGeometry(options);
        Byond.winset(Byond.windowId, {
          'is-visible': true,
        });
        Byond.sendMessage('visible');
        globalEvents.emit('window-geometry-finished');

        logger.log('set to visible');
      };

      Byond.winset(Byond.windowId, {
        'can-close': Boolean(canClose),
      });
      logger.log('mounting');
      updateGeometry();
    }
    return () => {
      logger.log('unmounting');
    };
  }, [isReadyToRender, width, height, scale]);

  // Determine when to show dimmer
  const showDimmer =
    config.user &&
    (config.user.observer
      ? config.status < UI_DISABLED
      : config.status < UI_INTERACTIVE);

  return suspended ? null : (
    <Layout className="Window" theme={theme}>
      <TitleBar
        title={title || decodeHtmlEntities(config.title)}
        status={config.status}
        onDragStart={dragStartHandler}
        onClose={suspendStart}
        canClose={canClose}
      >
        {buttons}
      </TitleBar>
      <div
        className={classes([
          'Window__rest',
          debug.debugLayout && 'debug-layout',
        ])}
      >
        {!suspended && children}
        {showDimmer && <div className="Window__dimmer" />}
      </div>
      <div
        className="Window__resizeHandle__e"
        onMouseDown={resizeStartHandler(1, 0) as any}
      />
      <div
        className="Window__resizeHandle__s"
        onMouseDown={resizeStartHandler(0, 1) as any}
      />
      <div
        className="Window__resizeHandle__se"
        onMouseDown={resizeStartHandler(1, 1) as any}
      />
    </Layout>
  );
}

type ContentProps = Partial<{
  className: string;
  fitted: boolean;
  scrollable: boolean;
  vertical: boolean;
}> &
  ComponentProps<typeof Box> &
  PropsWithChildren;

function WindowContent(props: ContentProps) {
  const { className, fitted, children, ...rest } = props;
  const [altDown, setAltDown] = useState(false);

  // NOVA EDIT ADDITION START - alt+tab 卡住 altDown 导致弹窗文本无法选中
  // Alt+Tab 时 Alt 的 keydown 到得了窗口，keyup 却发生在焦点已经离开之后 —— KeyListener 收不到，
  // altDown 永久卡在 true。回到窗口后在内容区任意位置按下都会命中 dragStartIfAltHeld，整窗跟着鼠标走，
  // 且 dragMoveHandler 的 preventDefault 吃掉文本选取 → 玩家表现为「弹窗哪里都能拖、文本复制不了」。
  // 失焦即清掉修饰键状态：焦点不在窗口时本就收不到后续 keyup，缓存的按下状态一定是脏的。
  useEffect(() => {
    function clearModifiers(): void {
      setAltDown(false);
    }
    window.addEventListener('blur', clearModifiers);
    document.addEventListener('visibilitychange', clearModifiers);
    return () => {
      window.removeEventListener('blur', clearModifiers);
      document.removeEventListener('visibilitychange', clearModifiers);
    };
  }, []);
  // NOVA EDIT ADDITION END

  function dragStartIfAltHeld(event: React.MouseEvent<HTMLDivElement>): void {
    // NOVA EDIT CHANGE - ORIGINAL: if (altDown) {
    // event.altKey 是本次按下时的真实修饰键状态，作为缓存态的兜底：即便 blur 没有送达（嵌入式浏览器
    // 差异），也不会拿一个过期的 altDown 触发拖动。
    if (altDown && event.altKey) {
      dragStartHandler(event);
    }
  }

  Byond.subscribeTo('resetposition', (payload) => {
    setWindowPosition([0, 0]);
    storeWindowGeometry();
  });

  return (
    <Layout.Content
      onMouseDown={dragStartIfAltHeld}
      className={classes(['Window__content', className])}
      {...rest}
    >
      <KeyListener
        onKeyDown={(evt) => {
          if (KEY_ALT === evt.code) {
            setAltDown(true);
          }
        }}
        onKeyUp={(evt) => {
          if (KEY_ALT === evt.code) {
            setAltDown(false);
          }
        }}
      />
      {fitted ? (
        children
      ) : (
        <div className="Window__contentPadding">{children}</div>
      )}
    </Layout.Content>
  );
}

Window.Content = WindowContent;
