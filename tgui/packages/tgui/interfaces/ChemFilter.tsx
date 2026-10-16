import { Fragment } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import type { CssColor } from '../constants';
import { Window } from '../layouts';

type Data = {
  left: string[];
  right: string[];
};

type Props = {
  title: string;
  // ZH EDIT ADDITION - i18n: english act() identifier, decoupled from the auto-localized `title`
  side: string;
  list: string[];
  buttonColor: CssColor;
};

export const ChemFilterPane = (props: Props) => {
  const { act } = useBackend();
  const { title, side, list, buttonColor } = props;
  // ZH EDIT CHANGE - i18n - ORIGINAL: const titleKey = title.toLowerCase();
  // `title` is auto-localized (e.g. "Right"->"右"), which made `which` non-english and
  // broke the DM `switch(params["which"])` on "left"/"right"; use the english `side` instead.
  const titleKey = side;

  return (
    <Section
      title={title}
      minHeight="240px"
      buttons={
        <Button
          icon="plus"
          color={buttonColor}
          onClick={() =>
            act('add', {
              which: titleKey,
            })
          }
        >
          Add Reagent
        </Button>
      }
    >
      {list.map((filter) => (
        <Fragment key={filter}>
          <Button
            fluid
            icon="minus"
            onClick={() =>
              act('remove', {
                which: titleKey,
                reagent: filter,
              })
            }
          >
            {filter}
          </Button>
        </Fragment>
      ))}
    </Section>
  );
};

export const ChemFilter = (props) => {
  const { data } = useBackend<Data>();
  const { left = [], right = [] } = data;

  return (
    <Window width={500} height={300}>
      <Window.Content scrollable>
        <Stack>
          <Stack.Item grow>
            <ChemFilterPane
              title="Right"
              side="right"
              list={right}
              buttonColor="red"
            />
          </Stack.Item>
          <Stack.Item grow>
            <ChemFilterPane
              title="Left"
              side="left"
              list={left}
              buttonColor="yellow"
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
