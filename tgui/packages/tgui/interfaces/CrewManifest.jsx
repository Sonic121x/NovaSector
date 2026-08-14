import { Icon, Section, Table, Tooltip } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const commandJobs = [
  'Head of Personnel',
  'Head of Security',
  'Chief Engineer',
  'Research Director',
  'Chief Medical Officer',
  'Quartermaster',
  'Nanotrasen Consultant', // NOVA EDIT ADDITION
];

export const CrewManifest = (props) => {
  const {
    data: { manifest, positions },
  } = useBackend();

  return (
    <Window title="Crew Manifest" width={350} height={500}>
      <Window.Content scrollable>
        {Object.entries(manifest).map(([dept, crew]) => (
          <Section
            className={`CrewManifest--Section`}
            key={dept}
            style={{'--department-color': positions[dept].color}}
            title={
              // NOVA EDIT CHANGE - i18n: ORIGINAL: title={dept + (dept !== 'Misc' ? ` (${positions[dept].open} positions open)` : '')}
              // 整串原来是 JS 拼接的运行期产物，永远不是目录键 → 部门名与括号里的文案都翻不到。
              // 拆成 children 模板：部门名包进元素当占位符（自身作为独立目录键 auto-localize），
              // 外框整条抽成 `{0} ({1} positions open)` 由 localizeChildrenTemplate 按中文语序回填。
              dept !== 'Misc' ? (
                <>
                  <span>{dept}</span> ({positions[dept].open} positions open)
                </>
              ) : (
                dept
              )
            }
          >
            <Table>
              {Object.entries(crew).map(([crewIndex, crewMember]) => (
                <Table.Row key={crewIndex}>
                  <Table.Cell
                    className={'CrewManifest__Cell'}
                    maxWidth="135px"
                    overflow="hidden"
                    width="50%"
                  >
                    {crewMember.name}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Icons',
                    ])}
                    collapsing
                    minWidth="40px"
                    width="40px"
                  >
                    {positions[dept].exceptions.includes(crewMember.rank) && (
                      <Tooltip content="No position limit" position="bottom">
                        <Icon className="CrewManifest__Icon" name="infinity" />
                      </Tooltip>
                    )}
                    {crewMember.trim === 'Captain' && (
                      <Tooltip content="Captain" position="bottom">
                        <Icon
                          className={classes([
                            'CrewManifest__Icon',
                            'CrewManifest__Icon--Command',
                          ])}
                          name="star"
                        />
                      </Tooltip>
                    )}
                    {commandJobs.includes(crewMember.trim) && (
                      <Tooltip content="Member of command" position="bottom">
                        <Icon
                          className={classes([
                            'CrewManifest__Icon',
                            'CrewManifest__Icon--Command',
                            'CrewManifest__Icon--Chevron',
                          ])}
                          name="chevron-up"
                        />
                      </Tooltip>
                    )}
                  </Table.Cell>
                  <Table.Cell
                    className={classes([
                      'CrewManifest__Cell',
                      'CrewManifest__Cell--Rank',
                    ])}
                    collapsing
                    maxWidth="135px"
                    overflow="hidden"
                    width="50%"
                  >
                    {crewMember.rank}
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        ))}
      </Window.Content>
    </Window>
  );
};
