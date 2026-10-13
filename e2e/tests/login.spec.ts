import { test, expect } from '@playwright/test';

/**
 * Covers the admin back office login form.
 *
 * The chromium project hands every spec the admin session captured by
 * tests/auth.setup.ts, so this spec resets the storage state to exercise the
 * login page from a signed-out browser.
 */
test.use({ storageState: { cookies: [], origins: [] } });

const username = process.env.LHC_USERNAME;
const password = process.env.LHC_PASSWORD;

test.describe('Login page', () => {
    test('renders the login form', async ({ page }) => {
        await page.goto('/site_admin/user/login');

        await expect(
            page.getByRole('heading', { name: /please login/i })
        ).toBeVisible();
        await expect(page.locator('input[name="Username"]')).toBeVisible();
        await expect(page.locator('input[name="Password"]')).toBeVisible();
        await expect(page.locator('input[name="Login"]')).toBeVisible();
    });

    test('signs in with valid credentials', async ({ page }) => {
        test.skip(
            !username || !password,
            'LHC_USERNAME/LHC_PASSWORD are not set (add them to e2e/.env).'
        );

        await page.goto('/site_admin/user/login');

        await page.locator('input[name="Username"]').fill(username ?? '');
        await page.locator('input[name="Password"]').fill(password ?? '');
        await page.locator('input[name="Login"]').click();

        // A successful login leaves the login page behind.
        await expect(
            page.getByRole('heading', { name: /please login/i })
        ).toBeHidden({ timeout: 30_000 });
    });

    test('rejects invalid credentials', async ({ page }) => {
        await page.goto('/site_admin/user/login');

        await page.locator('input[name="Username"]').fill('lhc_e2e_no_such_user');
        await page.locator('input[name="Password"]').fill('definitely-wrong-password');
        await page.locator('input[name="Login"]').click();

        // A failed login re-renders the form with an error message.
        await expect(
            page.getByRole('heading', { name: /please login/i })
        ).toBeVisible({ timeout: 30_000 });
        await expect(
            page.getByText(/incorrect username or password/i)
        ).toBeVisible();
    });
});
