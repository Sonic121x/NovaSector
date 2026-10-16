// THIS IS A NOVA SECTOR UI FILE

import { CheckboxInput, type FeatureToggle } from '../../base';

export const ime_keyboard: FeatureToggle = {
  name: 'Input method friendly controls',
  category: 'GAMEPLAY',
  description: `
    Keeps game hotkeys working while a Chinese, Japanese or Korean input
    method is on. Text boxes such as the chat bar still use the input method
    as usual. Turn this off if your keys behave strangely.
  `,
  component: CheckboxInput,
};
