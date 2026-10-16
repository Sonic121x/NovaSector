import { Box } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { TOOL_LABELS } from '../constants'; // ZH EDIT ADDITION - i18n

type Props = {
  tool: string;
};

export function ToolContent(props: Props) {
  const { tool } = props;

  return (
    <Box my={1}>
      <Box
        verticalAlign="middle"
        inline
        my={-1}
        mr={0.5}
        className={classes(['crafting32x32', tool.replace(/ /g, '')])}
      />
      <Box inline verticalAlign="middle">
        {TOOL_LABELS[tool] ?? tool /* ZH EDIT - i18n: localize display, keep value for icon class */}
      </Box>
    </Box>
  );
}
