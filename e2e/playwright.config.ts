import { defineConfig, devices } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

// Load e2e/.env (BASE_URL, E2E_SECRET, LHC_USERNAME, LHC_PASSWORD) without extra deps.
const envFile = path.join(import.meta.dirname, '.env');
if (fs.existsSync(envFile)) {
    for (const line of fs.readFileSync(envFile, 'utf8').split(/\r?\n/)) {
        const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)\s*$/);
        if (match && process.env[match[1]] === undefined) {
            process.env[match[1]] = match[2].trim().replace(/^["']|["']$/g, '');
        }
    }
}

/**
 * Target environment. Point BASE_URL at any instance, e.g.:
 *   BASE_URL=http://127.0.0.1:8000 npx playwright test
 *   BASE_URL=https://example.com npx playwright test
 */
const baseURL = process.env.BASE_URL ?? 'http://127.0.0.1:8000';

// Sign-in credentials for the back office. The CI workflow provisions this
// operator with `php artisan lhc:admin admin admin`, so admin/admin is the
// default; override it with LHC_USERNAME/LHC_PASSWORD when needed.
process.env.LHC_USERNAME ||= 'admin';
process.env.LHC_PASSWORD ||= 'admin';

// Only boot the bundled app when the specs target a local instance.
const isLocalTarget = /^https?:\/\/(127\.0\.0\.1|localhost)(:\d+)?$/i.test(baseURL);

// Where the authenticated admin session is stored (git-ignored).
const authFile = path.join(import.meta.dirname, 'playwright/.auth/user.json');

export default defineConfig({
    // Where the specs live.
    testDir: './tests',

    // Widget boot is async (it loads its own JS/CSS in an iframe), so be generous.
    timeout: 60_000,
    expect: { timeout: 20_000 },

    fullyParallel: true,
    forbidOnly: !!process.env.CI,
    retries: process.env.CI ? 1 : 0,
    workers: process.env.CI ? 2 : undefined,

    reporter: process.env.CI
        ? [['github'], ['html', { open: 'never' }]]
        : [['list'], ['html', { open: 'never' }]],

    use: {
        baseURL,
        ignoreHTTPSErrors: true,
        trace: 'on-first-retry',
        screenshot: 'only-on-failure',
        video: 'retain-on-failure',
    },

    // When the specs target a local instance, Playwright boots the Laravel app
    // with PHP's built-in server (and stops it again). In CI this is what makes
    // the workflow self-contained; point BASE_URL elsewhere to disable it.
    // `--no-reload` is required so the legacy LHC_DB_*/E2E_SECRET variables are
    // passed through to the server process.
    webServer: isLocalTarget
        ? {
              command: 'php artisan serve --host=127.0.0.1 --port=8000 --no-reload',
              cwd: path.join(import.meta.dirname, '..'),
              // Laravel's health endpoint, so readiness does not depend on the
              // legacy framework being reachable yet.
              url: new URL('/up', baseURL).toString(),
              reuseExistingServer: !process.env.CI,
              timeout: 120_000,
          }
        : undefined,

    projects: [
        // Logs in once and writes playwright/.auth/user.json.
        // Only the authenticated project depends on it, so specs that need no
        // login (e.g. the need-help widget via E2E_SECRET) never trigger it.
        { name: 'setup', testMatch: /auth\.setup\.ts/ },

        // Signed-in specs. Requires the admin session captured by `setup`.
        {
            name: 'chromium',
            testIgnore: /need-help-widget\.spec\.ts|scroll-position\.spec\.ts/,
            use: { ...devices['Desktop Chrome'], storageState: authFile },
            dependencies: ['setup'],
        },

        // Public/anonymous specs — no login, no `setup` dependency.
        {
            name: 'chromium-anonymous',
            testMatch: /need-help-widget\.spec\.ts|scroll-position\.spec\.ts/,
            use: { ...devices['Desktop Chrome'] },
        },

        // Enable when you need them:
        // { name: 'firefox', use: { ...devices['Desktop Firefox'] } },
        // { name: 'webkit', use: { ...devices['Desktop Safari'] } },
    ],
});
