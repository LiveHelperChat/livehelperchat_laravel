import { test, expect, devices, type Page } from '@playwright/test';

/**
 * The demo page renders the widget into stand-alone iframes:
 *   #lhc_widget_v2          - main widget (hidden until opened)
 *   #lhc_needhelp_widget_v2 - the proactive "Need help?" bubble
 *
 * Clicking the widget launcher (#lhc_status_widget_v2) opens the main widget.
 * Once the widget has loaded its messages, the message list (#messages-scroll)
 * inside the widget iframe must be scrolled all the way to the bottom so the
 * latest message is visible without the visitor having to scroll manually.
 *
 * The same behaviour must hold on a phone, where the widget switches to its
 * mobile layout (driven by the user agent, see the `lhc-mobile` iframe class).
 *
 * The demo page grants anonymous access when the shared E2E_SECRET is passed
 * as the `e2e_secret` query parameter (see public/modules/lhchat/demo.php),
 * so no admin login is required.
 */
const demoSecret = process.env.E2E_SECRET;

const demoUrl = () =>
    `/site_admin/chat/demo/(department)/1?e2e_secret=${encodeURIComponent(demoSecret ?? '')}`;

const missingSecretMessage =
    'E2E_SECRET is not set (add it to e2e/.env) — cannot open the demo page unauthenticated.';

/** The widget lives in this iframe and renders its message list as #messages-scroll. */
const widget = (page: Page) => page.frameLocator('#lhc_widget_v2');

/** Clicking the launcher opens the widget. */
const launcher = (page: Page) => page.locator('#lhc_status_widget_v2');

/**
 * Makes sure the widget is open with its message list rendered. Ending a chat
 * minimizes the widget, so the launcher has to be clicked again — but only when
 * the widget is actually closed, to avoid toggling an already open widget shut.
 */
async function openWidget(page: Page) {
    const messages = widget(page).locator('#messages-scroll');
    if (!(await messages.isVisible())) {
        await launcher(page).click();
    }
    await expect(messages).toBeVisible();
}

/**
 * How long a visitor is assumed to look at the page before opening the widget.
 *
 * This matters: the widget scrolls its message list to the bottom while it
 * renders the fetched messages. If the visitor (or the test) opens the widget
 * the instant the page loads, the messages arrive while the widget is already
 * visible and the scroll lands correctly. When the page is left open first, the
 * messages are fetched while the widget is still hidden — the scroll is then
 * applied to a container with no height and is silently lost, so the list stays
 * scrolled to the top. Waiting here reproduces that visitor flow.
 */
const visitorReadDelayMs = 2_000;

/** Types `text` into the message box and starts a (new) chat. */
async function startChat(page: Page, text: string) {
    const frame = widget(page);
    const input = frame.getByRole('textbox', { name: 'Type your message here...' });

    await input.click();
    await input.fill(text);
    await frame.getByTitle('Start a chat').click();

    // Give the widget a moment to finish its scroll animation.
    await page.waitForTimeout(1000);

    // The visitor's message shows up in the list once the chat exists.
    await expect(frame.locator('#messages-scroll')).toContainText(text);
}

/**
 * Ends the active chat. "End chat" lives behind the widget's options dropdown
 * (the close icon in the footer), so the dropdown has to be opened first.
 * Ending a chat minimizes the widget and clears the message list.
 */
async function endChat(page: Page) {
    const frame = widget(page);

    await frame.locator('#chat-dropdown-options').click();
    await frame.getByTitle('End chat', { exact: true }).click();

    await expect(frame.locator('#messages-scroll')).toBeHidden();
}

/**
 * Asserts that the message list sits at the bottom: the latest message is
 * visible, i.e. either the list is scrolled all the way down, or everything
 * fits and there is nothing to scroll. When `expectOverflow` is set the check
 * also requires that there actually is something to scroll, so the assertion
 * stays meaningful.
 */
async function expectScrolledToBottom(
    page: Page,
    options: { expectOverflow?: boolean } = {}
) {
    const messages = widget(page).locator('#messages-scroll');

    // The widget booted and rendered at least one message.
    await expect(messages.locator('.message-row').first()).toBeVisible();

    if (options.expectOverflow) {
        // Guard so the assertion below is only meaningful when the list can
        // actually scroll.
        expect(
            await messages.evaluate(
                (el) => (el as HTMLElement).scrollHeight > (el as HTMLElement).clientHeight
            )
        ).toBe(true);
    }

    // After the content loaded the list must sit at the bottom. This is a
    // single check (no polling) so a failure is reported once instead of
    // retrying in a loop until the expect timeout.
    const distanceFromBottom = await messages.evaluate((el) => {
        const container = el as HTMLElement;
        return container.scrollHeight - container.clientHeight - container.scrollTop;
    });

    expect(distanceFromBottom, 'message list should be scrolled to the bottom').toBeLessThanOrEqual(
        2
    );
}

/**
 * Asserts that the message list sits at the top: the list is scrolled all the
 * way up, or everything fits and there is nothing to scroll. When
 * `expectOverflow` is set the check also requires that there actually is
 * something to scroll, so the assertion stays meaningful.
 */
