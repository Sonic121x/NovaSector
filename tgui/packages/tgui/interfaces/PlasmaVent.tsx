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
        label: '握手中',
        color: 'blue',
        icon: 'satellite-dish',
        hint: '正在协商一次性蓝空链接。',
      }
    : channel
      ? {
          label: '通道开启',
          color: 'good',
          icon: 'broadcast-tower',
          hint: '通往中央指挥部的传输正常。',
        }
      : linked
        ? {
            label: '待机',
            color: 'average',
            icon: 'plug',
            hint: '已连接气泵，但通道仍关闭。',
          }
        : {
            label: '离线',
            color: 'bad',
            icon: 'unlink',
            hint: '此控制台未连接气泵。',
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
                    ? '此控制台已连接气泵。'
                    : '七格内未找到气泵。'
                }
              >
                <Box bold color={linked ? 'good' : 'bad'} fontSize="0.85em">
                  {linked ? '已连接' : '未连接'}
                </Box>
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Section>

        <Section title="遥测">
          <Stack>
            <Stack.Item grow basis={0}>
              <Metric
                label="校准"
                value={calibrated ? '正常' : '无遥测'}
                color={calibrated ? 'good' : 'average'}
              />
            </Stack.Item>
            <Stack.Item grow basis={0}>
              <Metric
                label="通道"
                value={
                  handshaking ? '握手中' : channel ? '开启' : '关闭'
                }
                color={channel ? 'good' : handshaking ? 'blue' : 'label'}
              />
            </Stack.Item>
          </Stack>
        </Section>

        {!!handshaking && (
          <Section title="握手">
            <ProgressBar value={handshake_progress} color="blue">
              {`协商链接… ${Math.round(handshake_progress * 100)}%`}
            </ProgressBar>
            <Box mt={1} color="label">
              一次性链接建立后，通道无法再次开启。
            </Box>
          </Section>
        )}

        {!handshaking && !linked && (
          <Section title="部署">
            <Box mb={1} color="label">
              先建造气泵，然后在这里展开压缩箱。
            </Box>
            {pack ? (
              <Button.Confirm
                fluid
                color="good"
                icon="expand-arrows-alt"
                confirmContent={
                  <Box bold fontSize="1.35em" py={1} textAlign="center">
                    在此展开压缩态气泵？
                  </Box>
                }
                onClick={() => act('deploy')}
              >
                <Box bold fontSize="1.35em" py={1} textAlign="center">
                  展开气泵
                </Box>
              </Button.Confirm>
            ) : (
              <NoticeBox danger>
                七格内没有压缩态气泵。请先在机架上建造一个。
              </NoticeBox>
            )}
          </Section>
        )}

        {!handshaking && !!linked && !channel && (
          <Section title="目标">
            <Box mb={1} color="label">
              开启通道即可完成站点目标。握手只能进行一次，无法重复。
            </Box>
            <Button.Confirm
              fluid
              color="good"
              icon="satellite-dish"
              confirmContent={
                <Box bold fontSize="1.35em" py={1} textAlign="center">
                  向中央指挥部开启蓝空通道？
                </Box>
              }
              onClick={() => act('establish')}
            >
              <Box bold fontSize="1.35em" py={1} textAlign="center">
                建立蓝空通道
              </Box>
            </Button.Confirm>
          </Section>
        )}

        {!handshaking && !!channel && (
          <Section title="凝结奖励">
            <Box mb={1} color="label">
              传输会自动进行。作为奖励，气泵每五分钟为空间站凝结一个压缩罐。
            </Box>
            <Stack align="center">
              <Stack.Item grow basis={0}>
                <ProgressBar
                  value={charge}
                  color={canRelease ? 'good' : 'average'}
                >
                  {canRelease
                    ? '线圈就绪'
                    : `线圈循环中 — ${Math.ceil(cooldown)} 秒`}
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
                  {canRelease ? '凝结' : '充能中'}
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
