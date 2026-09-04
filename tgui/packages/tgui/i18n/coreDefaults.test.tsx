// THIS IS A NOVA SECTOR UI FILE
//
// `localize.ts` 的 `withCoreDefaultProps` 把 tgui-core 的默认文案**抄了一份**：调用方没传
// `confirmContent` / `placeholder` 时，我们主动补上 canonical English，好让它进翻译面。
//
// 这份抄写有个静默失效模式：**上游改了默认值，我们仍然注入旧字面量** —— 于是我们不是在
// 「翻译 core 的默认文案」，而是在「用一个过期英文覆盖它」，界面上看不出来，
// `localize.test.ts` 里那几条也照过（它们只验注入生效、不验注入的值对不对）。
//
// 这里渲染真组件、读它自己渲染出来的默认文本，把两边钉在一起。上游一改，这里立刻红。
import { describe, expect, it } from 'bun:test';
import { act, fireEvent, render, screen } from '@testing-library/react';
import { Button, Dropdown } from 'tgui-core/components';

import { CORE_DEFAULT_CONFIRM_CONTENT, CORE_DEFAULT_DROPDOWN_PLACEHOLDER } from './localize';

describe('tgui-core 默认文案与我们抄写的常量一致', () => {
  it('Button.Confirm 点击后显示的确认文案', () => {
    act(() => {
      render(<Button.Confirm>Zzqv delete</Button.Confirm>);
    });
    // Button 渲染的是 div 而不是 button，`closest('button')` 拿不到东西 —— 直接点它自己。
    act(() => {
      fireEvent.click(screen.getByText('Zzqv delete'));
    });
    expect(screen.getByText(CORE_DEFAULT_CONFIRM_CONTENT)).toBeTruthy();
  });

  it('Dropdown 未选中时显示的占位文案', () => {
    act(() => {
      render(<Dropdown options={[]} selected={null} onSelected={() => {}} />);
    });
    expect(screen.getByText(CORE_DEFAULT_DROPDOWN_PLACEHOLDER)).toBeTruthy();
  });
});
