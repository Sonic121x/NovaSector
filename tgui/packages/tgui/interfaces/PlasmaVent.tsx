import type { ReactNode } from 'react';
import {
  Box,
  Button,
  Icon,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type NoticeKind = 'info' | 'success' | 'danger';

type Data = {
  calibrated: BooleanLike;
  channel: BooleanLike;
  cooldown: number;
  cooldown_max: number;
  handshake_progress: number;
  handshaking: BooleanLike;
  linked: BooleanLike;
  notice: string | null;
  notice_type: NoticeKind;
  pack: BooleanLike;
};

function Metric(props: { label: string; value: ReactNode; color?: string }) {
  const { label, value, color } = props;
  return (
    <Box p={1}>
      <Box
        bold
        color="label"
        fontSize="0.75em"
        style={{ letterSpacing: '0.08em' }}
      >
        {label.toUpperCase()}
      </Box>
      <Box bold fontSize="1.15em" color={color} mt={0.25}>
        {value}
      </Box>
    </Box>
  );
}

export function PlasmaVent() {
  const { act, data } = useBackend<Data>();
  const {
    calibrated,
    channel,
    cooldown,
    cooldown_max,
    handshake_progress,
    handshaking,
    linked,
    notice,
    notice_type,
    pack,
  } = data;

  const canRelease = !!channel && !!calibrated && cooldown <= 0;
  const charge = Math.max(
    0,
    Math.min(1, 1 - cooldown / Math.max(1, cooldown_max)),
  );

  const state = handshaking
    ? {
        label: 'HANDSHAKE',
        color: 'blue',
        icon: 'satellite-dish',
        hint: 'Negotiating the one-time bluespace link.',
      }
    : channel
      ? {
          label: 'CHANNEL OPEN',
          color: 'good',
          icon: 'broadcast-tower',
          hint: 'Transport to Central Command is nominal.',
        }
      : linked
        ? {
            label: 'STANDBY',
            color: 'average',
            icon: 'plug',
            hint: 'Vent linked. The channel is still closed.',
          }
        : {
            label: 'OFFLINE',
            color: 'bad',
            icon: 'unlink',
            hint: 'No vent linked to this console.',
          };

  return (
    <Window width={520} height={470}>
      <Window.Content scrollable>
        <Section>
          <Stack align="center">
            <Stack.Item>
              <Icon
                name={state.icon}
                color={state.color}
                size={2}
                spin={!!handshaking}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Box bold fontSize="1.2em" color={state.color}>
                {state.label}
              </Box>
              <Box color="label">{state.hint}</Box>
            </Stack.Item>
            <Stack.Item>
              <Tooltip
                content={
                  linked
                    ? 'A vent is linked to this console.'
                    : 'No vent found within seven tiles.'
                }
              >
                <Box bold color={linked ? 'good' : 'bad'} fontSize="0.85em">
                  {linked ? 'LINKED' : 'NOT LINKED'}
                </Box>
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="Telemetry">
          <Stack>
            <Stack.Item grow basis={0}>
              <Metric
                label="Calibration"
                value={calibrated ? 'Nominal' : 'No telemetry'}
                color={calibrated ? 'good' : 'average'}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Metric
                label="Channel"
                value={
                  handshaking ? 'Handshaking' : channel ? 'Open' : 'Closed'
                }
                color={channel ? 'good' : handshaking ? 'blue' : 'label'}
              />
            </Stack.Item>
          </Stack>
        </Section>

        {!!handshaking && (
          <Section title="Handshake">
            <ProgressBar value={handshake_progress} color="blue">
              {`Negotiating link… ${Math.round(handshake_progress * 100)}%`}
            </ProgressBar>
            <Box mt={1} color="label">
              One-time link setup. The channel cannot be re-opened once it is
              established.
            </Box>
          </Section>
        )}

        {!handshaking && !linked && (
          <Section title="Deployment">
            <Box mb={1} color="label">
              Build the vent, then unfold the crate from here.
            </Box>
            {pack ? (
              <Button.Confirm
                fluid
                color="good"
                icon="expand-arrows-alt"
                confirmContent={
                  <Box bold fontSize="1.35em" py={1} textAlign="center">
                    Unfold the compressed vent here?
                  </Box>
                }
                onClick={() => act('deploy')}
              >
                <Box bold fontSize="1.35em" py={1} textAlign="center">
                  Unfold vent
                </Box>
              </Button.Confirm>
            ) : (
              <NoticeBox danger>
                No compressed vent within seven tiles. Build one on a machine
                frame first.
              </NoticeBox>
            )}
          </Section>
        )}

        {!handshaking && !!linked && !channel && (
          <Section title="Objective">
            <Box mb={1} color="label">
              Opening the channel completes the station goal. The handshake is
              one-time and cannot be repeated.
            </Box>
            <Button.Confirm
              fluid
              color="good"
              icon="satellite-dish"
              confirmContent={
                <Box bold fontSize="1.35em" py={1} textAlign="center">
                  Open the bluespace channel to CentCom?
                </Box>
              }
              onClick={() => act('establish')}
            >
              <Box bold fontSize="1.35em" py={1} textAlign="center">
                Establish bluespace channel
              </Box>
            </Button.Confirm>
          </Section>
        )}

        {!handshaking && !!channel && (
          <Section title="Condensate reward">
            <Box mb={1} color="label">
              Transport runs on its own. As a bonus, the vent condenses one
              canister for the station every five minutes.
            </Box>
            <Stack align="center">
              <Stack.Item grow basis={0}>
                <ProgressBar
                  value={charge}
                  color={canRelease ? 'good' : 'average'}
                >
                  {canRelease
                    ? 'Coils ready'
                    : `Coils cycling — ${Math.ceil(cooldown)}s`}
                </ProgressBar>
              </Stack.Item>
              <Stack.Item>
                <Button
                  compact
                  icon="eject"
                  color={canRelease ? 'good' : 'grey'}
                  disabled={!canRelease}
                  onClick={() => act('dispense')}
                >
                  {canRelease ? 'Condense' : 'Charging'}
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        )}

        {!!notice &&
          (notice_type === 'success' ? (
            <NoticeBox success>{notice}</NoticeBox>
          ) : notice_type === 'danger' ? (
            <NoticeBox danger>{notice}</NoticeBox>
          ) : (
            <NoticeBox info>{notice}</NoticeBox>
          ))}
      </Window.Content>
    </Window>
  );
}
