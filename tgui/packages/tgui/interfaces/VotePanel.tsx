import {
  BlockQuote,
  Box,
  Button,
  Dimmer,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

enum VoteConfig {
  None = -1,
  Disabled = 0,
  Enabled = 1,
}

type Vote = {
  name: string;
  canBeInitiated: BooleanLike;
  config: VoteConfig;
  message: string;
};

type Option = {
  // NOVA EDIT ADDITION - i18n: `id` 是英文原键，**act 回传/选中比较一律用它**（"id" 在
  // payload_skip_keys 里，P1 绝不会译它）。`name` 现在是显示名（地图投票为「三角洲站-Delta
  // Station」）。老服务端没有 id 时回落 name，行为与从前一致。
  id?: string;
  name: string;
  votes: number;
};

type ActiveVote = {
  vote: Vote;
  question: string | null;
  timeRemaining: number;
  displayStatistics: boolean;
  choices: Option[];
  countMethod: number;
};

type UserData = {
  ckey: string;
  isGhost: BooleanLike;
  isLowerAdmin: BooleanLike;
  isUpperAdmin: BooleanLike;
  singleSelection: string | null;
  multiSelection: string[] | null;
  countMethod: VoteSystem;
};

enum VoteSystem {
  VOTE_SINGLE = 1,
  VOTE_MULTI = 2,
}

type Data = {
  currentVote: ActiveVote;
  possibleVotes: Vote[];
  user: UserData;
  LastVoteTime: number;
  VoteCD: number;
  deadVoteEnabled: BooleanLike;
};

export const VotePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user, LastVoteTime, VoteCD } = data;

  let windowTitle = 'Vote';
  if (currentVote) {
    windowTitle +=
      ': ' +
      (currentVote.question || currentVote.vote.name).replace(/^\w/, (c) =>
        c.toUpperCase(),
      );
  }

  return (
    <Window title={windowTitle} width={400} height={500}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section
              title="New Vote"
              buttons={
                !!user.isLowerAdmin && (
                  <Stack>
                    <Stack.Item>
                      <Button
                        icon="refresh"
                        disabled={LastVoteTime + VoteCD <= 0}
                        onClick={() => act('resetCooldown')}
                      >
                        Reset cooldown
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button.Checkbox
                        disabled={!user.isUpperAdmin}
                        onClick={() => act('toggleDeadVote')}
                        checked={!data.deadVoteEnabled}
                        color="primary"
                      >
                        Dead votes
                      </Button.Checkbox>
                    </Stack.Item>
                  </Stack>
                )
              }
            >
              <VoteOptions />
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable title="Active Vote">
              <ChoicesPanel />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <TimePanel />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const VoteOptionDimmer = (props) => {
  const { data } = useBackend<Data>();
  const { LastVoteTime, VoteCD } = data;

  return (
    <Dimmer>
      <Box textAlign="center">
        <Box fontSize={2} bold>
          Vote Cooldown
        </Box>
        <Box fontSize={1.5}>{Math.floor((VoteCD + LastVoteTime) / 10)}s</Box>
      </Box>
    </Dimmer>
  );
};

const VoteOptions = (props) => {
  const { act, data } = useBackend<Data>();
  const { possibleVotes, user, LastVoteTime, VoteCD } = data;

  return (
    <Stack.Item>
      {LastVoteTime + VoteCD > 0 && <VoteOptionDimmer />}
      <Stack vertical justify="space-between">
        {possibleVotes.map((option) => (
          <Stack.Item key={option.name}>
            <Stack>
              {!!user.isLowerAdmin && (
                <Stack.Item>
                  <Button.Checkbox
                    color="primary"
                    checked={
                      option.config === VoteConfig.Enabled ||
                      option.config === VoteConfig.None
                    }
                    disabled={
                      !user.isUpperAdmin || option.config === VoteConfig.None
                    }
                    tooltip={
                      option.config === VoteConfig.None
                        ? 'This vote cannot be disabled.'
                        : null
                    }
                    onClick={() =>
                      act('toggleVote', {
                        voteName: option.name,
                      })
                    }
                  >
                    Active
                  </Button.Checkbox>
                </Stack.Item>
              )}
              <Stack.Item>
                <Button
                  disabled={!option.canBeInitiated}
                  onClick={() =>
                    act('callVote', {
                      voteName: option.name,
                    })
                  }
                  icon="play"
                />
              </Stack.Item>
              <Stack.Item>
                <Tooltip content={option.message}>
                  <BlockQuote style={{ lineHeight: '1.7em' }}>
                    {option.name} Vote
                  </BlockQuote>
                </Tooltip>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Stack.Item>
  );
};

const ChoicesPanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user } = data;

  return (
    <>
      {currentVote && currentVote.countMethod === VoteSystem.VOTE_SINGLE ? (
        <NoticeBox success>Select one option</NoticeBox>
      ) : null}
      {currentVote &&
      currentVote.choices.length !== 0 &&
      currentVote.countMethod === VoteSystem.VOTE_SINGLE ? (
        <LabeledList>
          {currentVote.choices.map((choice) => (
            <Box key={choice.id ?? choice.name}>
              <LabeledList.Item
                label={choice.name.replace(/^\w/, (c) => c.toUpperCase())}
                textAlign="right"
                buttons={
                  <Button
                    tooltip={
                      user.isGhost && 'Ghost voting was disabled by an admin.'
                    }
                    disabled={
                      user.singleSelection === (choice.id ?? choice.name) ||
                      user.isGhost
                    }
                    onClick={() => {
                      // NOVA EDIT CHANGE - i18n: 回传英文键 - ORIGINAL: { voteOption: choice.name }
                      act('voteSingle', { voteOption: choice.id ?? choice.name });
                    }}
                  >
                    Vote
                  </Button>
                }
              >
                {user.singleSelection &&
                  (choice.id ?? choice.name) === user.singleSelection && (
                    <Icon align="right" mr={2} color="green" name="vote-yea" />
                  )}
                {/* NOVA EDIT CHANGE - i18n: ORIGINAL: {(currentVote.displayStatistics || user.isLowerAdmin) ? `${choice.votes} Votes` : null}
                    拼出来的整串永远不是目录键 → 拆成 children 模板 `{0} Votes`。 */}
                {currentVote.displayStatistics || user.isLowerAdmin ? (
                  <>
                    <span>{choice.votes}</span> Votes
                  </>
                ) : null}
              </LabeledList.Item>
              <LabeledList.Divider />
            </Box>
          ))}
        </LabeledList>
      ) : null}
      {currentVote && currentVote.countMethod === VoteSystem.VOTE_MULTI ? (
        <NoticeBox success>Select any number of options</NoticeBox>
      ) : null}
      {currentVote &&
      currentVote.choices.length !== 0 &&
      currentVote.countMethod === VoteSystem.VOTE_MULTI ? (
        <LabeledList>
          {currentVote.choices.map((choice) => (
            <Box key={choice.id ?? choice.name}>
              <LabeledList.Item
                label={choice.name.replace(/^\w/, (c) => c.toUpperCase())}
                textAlign="right"
                buttons={
                  <Button
                    tooltip={
                      user.isGhost && 'Ghost voting was disabled by an admin.'
                    }
                    disabled={user.isGhost}
                    onClick={() => {
                      // NOVA EDIT CHANGE - i18n: 回传英文键 - ORIGINAL: { voteOption: choice.name }
                      act('voteMulti', { voteOption: choice.id ?? choice.name });
                    }}
                  >
                    Vote
                  </Button>
                }
              >
                {user.multiSelection &&
                user.multiSelection[
                  user.ckey.concat(choice.id ?? choice.name)
                ] === 1 ? (
                  <Icon align="right" mr={2} color="blue" name="vote-yea" />
                ) : null}
                {/* // NOVA EDIT REMOVAL choice.votes} Votes */ }
                {/* NOVA EDIT ADDITION - i18n: children 模板 `{0} Votes`（整串拼接不是目录键） */}
                {user.isLowerAdmin ? (
                  <>
                    <span>{choice.votes}</span> Votes
                  </>
                ) : (
                  ''
                )}
              </LabeledList.Item>
              <LabeledList.Divider />
            </Box>
          ))}
        </LabeledList>
      ) : null}
      {currentVote ? null : <NoticeBox>No vote active!</NoticeBox>}
    </>
  );
};

const TimePanel = (props) => {
  const { act, data } = useBackend<Data>();
  const { currentVote, user } = data;

  return (
    <Stack.Item>
      <Stack justify="space-between">
        <Box fontSize={1.5}>
          {/* NOVA EDIT CHANGE - i18n: ORIGINAL: {currentVote ? `Time remaining: ${currentVote.timeRemaining}s` : 'No current vote'}
              拼出来的整串永远不是目录键 → 拆成 children 模板 `Time remaining: {0}s`。 */}
          {currentVote ? (
            <>
              Time remaining: <span>{currentVote.timeRemaining}</span>s
            </>
          ) : (
            'No current vote'
          )}
        </Box>
        {!!user.isLowerAdmin && (
          <Stack>
            <Stack.Item>
              <Button
                color="green"
                disabled={!user.isLowerAdmin || !currentVote}
                onClick={() => act('endNow')}
                style={{ lineHeight: '1.8em' }}
              >
                End Now
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                color="red"
                disabled={!user.isLowerAdmin || !currentVote}
                onClick={() => act('cancel')}
                style={{ lineHeight: '1.8em' }}
              >
                Cancel
              </Button>
            </Stack.Item>
          </Stack>
        )}
      </Stack>
    </Stack.Item>
  );
};
