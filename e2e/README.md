# Live Helper Chat — E2E tests (Playwright)

Self-contained Playwright package. It is intentionally **not** part of the
app's root `package.json` (which only builds front-end assets).

## Setup

```bash
cd e2e
npm install
npx playwright install chromium   # downloads the browser binary
```

## Authentication

Specs run against the admin back office (`/site_admin/...`). Two mechanisms
are used and both are configured through environment variables or `e2e/.env`
(copy `.env.example`).

**1. Admin login (only the authenticated specs).** The `setup` project logs in
once and saves the session to `playwright/.auth/user.json` (git-ignored). Only
the `chromium` project depends on it — specs that need no session run in the
separate `chromium-anonymous` project and never trigger the login. Provide the
credentials:

```
LHC_USERNAME=admin
LHC_PASSWORD=admin
```

The credentials must exist in the target database. Provision the operator (and
reset its password) with the Artisan command shipped with the app — it stores
the password the same way the legacy framework expects
(`password_hash(..., PASSWORD_DEFAULT)` in `lh_users`):

```bash
php artisan lhc:admin admin admin
```

If they are missing but a session was captured earlier, that one is reused.
Run a spec that needs no login on its own with:

```bash
npx playwright test --project=chromium-anonymous
```

**2. Shared `E2E_SECRET` (demo page).** The demo page is reachable **without a
login** when the shared secret is passed as the `e2e_secret` query parameter
(see `public/modules/lhchat/demo.php`). It must match the `E2E_SECRET` value
configured on the target instance:

```
E2E_SECRET=secret
```

Without the secret the affected spec is skipped with a clear message — the
demo page would otherwise redirect to the login screen.

**3. Default widget theme (widget specs).** The demo page renders the widget
with the site's default widget theme. `database/schema.sql` ships with
`default_theme_id = 1` (the `Intro Bot` theme), so an imported schema already
has it. If the target instance still has `default_theme_id = 0`, the widget
falls back to its built-in defaults instead of the theme stored in the
database (no bot intro message, empty message list) and the scroll specs have
nothing to assert on — set it in the admin under *Abstract / Widget themes*.

```bash
cp .env.example .env   # then fill in the values
npm test
```

## Run

```bash
npm test
```

Target a different environment with `BASE_URL`:

```bash
BASE_URL=http://127.0.0.1:8000 npm test
BASE_URL=https://example.com npm test
```

When `BASE_URL` points at a local instance, Playwright boots the Laravel app
itself (`php artisan serve` on `http://127.0.0.1:8000`) and shuts it down
again. Point it at a remote instance to disable that.

Useful commands:

```bash
npm run test:headed   # watch the browser
npm run test:ui       # Playwright UI mode
npm run report        # open the last HTML report
```

## Continuous integration

The `playwright` job in `.github/workflows/tests.yml` runs this suite on pull
requests and pushes (next to the `tests` job that runs `php artisan test`). It
imports `database/schema.sql` into MySQL, provisions the `admin` operator with
`php artisan lhc:admin admin admin`, then lets Playwright boot the app with
PHP's built-in server and run the specs. The HTML report is uploaded as the
`playwright-report` artifact.

## Coverage

- `tests/login.spec.ts` — the `/site_admin/user/login` form renders, signs in
  with valid credentials, and rejects invalid ones.
- `tests/need-help-widget.spec.ts` — `/site_admin/chat/demo/(department)/1`
  must render the proactive **Need help?** bubble (`#lhc_needhelp_widget_v2`).
  Runs in the `chromium-anonymous` project: it uses the `E2E_SECRET` bypass,
  so no admin login (and no `setup`) is required.
- `tests/scroll-position.spec.ts` — after the widget loads its messages, the
  message list (`#messages-scroll`) inside the widget iframe must be scrolled
  to the bottom (latest message visible). Also covers the start → end → start
  another chat flow: once a chat is ended the widget minimizes, and starting a
  new chat after reopening it must again leave the list at the bottom. Covered
  on desktop and on a phone (iPhone emulation, which makes the widget use its
  `lhc-mobile` layout). Runs in the `chromium-anonymous` project via the
  `E2E_SECRET` bypass.

## Notes

- Default target is the local Laravel app on `http://127.0.0.1:8000` (see
  `playwright.config.ts`). Playwright starts it automatically when needed.
- The sign-in specs default to `admin` / `admin`; override them with
  `LHC_USERNAME` / `LHC_PASSWORD` for a different instance.
- Traces/screenshots/videos are captured on failure and written to
  `test-results/` (git-ignored).
- `login.spec.ts` resets the storage state per test so it exercises the form
  from a signed-out browser even though the project starts authenticated.
- Projects: `setup` (login), `chromium` (signed-in specs), `chromium-anonymous`
  (public specs, e.g. the demo widget). Only `chromium` depends on `setup`.
