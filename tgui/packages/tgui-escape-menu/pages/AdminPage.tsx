import { Tooltip } from 'tgui-core/components';

// ZH EDIT ADDITION - I18N
import { t } from '../i18n';

type Props = {
  serverState: {
    canAdminHelp: boolean;
    canSeeNotes: boolean;
    hasTicketNotification: boolean;
  };
  onNavigate: (page: 'home') => void;
  onAction: (action: string) => void;
  onClose: () => void;
};

export function AdminPage({
  serverState,
  onNavigate,
  onAction,
  onClose,
}: Props) {
  return (
    <>
      <BackButton onClick={() => onNavigate('home')} />
      <div className="escape-menu__buttons escape-menu__buttons--page">
        <MenuButton
          onClick={() => {
            onAction('create_ticket');
            onClose();
          }}
          disabled={!serverState.canAdminHelp}
        >
          {t('Create Admin Ticket')}
        </MenuButton>
        <MenuButton
          onClick={() => onAction('view_ticket')}
          blinking={serverState.hasTicketNotification}
          tooltip={
            serverState.hasTicketNotification
              ? t('An admin is trying to talk to you!')
              : undefined
          }
        >
          {t('View Latest Ticket')}
        </MenuButton>
        <MenuButton
          onClick={() => {
            onAction('admin_notice');
            onClose();
          }}
        >
          {t('See Admin Notices')}
        </MenuButton>
        <MenuButton
          onClick={() => {
            onAction('pray');
            onClose();
          }}
        >
          {t('Pray')}
        </MenuButton>
        {!!serverState.canSeeNotes && (
          <MenuButton
            onClick={() => {
              onAction('see_notes');
              onClose();
            }}
          >
            {t('See Notes')}
          </MenuButton>
        )}
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

type MenuButtonProps = {
  children: React.ReactNode;
  onClick: () => void;
  disabled?: boolean;
  blinking?: boolean;
  tooltip?: string;
};

function MenuButton({
  children,
  onClick,
  disabled,
  blinking,
  tooltip,
}: MenuButtonProps) {
  const button = (
    <button
      className={
        'escape-menu__menu-button' +
        (disabled ? ' escape-menu__menu-button--disabled' : '') +
        (blinking ? ' escape-menu__menu-button--blinking' : '')
      }
      onClick={disabled ? undefined : onClick}
    >
      {children}
    </button>
  );

  if (tooltip) {
    return <Tooltip content={tooltip}>{button}</Tooltip>;
  }

  return button;
}
