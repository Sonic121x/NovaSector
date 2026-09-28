import { filter } from 'es-toolkit/compat';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  FitText,
  Icon,
  Modal,
  Section,
  Stack,
} from 'tgui-core/components';

import { getRandomization, PreferenceList } from './MainPage';

type VocalsProps = {
  handleClose: () => void;
  vocals: Record<string, string | number | boolean>;
};

type VocalFeature = {
  id: string;
  label: string;
  type: string;
};

const vocalFeatures: VocalFeature[] = [
  { id: 'voice_type', label: 'Voice Type', type: 'string' },
  { id: 'tts_voice', label: 'Voice', type: 'string' },
  { id: 'tts_voice_pitch', label: 'Voice Pitch Adjustments', type: 'number' },
  { id: 'tts_voice_rate', label: 'Voice Speed', type: 'number' },
  { id: 'tts_voice_instruction', label: 'Voice Description', type: 'string' },
  { id: 'tts_voiced_emotes', label: 'Voiced Emotes', type: 'boolean' },
  { id: 'fallback_to_blooper', label: 'Fallback to Blooper', type: 'boolean' },
  { id: 'blooper_speech', label: 'Blooper Speech', type: 'string' },
  { id: 'blooper_speech_speed', label: 'Blooper Speed', type: 'number' },
  { id: 'blooper_speech_pitch', label: 'Blooper Pitch', type: 'number' },
  { id: 'blooper_pitch_range', label: 'Blooper Range', type: 'number' },
];

type FeatureValueInputProps = {
  feature: VocalFeature;
  value: string | number | boolean;
};

function getCorrespondingPreferences(
  customization_options: string[],
  relevant_preferences: Record<string, string | number | boolean>,
) {
  return Object.fromEntries(
    filter(Object.entries(relevant_preferences), ([key, value]) =>
      customization_options.includes(key),
    ),
  );
}

function FeatureValueInput({ feature, value }: FeatureValueInputProps) {
  return (
    <Stack.Item>
      <PreferenceList
        preferences={getCorrespondingPreferences([feature.id], {
          [feature.id]: value,
        })}
        randomizations={getRandomization(
          getCorrespondingPreferences([feature.id], {
            [feature.id]: value,
          }),
          undefined,
          false,
        )}
        maxHeight="160px"
      />
    </Stack.Item>
  );
}

export function VocalsInput(props: VocalsProps) {
  const { vocals, handleClose } = props;
  const { act } = useBackend();

  return (
    <Modal>
      <Box
        style={{
          minWidth: '280px',
        }}
      >
        <Section
          title="Character Voice"
          buttons={
            <>
              {vocals.tts_voice !== undefined && (
                <Button
                  icon="wand-magic-sparkles"
                  tooltip="Design or clone a voice of your own (donors)."
                  onClick={() => act('open_voice_studio')}
                >
                  Custom Voices
                </Button>
              )}
              <Button color="red" onClick={handleClose}>
                Close
              </Button>
            </>
          }
        >
          <Stack vertical>
            {vocalFeatures.map((feature) => {
              const value = vocals[feature.id];
              if (value === undefined) return null;

              return (
                <Stack.Item key={feature.id} verticalAlign="top">
                  <FeatureValueInput feature={feature} value={value} />
                </Stack.Item>
              );
            })}
          </Stack>
        </Section>
      </Box>
    </Modal>
  );
}

type VoiceInputProps = {
  openVocalsInput: () => void;
};

export function VoiceInput(props: VoiceInputProps) {
  return (
    <Button
      onClick={(event) => {
        props.openVocalsInput();
        event.cancelBubble = true;
        event.stopPropagation();
      }}
      textAlign="center"
      width="100%"
      height="28px"
    >
      <Stack align="center" fill>
        <Stack.Item>
          <Icon
            style={{
              color: 'rgba(255, 255, 255, 0.5)',
              fontSize: '17px',
            }}
            name="fa-microphone"
          />
        </Stack.Item>

        <Stack.Item grow position="relative" mt={0.6}>
          <FitText maxFontSize={16} maxWidth={130}>
            Voice Settings
          </FitText>
        </Stack.Item>
      </Stack>
    </Button>
  );
}
