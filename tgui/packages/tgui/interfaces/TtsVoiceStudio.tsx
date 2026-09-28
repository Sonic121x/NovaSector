// THIS IS A NOVA SECTOR UI FILE
import { useState } from 'react';
import {
  Box,
  Button,
  Input,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  TextArea,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

export type CustomVoice = {
  id: string;
  ckey: string;
  name: string;
  kind: 'design' | 'clone';
  status: 'pending' | 'approved' | 'rejected';
  prompt: string | null;
  consent: string | null;
  created_at: number;
  reviewed_by: string | null;
  reason: string | null;
  has_preview: BooleanLike;
  has_recording: BooleanLike;
};

type Data = {
  donor: BooleanLike;
  enabled: BooleanLike;
  busy: BooleanLike;
  message: string | null;
  message_is_error: BooleanLike;
  voices: CustomVoice[];
  selected: string | null;
  character: string | null;
  consent: string;
  max_prompt_length: number;
  max_name_length: number;
  max_upload_mb: number;
};

export const VOICE_KINDS = {
  design: { label: 'Designed' },
  clone: { label: 'Cloned' },
};

export const VOICE_STATUSES = {
  pending: { label: 'Awaiting review', color: 'average' },
  approved: { label: 'Approved', color: 'good' },
  rejected: { label: 'Rejected', color: 'bad' },
};

export function TtsVoiceStudio() {
  const { data } = useBackend<Data>();
  const { donor, enabled, message, message_is_error } = data;

  return (
    <Window title="Custom Voices" width={540} height={680}>
      <Window.Content scrollable>
        {!enabled && (
          <NoticeBox danger>
            The TTS server does not support custom voices right now.
          </NoticeBox>
        )}
        {!donor && (
          <NoticeBox info>
            Custom voices are a donor perk. You can still listen to and delete
            voices you made before.
          </NoticeBox>
        )}
        <StatusMessage message={message} isError={message_is_error} />
        <VoiceList />
        {!!donor && !!enabled && (
          <>
            <DesignSection />
            <CloneSection />
          </>
        )}
      </Window.Content>
    </Window>
  );
}

/** Feedback for the last action, shared with the review window. */
export function StatusMessage(props: {
  message: string | null;
  isError: BooleanLike;
}) {
  const { message, isError } = props;
  if (!message) {
    return null;
  }
  return isError ? (
    <NoticeBox danger>{message}</NoticeBox>
  ) : (
    <NoticeBox success>{message}</NoticeBox>
  );
}

function VoiceList() {
  const { act, data } = useBackend<Data>();
  const { busy, voices, selected, character } = data;

  return (
    <Section
      title="Your Voices"
      buttons={
        <Button icon="sync" disabled={!!busy} onClick={() => act('refresh')}>
          Refresh
        </Button>
      }
    >
      {voices.length === 0 && (
        <Box color="label">You have not made any voices yet.</Box>
      )}
      <Stack vertical>
        {voices.map((voice) => {
          const status = VOICE_STATUSES[voice.status];
          const inUse = voice.id === selected;
          return (
            <Stack.Item key={voice.id}>
              <Section
                title={voice.name}
                buttons={
                  <>
                    {!!voice.has_preview && (
                      <Button icon="play" onClick={() => act('preview', { id: voice.id })}>
                        Listen
                      </Button>
                    )}
                    {voice.status === 'approved' &&
                      (inUse ? (
                        <Button icon="check" selected onClick={() => act('stop_using')}>
                          In use
                        </Button>
                      ) : (
                        <Button
                          icon="microphone"
                          tooltip={`Speak with this voice as ${character}.`}
                          onClick={() => act('use', { id: voice.id })}
                        >
                          Use
                        </Button>
                      ))}
                    <Button.Confirm
                      icon="trash"
                      color="bad"
                      disabled={!!busy}
                      onClick={() => act('delete', { id: voice.id })}
                    >
                      Delete
                    </Button.Confirm>
                  </>
                }
              >
                <LabeledList>
                  <LabeledList.Item label="Type">
                    {VOICE_KINDS[voice.kind].label}
                  </LabeledList.Item>
                  <LabeledList.Item label="Status" color={status.color}>
                    {status.label}
                  </LabeledList.Item>
                  {!!voice.prompt && (
                    <LabeledList.Item label="Description">
                      {voice.prompt}
                    </LabeledList.Item>
                  )}
                  {!!voice.reason && (
                    <LabeledList.Item label="Reason">{voice.reason}</LabeledList.Item>
                  )}
                </LabeledList>
              </Section>
            </Stack.Item>
          );
        })}
      </Stack>
    </Section>
  );
}

function DesignSection() {
  const { act, data } = useBackend<Data>();
  const { busy, max_prompt_length, max_name_length } = data;
  const [name, setName] = useState('');
  const [prompt, setPrompt] = useState('');

  return (
    <Section title="Design a Voice">
      <Box color="label" mb={1}>
        Describe the voice you want: gender, age, pitch, pace, mood and
        character. For example: a man in his forties with a low, hoarse,
        slightly smoky voice who speaks slowly. Real people cannot be imitated.
      </Box>
      <LabeledList>
        <LabeledList.Item label="Name">
          <Input
            fluid
            maxLength={max_name_length}
            value={name}
            onChange={setName}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Description">
          <TextArea
            fluid
            height="5rem"
            maxLength={max_prompt_length}
            value={prompt}
            onChange={setPrompt}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        icon="wand-magic-sparkles"
        disabled={!!busy || !name.trim() || !prompt.trim()}
        onClick={() => act('design', { name, prompt })}
      >
        Generate
      </Button>
    </Section>
  );
}

function CloneSection() {
  const { act, data } = useBackend<Data>();
  const { busy, consent, max_name_length, max_upload_mb } = data;
  const [name, setName] = useState('');
  const [agreed, setAgreed] = useState(false);

  return (
    <Section title="Clone a Voice">
      <Box color="label" mb={1}>
        Upload 10 to 20 seconds of one person speaking clearly in a quiet room,
        with no music or other voices (WAV, MP3, M4A, OGG or FLAC, up to{' '}
        {max_upload_mb} MB). The voice is cloned right away so you can listen to
        it, but it only works in game once an admin approves it. The recording
        is deleted after review.
      </Box>
      <LabeledList>
        <LabeledList.Item label="Name">
          <Input
            fluid
            maxLength={max_name_length}
            value={name}
            onChange={setName}
          />
        </LabeledList.Item>
      </LabeledList>
      <Box mt={1} p={1} backgroundColor="rgba(255, 255, 255, 0.05)">
        {consent}
      </Box>
      <Button.Checkbox
        mt={1}
        checked={agreed}
        onClick={() => setAgreed(!agreed)}
      >
        I confirm the statement above
      </Button.Checkbox>
      <Box mt={1}>
        <Button
          icon="upload"
          disabled={!!busy || !agreed || !name.trim()}
          onClick={() => act('upload', { name, consent: agreed })}
        >
          Choose Recording...
        </Button>
      </Box>
    </Section>
  );
}