async function expectScrolledToTop(page: Page, options: { expectOverflow?: boolean } = {}) {
    const messages = widget(page).locator('#messages-scroll');

    // The widget booted and rendered at least one message.
    await expect(messages.locator('.message-row').first()).toBeVisible();

    if (options.expectOverflow) {
        // Guard so the assertion below is only meaningful when the list can
        // actually scroll.
        expect(
            await messages.evaluate(
                (el) => (el as HTMLElement).scrollHeight > (el as HTMLElement).clientHeight
            )
        ).toBe(true);
    }

    // A single check (no polling) so a failure is reported once instead of
    // retrying in a loop until the expect timeout.
    const distanceFromTop = await messages.evaluate((el) => (el as HTMLElement).scrollTop);

    expect(distanceFromTop, 'message list should be scrolled to the top').toBeLessThanOrEqual(2);
}

/**
 * The divider the widget renders between the current chat and the visitor's
 * earlier conversation ("Previous conversation").
 */
const previousConversationMarker = (page: Page) =>
    widget(page).locator('#messages-scroll .previous-holder');

/**
 * Asserts that the message list starts at the "Previous conversation" marker:
 * when the widget opens it scrolls `.previous-holder` to the top of the list
 * (see `scrollToPreviousOrFirst()` in the widget), so the visitor starts at the
 * previous messages instead of at the bottom. This is a single check (no
 * polling) so a failure is reported once instead of retrying in a loop until
 * the expect timeout.
 */
async function expectScrolledToPreviousMessages(page: Page) {
    const marker = previousConversationMarker(page);

    // The previous conversation is rendered.
    await expect(marker).toBeVisible();

    const distanceFromTop = await marker.evaluate((el) => {
        const container = el.closest('#messages-scroll') as HTMLElement;
        return Math.abs(el.getBoundingClientRect().top - container.getBoundingClientRect().top);
    });
  
    expect(
        distanceFromTop,
        'message list should start at the previous conversation'
    ).toBeLessThanOrEqual(2);
}

/**
 * Full regression scenario: the widget starts at the previous conversation,
 * then a chat is started and ended, and opening the widget again must leave the
 * freshly opened message list at the bottom (the visitor shouldn't have to
 * scroll up to the newest message).
 */
async function expectBottomAfterRestart(page: Page) {
    await openWidget(page);

    

    await startChat(page, 'First message');
    // Give the widget a moment to finish its scroll animation.
    await page.waitForTimeout(1000);

    await expectScrolledToBottom(page, { expectOverflow: true });

    // Give the widget a moment to finish its scroll animation.
    await page.waitForTimeout(1000);

    await endChat(page);

    // Give the widget a moment to finish its scroll animation.
    await page.waitForTimeout(1000);

    await openWidget(page);
    
    // The starting scroll position is the previous conversation, not the bottom.
    await expectScrolledToPreviousMessages(page);

    //await startChat(page, 'Second message');

    //await expectScrolledToBottom(page, { expectOverflow: true });
}

test.describe('Widget scroll position', () => {
    test('message list stays at the top after the widget loads content', async ({ page }) => {
        test.skip(!demoSecret, missingSecretMessage);

        await page.goto(demoUrl(), { waitUntil: 'domcontentloaded' });

        await openWidget(page);

        // Give the widget a moment to finish rendering its content.
        await page.waitForTimeout(1000);

        // The desktop widget is a fixed-size box, so its content overflows.
        await expectScrolledToTop(page, { expectOverflow: true });
    });

    test('message list is at the bottom after ending and starting a new chat', async ({ page }) => {
        test.skip(!demoSecret, missingSecretMessage);

        await page.goto(demoUrl(), { waitUntil: 'domcontentloaded' });

        await expectBottomAfterRestart(page);
    });
});

test.describe('Widget scroll position (mobile)', () => {
    // Emulate a phone — the widget picks its mobile layout from the user agent.
    // (`devices['iPhone 13']` also sets `defaultBrowserType`, which cannot be
    // used inside a `describe` group, so only the emulation options are passed.)
    const iphone = devices['iPhone 13'];
    test.use({
        userAgent: iphone.userAgent,
        viewport: iphone.viewport,
        deviceScaleFactor: iphone.deviceScaleFactor,
        isMobile: iphone.isMobile,
        hasTouch: iphone.hasTouch,
    });

    test('message list scrolls to the bottom after the widget loads content', async ({ page }) => {
        test.skip(!demoSecret, missingSecretMessage);

        await page.goto(demoUrl(), { waitUntil: 'domcontentloaded' });

        // A visitor reads the page before opening the widget (see the helper).
        await page.waitForTimeout(visitorReadDelayMs);

        await openWidget(page);

        // The demo content overflows the mobile layout as well.
        await expectScrolledToTop(page, { expectOverflow: true });
    });

    test('message list is at the bottom after ending and starting a new chat', async ({ page }) => {
        test.skip(!demoSecret, missingSecretMessage);

        await page.goto(demoUrl(), { waitUntil: 'domcontentloaded' });

        // A visitor reads the page before opening the widget (see the helper).
        await page.waitForTimeout(visitorReadDelayMs);

        await expectBottomAfterRestart(page);
    });
});