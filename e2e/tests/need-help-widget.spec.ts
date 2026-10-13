import { test, expect } from '@playwright/test';

/**
 * The demo page renders the widget into stand-alone iframes:
 *   #lhc_widget_v2          - main widget (hidden until opened)
 *   #lhc_needhelp_widget_v2 - the proactive "Need help?" bubble
 *
 * The need-help bubble starts as `display:none` and is revealed once its
 * iframe content finishes loading, so we wait for the heading inside the
 * iframe instead of using a fixed timeout.
 *
 * The demo page grants anonymous access when the shared E2E_SECRET is passed
 * as the `e2e_secret` query parameter (see public/modules/lhchat/demo.php),
 * so no admin login is required.
 */
const demoSecret = process.env.E2E_SECRET;

test.describe('Need help widget', () => {
    test('demo page shows the need help widget bubble', async ({ page }) => {
        test.skip(
            !demoSecret,
            'E2E_SECRET is not set (add it to e2e/.env) — cannot open the demo page unauthenticated.'
        );

        await page.goto(
            `/site_admin/chat/demo/(department)/1?e2e_secret=${encodeURIComponent(demoSecret ?? '')}`,
            { waitUntil: 'domcontentloaded' }
        );

        await expect(page.locator('#lhc_needhelp_widget_v2')).toBeVisible();

        const needHelp = page.frameLocator('#lhc_needhelp_widget_v2');
        await expect(
            needHelp.getByRole('heading', { name: /need help\?/i })
        ).toBeVisible();
        await expect(
            needHelp.getByText(/our staff are always ready to help/i)
        ).toBeVisible();
    });
});
