<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;

/**
 * Creates or updates a Live Helper Chat back-office operator.
 *
 * The legacy framework verifies the password with password_verify(), so the
 * password has to be stored as a hash in `lh_users`. This command is used by
 * the CI e2e workflow to guarantee the `admin` / `admin` credentials exist
 * before the Playwright specs sign in.
 */
class SetAdminCredentials extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'lhc:admin
        {username=admin : The operator login}
        {password=admin : The operator password}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Create or update a Live Helper Chat operator (defaults to admin/admin)';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $username = (string) $this->argument('username');
        $password = (string) $this->argument('password');

        // Matches erLhcoreClassModelUser::setPassword() used by the legacy app.
        $hash = password_hash($password, PASSWORD_DEFAULT);
        $now = time();

        $user = DB::table('lh_users')->where('username', $username)->first();

        if ($user === null) {
            $userId = DB::table('lh_users')->insertGetId([
                'username' => $username,
                'password' => $hash,
                'email' => $username.'@example.com',
                'time_zone' => '',
                'name' => $username,
                'surname' => '',
                'filepath' => '',
                'filename' => '',
                'job_title' => '',
                'departments_ids' => '',
                'chat_nickname' => '',
                'xmpp_username' => '',
                'session_id' => '',
                'avatar' => '',
                'operation_admin' => '',
                'skype' => '',
                'exclude_autoasign' => 0,
                'disabled' => 0,
                'hide_online' => 0,
                'all_departments' => 1,
                'invisible_mode' => 0,
                'inactive_mode' => 0,
                'rec_per_req' => 0,
                'auto_accept' => 0,
                'max_active_chats' => 0,
                'pswd_updated' => $now,
                'attr_int_1' => 0,
                'attr_int_2' => 0,
                'attr_int_3' => 0,
            ]);

            // Give the operator full access unless it is already attached.
            if (DB::table('lh_group')->where('id', 1)->exists()) {
                DB::table('lh_groupuser')->updateOrInsert([
                    'group_id' => 1,
                    'user_id' => $userId,
                ]);
            }

            $this->info("Created operator [{$username}] with the given password.");

            return self::SUCCESS;
        }

        DB::table('lh_users')->where('id', $user->id)->update([
            'password' => $hash,
            'disabled' => 0,
            'force_logout' => 0,
            'pswd_updated' => $now,
        ]);

        $this->info("Updated the password for operator [{$username}].");

        return self::SUCCESS;
    }
}
