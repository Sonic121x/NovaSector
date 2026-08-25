// THIS IS A NOVA SECTOR UI FILE
import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

import { defineMessage, useTranslator } from '../i18n';

const candidateTitle = defineMessage(
  'antag.opfor.candidate_title',
  'You are an OPFOR candidate!',
);
const candidateDescription = defineMessage(
  'antag.opfor.candidate_description',
  'You are encouraged to OPFOR to perform an antagonistic action in some form.',
);
const inspirationHint = defineMessage(
  'antag.opfor.inspiration_hint',
  'If you do not have any ideas, check #player-submitted-opfors on the Discord for inspiration.',
);
const removeHint = defineMessage(
  'antag.opfor.remove_hint',
  'And if you do not wish to OPFOR, simply press the button below to remove your status.',
);
const removeStatus = defineMessage(
  'antag.opfor.remove_status',
  'Remove Status',
);
const removeStatusTooltip = defineMessage(
  'antag.opfor.remove_status_tooltip',
  'Remove your OPFOR candidate status.',
);

export const AntagInfoOpfor = (props) => {
  const { act } = useBackend();
  const translator = useTranslator();
  return (
    <Window width={620} height={250}>
      <Window.Content>
        <Section scrollable fill>
          <Stack vertical>
            <Stack.Item fontSize="20px" color={'good'}>
              {translator.text(candidateTitle)}
            </Stack.Item>
            {translator.text(candidateDescription)}
            {translator.text(inspirationHint)}
            {translator.text(removeHint)}
            <Stack.Item align="center">
              <Button
                color="red"
                content={translator.text(removeStatus)}
                tooltip={translator.text(removeStatusTooltip)}
                onClick={() => act('pass_on')}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
