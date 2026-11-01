// ZH EDIT ADDITION - I18N
import { describe, expect, it } from 'bun:test';
import { renderToStaticMarkup } from 'react-dom/server';

import table from '../../../strings/i18n/escape_menu_labels.json';
import { setTranslations, t } from './i18n';
import { HomePage } from './pages/HomePage';

const serverState = {
  stationName: 'Zxqv Station',
  canLeaveBody: false,
  canOpfor: true,
  canRespawn: false,
  canAdminHelp: true,
  hasTicketNotification: false,
  resources: [
    { id: 'wiki', label: 'Wiki', tooltip: 'See the wiki for the game' },
  ],
};

function renderHome() {
  return renderToStaticMarkup(
    <HomePage
      serverState={serverState}
      onNavigate={() => {}}
      onAction={() => {}}
      onClose={() => {}}
      showResources
      onToggleResources={() => {}}
    />,
  );
}

describe('escape menu labels', () => {
  it('stays English when the server sends an empty list', () => {
    setTranslations([]);
    expect(t('Resume')).toBe('Resume');
    expect(renderHome()).toContain('Admin Help');
  });

  it('shows the labels the server sends', () => {
    setTranslations(table['zh-Hans']);
    const html = renderHome();
    for (const english of [
      'Resume',
      'Character',
      'Admin Help',
      'Quit',
      'Resources',
      'Wiki',
    ]) {
      expect(html).not.toContain(`>${english}<`);
    }
    expect(html).toContain(table['zh-Hans'].Resume);
    expect(html).toContain('Zxqv Station');
  });
});
