import { perf } from 'common/perf';
import { setupDrag } from '../../drag';
// NOVA EDIT ADDITION - I18N
import { mergeCatalogOverlay } from '../../i18n/catalog';
import { logger } from '../../logging';
import { resumeRenderer } from '../../renderer';
import {
  configAtom,
  gameDataAtom,
  gameStaticDataAtom,
  sharedAtom,
  store,
  suspendedAtom,
} from '../store';
import type { BackendState } from '../types';

/// --------- Handlers ------------------------------------------------------///

type UpdatePayload = Omit<BackendState<Record<string, unknown>>, 'act'> & {
  static_data: Record<string, unknown>;
  // NOVA EDIT ADDITION - I18N: 负载 overlay（英文 → 译文），见 i18n/catalog.ts
  i18n?: Record<string, string>;
};

export function update(payload: UpdatePayload): void {
  if (store.get(suspendedAtom)) {
    resume(payload);
    store.set(suspendedAtom, false);
  }
  updateData(payload);
}

/// --------- Helpers -------------------------------------------------------///

/** Resumes the tgui window if suspended */
function resume(payload: UpdatePayload): void {
  // Show the payload
  logger.log('Resuming:', payload);
  // Signal renderer that we have resumed
  resumeRenderer();
  // Setup drag
  setupDrag();
  // We schedule this for the next tick here because resizing and unhiding
  // during the same tick will flash with a white background.
  setTimeout(() => {
    perf.mark('resume/start');
    // Doublecheck if we are not re-suspended.
    if (store.get(suspendedAtom)) {
      return;
    }

    perf.mark('resume/finish');

    if (process.env.NODE_ENV !== 'production') {
      logger.log('visible in', perf.measure('render/finish', 'resume/finish'));
    }
  });
}

/** Delegates update data to the appropriate store */
function updateData(payload: UpdatePayload): void {
  if (payload.config) {
    store.set(configAtom, (prev) => ({
      ...prev,
      ...payload.config,
    }));
  }

  // NOVA EDIT ADDITION START - I18N: 负载值保持 canonical English，译文走 overlay，渲染期查表。
  // 必须在 data/static_data 落库**之前**合并：同一帧的渲染会立刻用到这批译文。
  if (payload.i18n) {
    mergeCatalogOverlay(payload.i18n);
  }
  // NOVA EDIT ADDITION END

  if (payload.static_data) {
    store.set(gameStaticDataAtom, (prev) => ({
      ...prev,
      ...payload.static_data,
    }));
  }

  if (payload.data) {
    store.set(gameDataAtom, (prev) => ({
      ...prev,
      ...payload.data,
    }));
  }

  if (payload.shared) {
    const newShared = {} as Record<string, unknown>;

    for (const key in payload.shared) {
      const value = payload.shared[key];
      if (value === '') {
        newShared[key] = undefined;
      } else {
        newShared[key] = JSON.parse(value);
      }
    }

    store.set(sharedAtom, (prev) => ({
      ...prev,
      ...newShared,
    }));
  }
}
