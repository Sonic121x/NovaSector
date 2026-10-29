// THIS IS A NOVA SECTOR UI FILE
import { Box, Button, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../../backend';
// ZH EDIT ADDITION - I18N
import { searchableText } from '../../../i18n/search';

type LewdSlot = {
  img: string;
  name: string;
  item_name: string;
  lewd_slots: LewdSlot[];
  ref_self: string;
  ref_user: string;
};

interface LewdItemsTabPropsData {
  searchText;
}

export const LewdItemsTab = ({ searchText }: LewdItemsTabPropsData) => {
  const { act, data } = useBackend<LewdSlot>();
  const { lewd_slots = [], ref_self, ref_user } = data;

  const searchLower = searchText.toLowerCase();

  const filteredSlots = lewd_slots.filter((slot) => {
    return (
      // ZH EDIT CHANGE START - I18N: 也匹配显示译文 - ORIGINAL: x?.toLowerCase().includes(searchLower)
      searchableText(slot.name).includes(searchLower) ||
      searchableText(slot.item_name).includes(searchLower)
      // ZH EDIT CHANGE END
    );
  });

  return (
    <Stack fill>
      {filteredSlots.length > 0 && (
        <Stack fill>
          {filteredSlots.map((slot) => {
            return (
              <Stack.Item key={slot.name}>
                <Button
                  onClick={() =>
                    act('remove_lewd_item', {
                      item_slot: slot.name,
                      selfref: ref_self,
                      userref: ref_user,
                    })
                  }
                  color="pink"
                  tooltip={`${slot.name}${slot.item_name ? ` - ${slot.item_name}` : ''}`}
                >
                  <Box
                    style={{
                      width: '32px',
                      height: '32px',
                      margin: '0.5em 0',
                    }}
                  >
                    {slot.img ? (
                      <img
                        src={`data:image/png;base64,${slot.img}`}
                        style={{
                          width: '100%',
                          height: '100%',
                        }}
                      />
                    ) : (
                      <Icon
                        name="eye-slash"
                        size={2}
                        ml={0}
                        mt={0.75}
                        style={{
                          textAlign: 'center',
                        }}
                      />
                    )}
                  </Box>
                </Button>
              </Stack.Item>
            );
          })}
        </Stack>
      )}
    </Stack>
  );
};
