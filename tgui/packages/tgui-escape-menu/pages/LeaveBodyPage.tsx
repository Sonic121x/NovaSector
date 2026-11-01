import type { ServerState } from '../EscapeMenu';
// ZH EDIT ADDITION - I18N
import { t } from '../i18n';

type Props = {
  serverState: ServerState;
  onNavigate: (page: 'home') => void;
  onAction: (action: string) => void;
  onClose: () => void;
};

export function LeaveBodyPage({
  serverState,
  onNavigate,
  onAction,
  onClose,
}: Props) {
  return (
    <>
      <BackButton onClick={() => onNavigate('home')} />
      <div className="escape-menu__leave-body">
        <button
          className="escape-menu__large-button"
          onClick={() => {
            onAction('suicide');
            onClose();
          }}
        >
          <div className="escape-menu__icon-button">
            <span className="escape-menu-icons96x96 leave-template" />
            {serverState.suicideIcon && (
              <img
                className="escape-menu__suicide-icon-overlay"
                src={`data:image/png;base64,${serverState.suicideIcon}`}
                alt=""
              />
            )}
          </div>
          <div className="escape-menu__large-button-label">{t('Suicide')}</div>
        </button>
        <button
          className="escape-menu__large-button"
          onClick={() => {
            onAction('ghost');
            onClose();
          }}
        >
          <div className="escape-menu__icon-button">
            <span className="escape-menu-icons96x96 leave-template" />
            <span className="escape-menu-icons96x96 leave-ghost escape-menu__icon-overlay" />
          </div>
          <div className="escape-menu__large-button-label">{t('Ghost')}</div>
        </button>
      </div>
    </>
  );
}

function BackButton({ onClick }: { onClick: () => void }) {
  return (
    <button className="escape-menu__back-button" onClick={onClick}>
      <div className="escape-menu__icon-button">
        <span className="escape-menu-icons40x40 template" />
        <span className="escape-menu-icons40x40 back escape-menu__icon-overlay" />
      </div>
      <span>{t('Back')}</span>
    </button>
  );
}
