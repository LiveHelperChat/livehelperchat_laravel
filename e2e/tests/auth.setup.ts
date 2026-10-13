import { test as setup, expect } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

export const AUTH_FILE = path.join(import.meta.dirname, '../playwright/.auth/user.json');

/**
 * Logs into the admin back office once and stores the session
 * (`storageState`) so every spec starts authenticated.
 *
 * Credentials come from environment variables or e2e/.env (never the repo):
 *   LHC_USERNAME=admin  LHC_PASSWORD=secret  npm test
 * If they are missing but a session was captured earlier, that one is reused.
 */
setup('authenticate as admin', async ({ page }) => {
    const username = process.env.LHC_USERNAME;
    const password = process.env.LHC_PASSWORD;

    if (!username || !password) {
        if (fs.existsSync(AUTH_FILE)) {
            return; // Reuse a previously captured session.
        }
        throw new Error(
            'No admin session available. Set LHC_USERNAME and LHC_PASSWORD ' +
            '(e.g. in e2e/.env) and run again.'
        );
    }

    await page.goto('/site_admin/user/login');

    await page.locator('input[name="Username"]').fill(username);
    await page.locator('input[name="Password"]').fill(password);
    await page.locator('input[name="Login"]').click();

    // A failed login stays on /user/login and keeps showing the heading.
    await expect(
        page.getByRole('heading', { name: /please login/i })
    ).toBeHidden({ timeout: 30_000 });

    fs.mkdirSync(path.dirname(AUTH_FILE), { recursive: true });
    await page.context().storageState({ path: AUTH_FILE });
});
