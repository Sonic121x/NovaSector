// THIS IS A NOVA SECTOR UI FILE
import { useState } from 'react';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { useBackend } from '../backend';
import { Window } from '../layouts';
import {
  type CustomVoice,
  StatusMessage,
  VOICE_KINDS,
  VOICE_STATUSES,
} from './TtsVoiceStudio';

type Data = {
  enabled: BooleanLike;
  busy: BooleanLike;
  message: string | null;
  message_is_error: BooleanLike;
  voices: CustomVoice[];
};

export function TtsVoiceReview() {
  const { act, data } = useBackend<Data>();
  const { enabled, busy, message, message_is_error, voices } = data;
  const [showAll, setShowAll] = useState(false);
  const pending = voices.filter((voice) => voice.status === 'pending');
  const shown = showAll ? voices : pending;

  return (
    <Window title="Review Custom Voices" width={600} height={640}>
      <Window.Content scrollable>
        {!enabled && (
          <NoticeBox danger>
            The TTS server does not support custom voices right now.
          </NoticeBox>
        )}
        <StatusMessage message={message} isError={message_is_error} />
        <Section
          title={
            showAll ? 'All Voices' : `Awaiting Review (${pending.length})`
          }
          buttons={
            <>
              <Button.Checkbox
                checked={showAll}
                onClick={() => setShowAll(!showAll)}
              >
                Show all
              </Button.Checkbox>
              <Button
                icon="sync"
                disabled={!!busy}
                onClick={() => act('refresh')}
              >
                Refresh
              </Button>
            </>
          }
        >
          {shown.length === 0 && <Box color="label">Nothing to review.</Box>}
          <Stack vertical>
            {shown.map((voice) => (
              <Stack.Item key={voice.id}>
                <ReviewEntry voice={voice} />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}

function ReviewEntry(props: { voice: CustomVoice }) {
  const { act, data } = useBackend<Data>();
  const { voice } = props;
  const busy = !!data.busy;
  const status = VOICE_STATUSES[voice.status];

  return (
    <Section
      title={`${voice.name} (${voice.ckey})`}
      buttons={
        <>
          {!!voice.has_preview && (
            <Button icon="play" onClick={() => act('preview', { id: voice.id })}>
              Listen
            </Button>
          )}
          {!!voice.has_recording && (
            <Button
              icon="file-audio"
              tooltip="The uploaded recording the voice was cloned from."
              onClick={() => act('recording', { id: voice.id })}
            >
              Original Recording
            </Button>
          )}
          {voice.status === 'pending' && (
            <>
              <Button
                icon="check"
                color="good"
                disabled={busy}
                onClick={() => act('approve', { id: voice.id })}
              >
                Approve
              </Button>
              <Button
                icon="times"
                color="bad"
                disabled={busy}
                onClick={() => act('reject', { id: voice.id })}
              >
                Reject
              </Button>
            </>
          )}
          <Button
            icon="trash"
            disabled={busy}
            onClick={() => act('delete', { id: voice.id })}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Type">{VOICE_KINDS[voice.kind].label}</LabeledList.Item>
        <LabeledList.Item label="Status" color={status.color}>
          {status.label}
        </LabeledList.Item>
        <LabeledList.Item label="Submitted">
          {new Date(voice.created_at * 1000).toLocaleString()}
        </LabeledList.Item>
        {!!voice.prompt && (
          <LabeledList.Item label="Description">{voice.prompt}</LabeledList.Item>
        )}
        {!!voice.consent && (
          <LabeledList.Item label="Consent">{voice.consent}</LabeledList.Item>
        )}
        {!!voice.reviewed_by && (
          <LabeledList.Item label="Reviewed by">{voice.reviewed_by}</LabeledList.Item>
        )}
        {!!voice.reason && (
          <LabeledList.Item label="Reason">{voice.reason}</LabeledList.Item>
        )}
      </LabeledList>
      {voice.kind === 'clone' && voice.status === 'pending' && (
        <Box color="average" mt={1}>
          Listen to both: approve only a clear recording of one speaker, and
          only if nothing suggests it imitates someone who did not agree.
        </Box>
      )}
    </Section>
  );
}
