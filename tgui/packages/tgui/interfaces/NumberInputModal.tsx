import { useState } from 'react';
import {
  Box,
  Button,
  RestrictedInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { isEscape, KEY } from 'tgui-core/keys';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type Data = {
  init_value: number;
  large_buttons: BooleanLike;
  max_value: number;
  message: string;
  min_value: number;
  round_value: BooleanLike;
  timeout: number;
  title: string;
};

export function NumberInputModal(props) {
  const { act, data } = useBackend<Data>();
  const {
    init_value,
    large_buttons,
    max_value = 10000,
    message = '',
    min_value = 0,
    round_value,
    timeout,
    title,
  } = data;

  const [value, setValue] = useState(init_value);
  const [isValid, setIsValid] = useState(true);

  // Dynamically changes the window height based on the message.
  const windowHeight =
    140 +
    (message.length > 30 ? Math.ceil(message.length / 3) : 0) +
    (message.length && large_buttons ? 5 : 0);

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    if (event.key === KEY.Enter && isValid) {
      act('submit', { entry: value });
    }
    if (isEscape(event.key)) {
      act('cancel');
    }
  }

  return (
    <Window title={title} width={270} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content onKeyDown={handleKeyDown}>
        <Section fill>
          <Stack fill vertical>
            <Stack.Item grow>
              <Box color="label">{message}</Box>
            </Stack.Item>
            <Stack.Item>
              <Stack fill>
                <Stack.Item>
                  <Button
                    disabled={value === min_value}
                    icon="angle-double-left"
                    onClick={() => setValue(min_value ?? 0)}
                    // NOVA EDIT CHANGE - i18n: ORIGINAL: tooltip={min_value ? `Min (${min_value})` : 'Min'}
                    // 模板字面量整串是运行期产物、永远不是目录键，而 propTemplate 只认
                    // **属性值本身**是模板字面量的形状，三元包一层就整条抽不到。改成
                    // children 模板：数值包进元素当占位符，整条抽成 `Min ({0})`。
                    tooltip={
                      min_value ? (
                        <>
                          Min (<span>{min_value}</span>)
                        </>
                      ) : (
                        'Min'
                      )
                    }
                  />
                </Stack.Item>

                <Stack.Item>
                  <Button
                    icon="angle-down"
                    disabled={value <= min_value}
                    onClick={() => setValue((value) => value - 1)}
                  />
                </Stack.Item>

                <Stack.Item grow>
                  <RestrictedInput
                    autoFocus
                    autoSelect
                    fluid
                    allowFloats={!round_value}
                    minValue={min_value}
                    maxValue={max_value}
                    onChange={setValue}
                    onValidationChange={setIsValid}
                    value={value}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Button
                    icon="angle-up"
                    disabled={value >= max_value}
                    onClick={() => setValue((value) => value + 1)}
                  />
                </Stack.Item>

                <Stack.Item>
                  <Button
                    disabled={value === max_value}
                    icon="angle-double-right"
                    onClick={() => setValue(max_value ?? 10000)}
                    // NOVA EDIT CHANGE - i18n: ORIGINAL: tooltip={max_value ? `Max (${max_value})` : 'Max'}
                    // 模板字面量整串是运行期产物、永远不是目录键，而 propTemplate 只认
                    // **属性值本身**是模板字面量的形状，三元包一层就整条抽不到。改成
                    // children 模板：数值包进元素当占位符，整条抽成 `Max ({0})`。
                    tooltip={
                      max_value ? (
                        <>
                          Max (<span>{max_value}</span>)
                        </>
                      ) : (
                        'Max'
                      )
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    disabled={value === init_value}
                    icon="redo"
                    onClick={() => setValue(init_value ?? 0)}
                    // NOVA EDIT CHANGE - i18n: ORIGINAL: tooltip={init_value ? `Reset (${init_value})` : 'Reset'}
                    // 模板字面量整串是运行期产物、永远不是目录键，而 propTemplate 只认
                    // **属性值本身**是模板字面量的形状，三元包一层就整条抽不到。改成
                    // children 模板：数值包进元素当占位符，整条抽成 `Reset ({0})`。
                    tooltip={
                      init_value ? (
                        <>
                          Reset (<span>{init_value}</span>)
                        </>
                      ) : (
                        'Reset'
                      )
                    }
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <InputButtons input={value} disabled={!isValid} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}
