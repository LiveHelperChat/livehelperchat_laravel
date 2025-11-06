-- Adminer 4.8.1 MySQL 5.5.5-10.3.35-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `lhc_mailconv_conversation`;
CREATE TABLE `lhc_mailconv_conversation` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `status` int(11) unsigned NOT NULL,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) unsigned NOT NULL,
  `priority` int(11) NOT NULL DEFAULT 0,
  `priority_asc` int(11) NOT NULL DEFAULT 0,
  `from_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_address` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_address_clean` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_message_id` bigint(20) unsigned NOT NULL,
  `message_id` bigint(20) unsigned NOT NULL,
  `udate` bigint(20) unsigned NOT NULL,
  `date` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailbox_id` bigint(20) unsigned NOT NULL,
  `opened_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `total_messages` int(11) unsigned NOT NULL,
  `match_rule_id` int(11) unsigned NOT NULL,
  `cls_time` int(11) unsigned NOT NULL,
  `pnd_time` int(11) unsigned NOT NULL,
  `wait_time` int(11) unsigned NOT NULL,
  `accept_time` int(11) unsigned NOT NULL,
  `response_time` int(11) NOT NULL,
  `interaction_time` int(11) NOT NULL,
  `lr_time` int(11) unsigned NOT NULL,
  `tslasign` int(11) unsigned NOT NULL,
  `start_type` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `transfer_uid` int(11) unsigned NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `conv_duration` int(11) NOT NULL DEFAULT 0,
  `mail_variables` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_attachment` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `pending_sync` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `follow_up_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `undelivered` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `lang` (`lang`),
  KEY `from_address` (`from_address`),
  KEY `mailbox_id` (`mailbox_id`),
  KEY `dep_id` (`dep_id`),
  KEY `mailbox_id_status_udate` (`mailbox_id`,`status`,`udate`),
  KEY `status_priority` (`status`,`priority`),
  KEY `status_priority_asc` (`status`,`priority_asc`),
  KEY `has_attachment` (`has_attachment`),
  KEY `udate` (`udate`),
  KEY `user_id_status` (`user_id`,`status`),
  KEY `status_dep_id` (`status`,`dep_id`),
  KEY `undelivered` (`undelivered`),
  KEY `phone` (`phone`),
  KEY `from_address_clean` (`from_address_clean`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_delete_filter`;
CREATE TABLE `lhc_mailconv_delete_filter` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delete_policy` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `processed_records` bigint(20) unsigned NOT NULL DEFAULT 0,
  `updated_at` bigint(20) unsigned NOT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `archive_id` int(11) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `last_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `started_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `finished_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `filter` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `filter_input` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_delete_item`;
CREATE TABLE `lhc_mailconv_delete_item` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint(20) unsigned NOT NULL,
  `filter_id` bigint(20) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `filter_id_status` (`filter_id`,`status`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_file`;
CREATE TABLE `lhc_mailconv_file` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `message_id` bigint(20) unsigned NOT NULL,
  `size` int(11) unsigned NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attachment_id` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_id` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disposition` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conversation_id` bigint(20) unsigned NOT NULL,
  `meta_msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `width` int(11) unsigned NOT NULL DEFAULT 0,
  `height` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`),
  KEY `conversation_id` (`conversation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_mailbox`;
CREATE TABLE `lhc_mailconv_mailbox` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delete_on_archive` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `delete_policy` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `mail` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `host` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `port` int(11) unsigned NOT NULL,
  `workflow_options` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `imap` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_sync_log` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `sync_started` bigint(20) unsigned NOT NULL,
  `last_sync_time` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `mailbox_sync` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `sync_status` int(11) unsigned NOT NULL,
  `sync_interval` int(11) unsigned NOT NULL,
  `signature` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `signature_under` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `import_since` int(11) unsigned NOT NULL DEFAULT 0,
  `dep_id` int(11) unsigned NOT NULL DEFAULT 0,
  `delete_mode` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `reopen_timeout` int(11) unsigned NOT NULL DEFAULT 4,
  `failed` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `uuid_status` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `create_a_copy` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `import_priority` int(11) unsigned NOT NULL DEFAULT 0,
  `assign_parent_user` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `mail_smtp` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_smtp` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username_smtp` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_smtp` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_pswd_smtp` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `auth_method` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `reopen_reset` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `last_process_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lhc_mailconv_mailing_campaign`;
CREATE TABLE `lhc_mailconv_mailing_campaign` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `starts_at` bigint(20) unsigned NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `mailbox_id` bigint(20) unsigned NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `body_alt` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `as_active` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `reply_email` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reply_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_logic` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `owner_user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `status_enabled_starts_at` (`status`,`enabled`,`starts_at`),
  KEY `enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_mailing_campaign_recipient`;
CREATE TABLE `lhc_mailconv_mailing_campaign_recipient` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `campaign_id` bigint(20) unsigned NOT NULL,
  `recipient_id` bigint(20) unsigned NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailbox` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 0,
  `opened_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `send_at` bigint(20) unsigned NOT NULL,
  `message_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conversation_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_1` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_2` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_3` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_4` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_5` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_6` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `log` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`),
  KEY `campaign_id_status` (`campaign_id`,`status`),
  KEY `campaign_id_email` (`campaign_id`,`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_mailing_list`;
CREATE TABLE `lhc_mailconv_mailing_list` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_mailing_list_recipient`;
CREATE TABLE `lhc_mailconv_mailing_list_recipient` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mailing_list_id` bigint(20) unsigned NOT NULL,
  `mailing_recipient_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `mailing_list_id` (`mailing_list_id`),
  KEY `mailing_recipient_id` (`mailing_recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_match_rule`;
CREATE TABLE `lhc_mailconv_match_rule` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) unsigned NOT NULL,
  `conditions` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT 1,
  `mailbox_id` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_name` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_mail` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_contains` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int(11) NOT NULL,
  `priority_rule` int(11) NOT NULL,
  `options` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active_priority` (`active`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_msg`;
CREATE TABLE `lhc_mailconv_msg` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT 0,
  `is_external` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `message_hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) unsigned NOT NULL,
  `opened_at` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conversation_id_old` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conversation_id` bigint(20) unsigned NOT NULL,
  `lang` varchar(5) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_id` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `in_reply_to` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `alt_body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `references` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) unsigned NOT NULL,
  `udate` int(11) unsigned NOT NULL,
  `date` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `flagged` int(11) unsigned NOT NULL,
  `recent` int(11) unsigned NOT NULL,
  `msgno` bigint(20) unsigned NOT NULL,
  `uid` bigint(20) unsigned NOT NULL,
  `size` int(11) unsigned NOT NULL,
  `from_host` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_address` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_host` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sender_address` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `to_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `reply_to_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `mailbox_id` bigint(20) unsigned NOT NULL,
  `response_time` bigint(20) unsigned NOT NULL,
  `cls_time` bigint(20) unsigned NOT NULL,
  `wait_time` bigint(20) unsigned NOT NULL,
  `accept_time` bigint(20) unsigned NOT NULL,
  `interaction_time` bigint(20) NOT NULL,
  `conv_user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) unsigned NOT NULL,
  `lr_time` bigint(20) unsigned NOT NULL,
  `response_type` int(11) unsigned NOT NULL,
  `bcc_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `cc_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) unsigned NOT NULL,
  `mb_folder` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `conv_duration` int(11) NOT NULL DEFAULT 0,
  `has_attachment` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `undelivered` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `rfc822_body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `delivery_status` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`),
  KEY `response_type` (`response_type`),
  KEY `user_id` (`user_id`),
  KEY `conversation_id_old` (`conversation_id_old`),
  KEY `conversation_id` (`conversation_id`),
  KEY `mailbox_id` (`mailbox_id`),
  KEY `dep_id` (`dep_id`),
  KEY `message_hash` (`message_hash`),
  KEY `lang` (`lang`),
  KEY `has_attachment` (`has_attachment`),
  KEY `udate` (`udate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_msg_internal`;
CREATE TABLE `lhc_mailconv_msg_internal` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` bigint(20) unsigned NOT NULL,
  `chat_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `user_id` bigint(20) NOT NULL DEFAULT 0,
  `name_support` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id_id` (`chat_id`,`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_msg_open`;
CREATE TABLE `lhc_mailconv_msg_open` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `opened_at` bigint(20) unsigned NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_msg_subject`;
CREATE TABLE `lhc_mailconv_msg_subject` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `subject_id` int(11) unsigned NOT NULL,
  `message_id` bigint(20) unsigned NOT NULL,
  `conversation_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message_id` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_oauth_ms`;
CREATE TABLE `lhc_mailconv_oauth_ms` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mailbox_id` bigint(20) unsigned NOT NULL,
  `oauth_uid` varchar(50) NOT NULL,
  `name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `surname` varchar(200) NOT NULL,
  `display_name` varchar(200) NOT NULL,
  `txtSessionKey` varchar(255) NOT NULL,
  `txtCodeVerifier` varchar(255) NOT NULL,
  `dtExpires` bigint(20) unsigned NOT NULL,
  `txtRefreshToken` text NOT NULL,
  `txtToken` text NOT NULL,
  `txtIDToken` text NOT NULL,
  `completed` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth_uid` (`oauth_uid`),
  KEY `user_id_completed` (`mailbox_id`,`completed`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


DROP TABLE IF EXISTS `lhc_mailconv_personal_mailbox_group`;
CREATE TABLE `lhc_mailconv_personal_mailbox_group` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mails` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_recipient`;
CREATE TABLE `lhc_mailconv_recipient` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  `mailbox` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_1` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_2` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_3` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_4` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_5` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_6` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`),
  KEY `disabled` (`disabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_remarks`;
CREATE TABLE `lhc_mailconv_remarks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_response_template`;
CREATE TABLE `lhc_mailconv_response_template` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `template` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) NOT NULL DEFAULT 0,
  `template_plain` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `unique_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `unique_id` (`unique_id`),
  KEY `disabled` (`disabled`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_response_template_dep`;
CREATE TABLE `lhc_mailconv_response_template_dep` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` bigint(20) NOT NULL,
  `dep_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `template_id` (`template_id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_response_template_subject`;
CREATE TABLE `lhc_mailconv_response_template_subject` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` bigint(20) unsigned NOT NULL,
  `subject_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `template_id` (`template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lhc_mailconv_sent_copy`;
CREATE TABLE `lhc_mailconv_sent_copy` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `mailbox_id` bigint(20) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `body` longblob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_auto_responder`;
CREATE TABLE `lh_abstract_auto_responder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteaccess` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `timeout_message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_configuration` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `only_proactive` int(11) NOT NULL,
  `repeat_number` int(11) NOT NULL DEFAULT 1,
  `survey_timeout` int(11) NOT NULL DEFAULT 0,
  `survey_id` int(11) NOT NULL DEFAULT 0,
  `wait_timeout_hold_1` int(11) NOT NULL,
  `wait_timeout_hold_2` int(11) NOT NULL,
  `wait_timeout_hold_3` int(11) NOT NULL,
  `wait_timeout_hold_4` int(11) NOT NULL,
  `wait_timeout_hold_5` int(11) NOT NULL,
  `timeout_hold_message_1` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeout_hold_message_2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeout_hold_message_3` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeout_hold_message_4` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeout_hold_message_5` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_hold` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_2` int(11) NOT NULL,
  `timeout_message_2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_3` int(11) NOT NULL,
  `timeout_message_3` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_4` int(11) NOT NULL,
  `timeout_message_4` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_5` int(11) NOT NULL,
  `timeout_message_5` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_reply_1` int(11) NOT NULL,
  `timeout_reply_message_1` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_reply_2` int(11) NOT NULL,
  `timeout_reply_message_2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_reply_3` int(11) NOT NULL,
  `timeout_reply_message_3` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_reply_4` int(11) NOT NULL,
  `timeout_reply_message_4` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `wait_timeout_reply_5` int(11) NOT NULL,
  `timeout_reply_message_5` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `languages` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ignore_pa_chat` int(11) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `siteaccess_position` (`siteaccess`,`position`),
  KEY `disabled` (`disabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_auto_responder_chat`;
CREATE TABLE `lh_abstract_auto_responder_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `auto_responder_id` int(11) NOT NULL,
  `wait_timeout_send` int(11) NOT NULL,
  `pending_send_status` int(11) NOT NULL,
  `active_send_status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_auto_responder_dep`;
CREATE TABLE `lh_abstract_auto_responder_dep` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `autoresponder_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `autoresponder_id` (`autoresponder_id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_browse_offer_invitation`;
CREATE TABLE `lh_abstract_browse_offer_invitation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteaccess` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_on_site` int(11) NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `callback_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `lhc_iframe_content` tinyint(4) NOT NULL,
  `custom_iframe_url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_times` int(11) NOT NULL,
  `url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` int(11) NOT NULL,
  `has_url` int(11) NOT NULL,
  `is_wildcard` int(11) NOT NULL,
  `referrer` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `unit` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active` (`active`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_chat_alert_icon`;
CREATE TABLE `lh_abstract_chat_alert_icon` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_chat_column`;
CREATE TABLE `lh_abstract_chat_column` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `column_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variable` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int(11) NOT NULL,
  `enabled` tinyint(1) NOT NULL,
  `online_enabled` tinyint(1) NOT NULL,
  `chat_enabled` tinyint(1) NOT NULL,
  `conditions` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `column_icon` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `column_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_mode` tinyint(1) NOT NULL DEFAULT 0,
  `has_popup` tinyint(1) NOT NULL DEFAULT 0,
  `chat_window_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `popup_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_column` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sort_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `chat_list_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `mail_list_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `mail_enabled` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `enabled` (`enabled`),
  KEY `online_enabled` (`online_enabled`),
  KEY `chat_enabled` (`chat_enabled`),
  KEY `chat_window_enabled` (`chat_window_enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_chat_priority`;
CREATE TABLE `lh_abstract_chat_priority` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) NOT NULL,
  `dest_dep_id` int(11) NOT NULL DEFAULT 0,
  `sort_priority` int(11) NOT NULL DEFAULT 0,
  `priority` int(11) NOT NULL,
  `skip_bot` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `role_destination` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `present_role_is` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_chat_variable`;
CREATE TABLE `lh_abstract_chat_variable` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `var_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `var_identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `inv` tinyint(1) NOT NULL,
  `change_message` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint(1) NOT NULL,
  `persistent` tinyint(1) NOT NULL,
  `js_variable` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) NOT NULL,
  `try_decrypt` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `case_insensitive` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `old_js_id` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content_field` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_email_template`;
CREATE TABLE `lh_abstract_email_template` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_name_ac` tinyint(4) NOT NULL,
  `from_email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `from_email_ac` tinyint(4) NOT NULL,
  `user_mail_as_sender` tinyint(4) NOT NULL,
  `use_chat_locale` tinyint(1) NOT NULL DEFAULT 0,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `translations` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bcc_recipients` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject_ac` tinyint(4) NOT NULL,
  `reply_to` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reply_to_ac` tinyint(4) NOT NULL,
  `recipient` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `only_recipient` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_abstract_email_template` (`id`, `name`, `from_name`, `from_name_ac`, `from_email`, `from_email_ac`, `user_mail_as_sender`, `use_chat_locale`, `content`, `translations`, `subject`, `bcc_recipients`, `subject_ac`, `reply_to`, `reply_to_ac`, `recipient`, `only_recipient`) VALUES
(1,	'Send mail to user',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Dear {user_chat_nick},\r\n\r\n{additional_message}\r\n\r\nLive Support response:\r\n{messages_content}\r\n\r\nSincerely,\r\nLive Support Team\r\n',	'',	'{name_surname} has responded to your request',	'',	1,	'',	1,	'',	0),
(2,	'Support request from user',	'',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nUser request data:\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\n\r\nMessage:\r\n{message}\r\n\r\nAdditional data, if any:\r\n{additional_data}\r\n\r\nURL of page from which user has send request:\r\n{url_request}\r\n\r\nLink to chat if any:\r\n{prefillchat}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'{name}, {country}, {department}, Support request from user',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(3,	'User mail for himself',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Dear {user_chat_nick},\r\n\r\nTranscript:\r\n{messages_content}\r\nChat ID: {chat_id}\n\r\nSincerely,\r\nLive Support Team\r\n',	'',	'Chat transcript',	'',	0,	'',	0,	'',	0),
(4,	'New chat request',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nUser request data:\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\nCreated:	{created}\r\nUser left:	{user_left}\r\nWaited:	{waited}\r\nChat duration:	{chat_duration}\r\n\r\nMessage:\r\n{message}\r\n\r\nURL of page from which user has send request:\r\n{url_request}\r\n\r\nClick to accept chat automatically\r\n{url_accept}\r\n\r\nSurvey\r\n{survey}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'New chat request',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(5,	'Chat was closed',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\n{operator} has closed a chat\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\nCreated:	{created}\r\nUser left:	{user_left}\r\nWaited:	{waited}\r\nChat duration:	{chat_duration}\r\n\r\nMessage:\r\n{message}\r\n\r\nAdditional data, if any:\r\n{additional_data}\r\n\r\nURL of page from which user has send request:\r\n{url_request}\r\n\r\nSurvey:\r\n{survey}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Chat was closed',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(6,	'New FAQ question',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nNew FAQ question\r\nEmail: {email}\r\n\r\nQuestion:\r\n{question}\r\n\r\nQuestion URL:\r\n{url_question}\r\n\r\nURL to answer a question:\r\n{url_request}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'New FAQ question',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(7,	'New unread message',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nUser request data:\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\nCreated:	{created}\r\nUser left:	{user_left}\r\nWaited:	{waited}\r\nChat duration:	{chat_duration}\r\n\r\nMessage:\r\n{message}\r\n\r\nURL of page from which user has send request:\r\n{url_request}\r\n\r\nClick to accept chat automatically\r\n{url_accept}\r\n\r\nSurvey:\r\n{survey}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'New unread message',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(8,	'Filled form',	'MCFC',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nUser has filled a form\r\nForm name - {form_name}\r\nUser IP - {ip}\r\nDownload filled data - {url_download}\r\nView filled data - {url_view}\r\n\r\n{content}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Filled form - {form_name}',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(9,	'Chat was accepted',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nOperator {user_name} has accepted a chat [{chat_id}]\r\n\r\nUser request data:\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\nCreated:	{created}\r\nUser left:	{user_left}\r\nWaited:	{waited}\r\nChat duration:	{chat_duration}\r\n\r\nMessage:\r\n{message}\r\n\r\nURL of page from which user has send request:\r\n{url_request}\r\n\r\nClick to accept chat automatically\r\n{url_accept}\r\n\r\nSurvey:\r\n{survey}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Chat was accepted [{chat_id}]',	'',	0,	'',	0,	'remdex@gmail.com',	0),
(10,	'Permission request',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nOperator {user} has requested these permissions\n\r\n{permissions}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Permission request from {user}',	'',	0,	'',	0,	'',	0),
(11,	'You have unread messages',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nOperator {operator} has answered to you\r\n\r\n{messages}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Operator has answered to your request',	'',	0,	'',	0,	'',	0),
(12,	'Visitor returned',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nVisitor information\r\nName: {name}\r\nEmail: {email}\r\nPhone: {phone}\r\nDepartment: {department}\r\nCountry: {country}\r\nCity: {city}\r\nIP: {ip}\r\nCreated:	{created}\r\nUser left:	{user_left}\r\nWaited:	{waited}\r\nChat duration:	{chat_duration}\r\n\r\nSee more information at\r\n{url_accept}\r\n\r\nLast chat:\r\n{message}\r\n\r\nAdditional data, if any:\r\n{additional_data}\r\n\r\nSincerely,\r\nLive Support Team',	'',	'Visitor returned - {username}',	'',	0,	'',	0,	'',	0),
(13,	'Report prepared',	'Live Helper Chat',	0,	'',	0,	0,	0,	'Hello,\r\n\r\nReport prepared - {report_name}, {date_range}\r\n\r\n{report_description}\r\n\r\nView report at:\r\n{url_report}\r\nView directly: {url_report_direct}',	'',	'Report prepared - {report_name}',	'',	0,	'',	0,	'',	0);

DROP TABLE IF EXISTS `lh_abstract_form`;
CREATE TABLE `lh_abstract_form` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `recipient` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` int(11) NOT NULL,
  `name_attr` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `intro_attr` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xls_columns` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pagelayout` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `post_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_form_collected`;
CREATE TABLE `lh_abstract_form_collected` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `form_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `ip` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_fields` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `form_id` (`form_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_msg_protection`;
CREATE TABLE `lh_abstract_msg_protection` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `pattern` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `enabled` int(11) NOT NULL DEFAULT 1,
  `remove` int(11) NOT NULL DEFAULT 0,
  `v_warning` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `enabled` (`enabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_campaign`;
CREATE TABLE `lh_abstract_proactive_chat_campaign` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_campaign_conv`;
CREATE TABLE `lh_abstract_proactive_chat_campaign_conv` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_type` tinyint(11) NOT NULL,
  `invitation_type` tinyint(1) NOT NULL,
  `invitation_status` tinyint(1) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `invitation_id` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `con_time` int(11) NOT NULL,
  `vid_id` bigint(20) DEFAULT NULL,
  `variation_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conv_int_expires` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conv_int_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  `conv_event` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unique_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ctime` (`ctime`),
  KEY `campaign_id` (`campaign_id`),
  KEY `invitation_status` (`invitation_status`),
  KEY `invitation_id_variation_id` (`invitation_id`,`variation_id`),
  KEY `conv_event_vid_id` (`conv_event`,`vid_id`),
  KEY `unique_id` (`unique_id`),
  KEY `conv_int_time` (`conv_int_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_event`;
CREATE TABLE `lh_abstract_proactive_chat_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vid_id` int(11) NOT NULL,
  `ev_id` int(11) NOT NULL,
  `ts` int(11) NOT NULL,
  `val` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vid_id_ev_id_val_ts` (`vid_id`,`ev_id`,`val`,`ts`),
  KEY `vid_id_ev_id_ts` (`vid_id`,`ev_id`,`ts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_invitation`;
CREATE TABLE `lh_abstract_proactive_chat_invitation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `siteaccess` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_on_site` int(11) NOT NULL,
  `pageviews` int(11) NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_returning` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `executed_times` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `hide_after_ntimes` int(11) NOT NULL,
  `show_on_mobile` int(11) NOT NULL,
  `delay` int(11) NOT NULL,
  `delay_init` int(11) NOT NULL,
  `show_instant` int(11) NOT NULL,
  `autoresponder_id` int(11) NOT NULL,
  `disabled` int(11) NOT NULL,
  `inject_only_html` tinyint(1) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_ids` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message_returning_nick` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referrer` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `show_random_operator` int(11) NOT NULL,
  `operator_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `campaign_id` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  `event_invitation` int(11) NOT NULL,
  `dynamic_invitation` int(11) NOT NULL,
  `bot_id` int(11) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  `bot_offline` tinyint(1) NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tag` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `requires_email` int(11) NOT NULL,
  `iddle_for` int(11) NOT NULL,
  `event_type` int(11) NOT NULL,
  `requires_username` int(11) NOT NULL,
  `requires_phone` int(11) NOT NULL,
  `design_data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `active_from` bigint(20) unsigned NOT NULL DEFAULT 0,
  `active_to` bigint(20) unsigned NOT NULL DEFAULT 0,
  `repetitiveness` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `days_activity` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url_present` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `time_on_site_pageviews_siteaccess_position` (`time_on_site`,`pageviews`,`siteaccess`,`identifier`,`position`),
  KEY `identifier` (`identifier`),
  KEY `dynamic_invitation` (`dynamic_invitation`),
  KEY `tag` (`tag`),
  KEY `show_on_mobile` (`show_on_mobile`),
  KEY `dep_id` (`dep_id`),
  KEY `parent_id` (`parent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_invitation_dep`;
CREATE TABLE `lh_abstract_proactive_chat_invitation_dep` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `invitation_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invitation_id` (`invitation_id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_invitation_event`;
CREATE TABLE `lh_abstract_proactive_chat_invitation_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invitation_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `min_number` int(11) NOT NULL,
  `during_seconds` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `invitation_id` (`invitation_id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_proactive_chat_variables`;
CREATE TABLE `lh_abstract_proactive_chat_variables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `store_timeout` int(11) NOT NULL,
  `filter_val` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_product`;
CREATE TABLE `lh_abstract_product` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `departament_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `departament_id` (`departament_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_product_departament`;
CREATE TABLE `lh_abstract_product_departament` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `departament_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `departament_id` (`departament_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_rest_api_key`;
CREATE TABLE `lh_abstract_rest_api_key` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `active` int(11) NOT NULL DEFAULT 0,
  `ip_restrictions` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `api_key` (`api_key`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_rest_api_key_remote`;
CREATE TABLE `lh_abstract_rest_api_key_remote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `api_key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `host` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 0,
  `position` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_saved_report`;
CREATE TABLE `lh_abstract_saved_report` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `params` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `send_log` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `recurring_options` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `position` int(11) unsigned NOT NULL,
  `days` int(11) unsigned NOT NULL,
  `date_type` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `days_end` int(11) unsigned NOT NULL,
  `updated_at` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_saved_search`;
CREATE TABLE `lh_abstract_saved_search` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `params` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `position` int(11) unsigned NOT NULL,
  `scope` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `days` int(11) unsigned NOT NULL,
  `updated_at` bigint(20) unsigned NOT NULL,
  `requested_at` bigint(20) unsigned NOT NULL,
  `total_records` bigint(20) unsigned NOT NULL,
  `passive` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `sharer_user_id` bigint(20) unsigned NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `scope` (`scope`),
  KEY `updated_at` (`updated_at`),
  KEY `requested_at` (`requested_at`),
  KEY `user_id_status` (`user_id`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_stats`;
CREATE TABLE `lh_abstract_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `lupdate` bigint(20) NOT NULL,
  `object_id` bigint(20) NOT NULL,
  `stats` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `type_object_id` (`type`,`object_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_subject`;
CREATE TABLE `lh_abstract_subject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `internal` tinyint(1) NOT NULL DEFAULT 0,
  `internal_type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  `color` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pinned` tinyint(1) NOT NULL DEFAULT 0,
  `widgets` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `internal` (`internal`),
  KEY `internal_type` (`internal_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_subject_chat`;
CREATE TABLE `lh_abstract_subject_chat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subject_id` int(11) NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_subject_dep`;
CREATE TABLE `lh_abstract_subject_dep` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subject_id` (`subject_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_survey`;
CREATE TABLE `lh_abstract_survey` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `feedback_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_1_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_1_pos` int(11) NOT NULL,
  `max_stars_2_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_2_pos` int(11) NOT NULL,
  `max_stars_2` int(11) NOT NULL,
  `max_stars_3_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_3_pos` int(11) NOT NULL,
  `max_stars_3` int(11) NOT NULL,
  `max_stars_4_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_4_pos` int(11) NOT NULL,
  `max_stars_4` int(11) NOT NULL,
  `max_stars_5_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `max_stars_5_pos` int(11) NOT NULL,
  `max_stars_5` int(11) NOT NULL,
  `question_options_1` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_1_items` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_1_pos` int(11) NOT NULL,
  `question_options_2` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_2_items` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_2_pos` int(11) NOT NULL,
  `question_options_3` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_3_items` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_3_pos` int(11) NOT NULL,
  `question_options_4` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_4_items` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_4_pos` int(11) NOT NULL,
  `question_options_5` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_5_items` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_options_5_pos` int(11) NOT NULL,
  `question_plain_1` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_1_pos` int(11) NOT NULL,
  `question_plain_2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_2_pos` int(11) NOT NULL,
  `question_plain_3` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_3_pos` int(11) NOT NULL,
  `question_plain_4` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_4_pos` int(11) NOT NULL,
  `question_plain_5` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_5_pos` int(11) NOT NULL,
  `max_stars_1_enabled` int(11) NOT NULL,
  `max_stars_2_enabled` int(11) NOT NULL,
  `max_stars_3_enabled` int(11) NOT NULL,
  `max_stars_4_enabled` int(11) NOT NULL,
  `max_stars_5_enabled` int(11) NOT NULL,
  `question_options_1_enabled` int(11) NOT NULL,
  `question_options_2_enabled` int(11) NOT NULL,
  `question_options_3_enabled` int(11) NOT NULL,
  `question_options_4_enabled` int(11) NOT NULL,
  `question_options_5_enabled` int(11) NOT NULL,
  `question_plain_1_enabled` int(11) NOT NULL,
  `question_plain_2_enabled` int(11) NOT NULL,
  `question_plain_3_enabled` int(11) NOT NULL,
  `question_plain_4_enabled` int(11) NOT NULL,
  `question_plain_5_enabled` int(11) NOT NULL,
  `max_stars_1` int(11) NOT NULL,
  `max_stars_1_req` int(11) NOT NULL,
  `max_stars_2_req` int(11) NOT NULL,
  `max_stars_3_req` int(11) NOT NULL,
  `max_stars_4_req` int(11) NOT NULL,
  `max_stars_5_req` int(11) NOT NULL,
  `question_options_1_req` int(11) NOT NULL,
  `question_options_2_req` int(11) NOT NULL,
  `question_options_3_req` int(11) NOT NULL,
  `question_options_4_req` int(11) NOT NULL,
  `question_options_5_req` int(11) NOT NULL,
  `question_plain_1_req` int(11) NOT NULL,
  `question_plain_2_req` int(11) NOT NULL,
  `question_plain_3_req` int(11) NOT NULL,
  `question_plain_4_req` int(11) NOT NULL,
  `question_plain_5_req` int(11) NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_survey_item`;
CREATE TABLE `lh_abstract_survey_item` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `ftime` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `max_stars_1` int(11) NOT NULL,
  `max_stars_2` int(11) NOT NULL,
  `max_stars_3` int(11) NOT NULL,
  `max_stars_4` int(11) NOT NULL,
  `max_stars_5` int(11) NOT NULL,
  `question_options_1` int(11) NOT NULL,
  `question_options_2` int(11) NOT NULL,
  `question_options_3` int(11) NOT NULL,
  `question_options_4` int(11) NOT NULL,
  `question_options_5` int(11) NOT NULL,
  `question_plain_1` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_2` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_3` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_4` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_plain_5` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_user_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  KEY `chat_id` (`chat_id`),
  KEY `user_id` (`user_id`),
  KEY `dep_id` (`dep_id`),
  KEY `ftime` (`ftime`),
  KEY `max_stars_1` (`max_stars_1`),
  KEY `max_stars_2` (`max_stars_2`),
  KEY `max_stars_3` (`max_stars_3`),
  KEY `max_stars_4` (`max_stars_4`),
  KEY `max_stars_5` (`max_stars_5`),
  KEY `question_options_1` (`question_options_1`),
  KEY `question_options_2` (`question_options_2`),
  KEY `question_options_3` (`question_options_3`),
  KEY `question_options_4` (`question_options_4`),
  KEY `question_options_5` (`question_options_5`),
  KEY `online_user_id` (`online_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_abstract_widget_theme`;
CREATE TABLE `lh_abstract_widget_theme` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_company` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `onl_bcolor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bor_bcolor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'e3e3e3',
  `text_color` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `offline_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `offline_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `logo_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `header_background` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_tcolor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_bcolor` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_border` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_close_bg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_hover_bg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_close_hover_bg` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_status_css` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_container_css` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_widget_css` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_header` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `need_help_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `offline_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `widget_border_color` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `copyright_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `copyright_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `widget_copyright_url` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `show_copyright` int(11) NOT NULL DEFAULT 1,
  `explain_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `intro_operator_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `minimize_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `minimize_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `restore_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `restore_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `close_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `close_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `popup_image` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `popup_image_path` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hide_close` int(11) NOT NULL DEFAULT 0,
  `hide_popup` int(11) NOT NULL DEFAULT 0,
  `header_height` int(11) NOT NULL DEFAULT 0,
  `header_padding` int(11) NOT NULL DEFAULT 0,
  `widget_border_width` int(11) NOT NULL DEFAULT 0,
  `support_joined` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `support_closed` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pending_join` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `noonline_operators` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `noonline_operators_offline` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `show_need_help` int(11) NOT NULL DEFAULT 1,
  `show_need_help_timeout` int(11) NOT NULL DEFAULT 24,
  `show_voting` tinyint(1) NOT NULL DEFAULT 1,
  `department_title` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_select` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_visitor_background` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_visitor_title_color` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_visitor_text_color` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_operator_background` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_operator_title_color` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `buble_operator_text_color` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `custom_popup_css` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `hide_ts` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `widget_response_width` int(11) NOT NULL DEFAULT 0,
  `show_need_help_delay` int(11) NOT NULL DEFAULT 0,
  `show_status_delay` int(11) NOT NULL DEFAULT 0,
  `modern_look` tinyint(1) NOT NULL DEFAULT 0,
  `bot_status_text` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `notification_configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `pending_join_queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `modified` int(11) NOT NULL,
  `widget_show_leave_form` tinyint(1) NOT NULL,
  `enable_widget_embed_override` tinyint(1) NOT NULL,
  `widget_popheight` int(11) NOT NULL,
  `widget_popwidth` int(11) NOT NULL,
  `widget_survey` int(11) NOT NULL,
  `widget_position` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `widget_pright` int(11) NOT NULL,
  `widget_pbottom` int(11) NOT NULL,
  `alias` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hide_op_ts` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `alias` (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_admin_theme`;
CREATE TABLE `lh_admin_theme` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `static_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `static_js_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `static_css_content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `css_attributes` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `header_content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `header_css` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_audits`;
CREATE TABLE `lh_audits` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `object_id` bigint(20) DEFAULT 0,
  `line` bigint(20) DEFAULT NULL,
  `message` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `severity` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `source` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_id` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `object_id` (`object_id`),
  KEY `source` (`source`(191)),
  KEY `category` (`category`(191)),
  KEY `time` (`time`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `lh_bot_condition`;
CREATE TABLE `lh_bot_condition` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_brand`;
CREATE TABLE `lh_brand` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_brand_member`;
CREATE TABLE `lh_brand_member` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dep_id` bigint(20) unsigned NOT NULL,
  `brand_id` bigint(20) unsigned NOT NULL,
  `role` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`),
  KEY `brand_id_role` (`brand_id`,`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg`;
CREATE TABLE `lh_canned_msg` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `fallback_msg` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `explain` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `languages` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `additional_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int(11) NOT NULL,
  `department_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `delay` int(11) NOT NULL,
  `auto_send` tinyint(1) NOT NULL,
  `html_snippet` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_int_1` int(11) NOT NULL,
  `attr_int_2` int(11) NOT NULL,
  `attr_int_3` int(11) NOT NULL,
  `disabled` tinyint(1) unsigned DEFAULT 0,
  `unique_id` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `updated_at` int(11) unsigned NOT NULL DEFAULT 0,
  `created_at` int(11) unsigned NOT NULL DEFAULT 0,
  `active_from` int(11) unsigned NOT NULL DEFAULT 0,
  `active_to` int(11) unsigned NOT NULL DEFAULT 0,
  `repetitiveness` int(11) unsigned NOT NULL DEFAULT 0,
  `days_activity` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `delete_on_exp` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`),
  KEY `disabled` (`disabled`),
  KEY `attr_int_1` (`attr_int_1`),
  KEY `attr_int_2` (`attr_int_2`),
  KEY `attr_int_3` (`attr_int_3`),
  KEY `position_title_v2` (`position`,`title`(191)),
  KEY `user_id` (`user_id`),
  KEY `unique_id` (`unique_id`),
  KEY `repetitiveness` (`repetitiveness`),
  KEY `delete_on_exp` (`delete_on_exp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_dep`;
CREATE TABLE `lh_canned_msg_dep` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `canned_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `canned_id` (`canned_id`),
  KEY `dep_id` (`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_replace`;
CREATE TABLE `lh_canned_msg_replace` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `default` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `conditions` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `active_from` int(11) unsigned NOT NULL DEFAULT 0,
  `active_to` int(11) unsigned NOT NULL DEFAULT 0,
  `repetitiveness` int(11) unsigned NOT NULL DEFAULT 0,
  `days_activity` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_zone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_subject`;
CREATE TABLE `lh_canned_msg_subject` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `canned_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `canned_id` (`canned_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_tag`;
CREATE TABLE `lh_canned_msg_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tag` (`tag`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_tag_link`;
CREATE TABLE `lh_canned_msg_tag_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL,
  `canned_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `canned_id` (`canned_id`),
  KEY `tag_id` (`tag_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_canned_msg_use`;
CREATE TABLE `lh_canned_msg_use` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `canned_id` int(11) unsigned NOT NULL,
  `chat_id` bigint(20) unsigned NOT NULL,
  `ctime` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ctime` (`ctime`),
  KEY `chat_id` (`chat_id`),
  KEY `canned_id` (`canned_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat`;
CREATE TABLE `lh_chat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `nick` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `status_sub` int(11) NOT NULL DEFAULT 0,
  `status_sub_sub` int(11) NOT NULL DEFAULT 0,
  `time` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referrer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_referrer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_variables` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `remarks` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_id` int(11) NOT NULL,
  `invitation_id` int(11) NOT NULL,
  `sender_user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `pnd_time` int(11) NOT NULL DEFAULT 0,
  `cls_time` int(11) NOT NULL DEFAULT 0,
  `usaccept` int(11) NOT NULL DEFAULT 0,
  `user_status` int(11) NOT NULL DEFAULT 0,
  `user_closed_ts` int(11) NOT NULL DEFAULT 0,
  `support_informed` int(11) NOT NULL DEFAULT 0,
  `unread_messages_informed` int(11) NOT NULL DEFAULT 0,
  `reinform_timeout` int(11) NOT NULL DEFAULT 0,
  `last_op_msg_time` int(11) NOT NULL DEFAULT 0,
  `has_unread_op_messages` int(11) NOT NULL DEFAULT 0,
  `unread_op_messages_informed` int(11) NOT NULL DEFAULT 0,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `country_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `unanswered_chat` int(11) NOT NULL,
  `cls_us` tinyint(1) NOT NULL DEFAULT 0,
  `anonymized` tinyint(1) NOT NULL,
  `user_typing` int(11) NOT NULL,
  `gbot_id` int(11) NOT NULL DEFAULT 0,
  `user_typing_txt` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_typing` int(11) NOT NULL,
  `operator_typing_id` int(11) NOT NULL,
  `phone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_unread_messages` int(11) NOT NULL,
  `last_user_msg_time` int(11) NOT NULL,
  `fbst` tinyint(1) NOT NULL,
  `online_user_id` int(11) NOT NULL,
  `auto_responder_id` int(11) NOT NULL,
  `last_msg_id` int(11) NOT NULL,
  `lsync` int(11) NOT NULL,
  `transfer_uid` int(11) NOT NULL,
  `additional_data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_tz_identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lat` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lon` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation_admin` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_sub_arg` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uagent` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_locale` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_locale_to` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mail_send` int(11) NOT NULL,
  `screenshot_id` int(11) NOT NULL,
  `wait_time` int(11) NOT NULL,
  `chat_duration` int(11) NOT NULL,
  `tslasign` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `chat_initiator` int(11) NOT NULL,
  `transfer_timeout_ts` int(11) NOT NULL,
  `transfer_timeout_ac` int(11) NOT NULL,
  `transfer_if_na` int(11) NOT NULL,
  `na_cb_executed` int(11) NOT NULL,
  `device_type` int(11) NOT NULL,
  `nc_cb_executed` tinyint(1) NOT NULL,
  `iwh_id` int(11) NOT NULL DEFAULT 0,
  `theme_id` int(11) unsigned NOT NULL DEFAULT 0,
  `frt` int(11) unsigned NOT NULL DEFAULT 0,
  `aart` int(11) unsigned NOT NULL DEFAULT 0,
  `mart` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `status_user_id` (`status`,`user_id`),
  KEY `unanswered_chat` (`unanswered_chat`),
  KEY `online_user_id` (`online_user_id`),
  KEY `dep_id` (`dep_id`),
  KEY `product_id` (`product_id`),
  KEY `unread_operator` (`has_unread_op_messages`,`unread_op_messages_informed`),
  KEY `user_id_sender_user_id` (`user_id`,`sender_user_id`),
  KEY `sender_user_id` (`sender_user_id`),
  KEY `anonymized` (`anonymized`),
  KEY `has_unread_messages` (`has_unread_messages`),
  KEY `status` (`status`),
  KEY `dep_id_status` (`dep_id`,`status`),
  KEY `nick` (`nick`),
  KEY `time` (`time`),
  KEY `iwh_id` (`iwh_id`),
  KEY `theme_id` (`theme_id`),
  KEY `email` (`email`),
  KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_chat` (`id`, `nick`, `status`, `status_sub`, `status_sub_sub`, `time`, `user_id`, `hash`, `referrer`, `session_referrer`, `chat_variables`, `remarks`, `ip`, `dep_id`, `invitation_id`, `sender_user_id`, `product_id`, `pnd_time`, `cls_time`, `usaccept`, `user_status`, `user_closed_ts`, `support_informed`, `unread_messages_informed`, `reinform_timeout`, `last_op_msg_time`, `has_unread_op_messages`, `unread_op_messages_informed`, `email`, `country_code`, `country_name`, `unanswered_chat`, `cls_us`, `anonymized`, `user_typing`, `gbot_id`, `user_typing_txt`, `operator_typing`, `operator_typing_id`, `phone`, `has_unread_messages`, `last_user_msg_time`, `fbst`, `online_user_id`, `auto_responder_id`, `last_msg_id`, `lsync`, `transfer_uid`, `additional_data`, `user_tz_identifier`, `lat`, `lon`, `city`, `operation`, `operation_admin`, `status_sub_arg`, `uagent`, `chat_locale`, `chat_locale_to`, `mail_send`, `screenshot_id`, `wait_time`, `chat_duration`, `tslasign`, `priority`, `chat_initiator`, `transfer_timeout_ts`, `transfer_timeout_ac`, `transfer_if_na`, `na_cb_executed`, `device_type`, `nc_cb_executed`, `iwh_id`, `theme_id`, `frt`, `aart`, `mart`) VALUES
(3,	'Visitor',	1,	1,	0,	1761559888,	1,	'oCZAp47ROpAGfkI7lChgb78byFWiE0DytQf3KrCn',	'//example.com/chat/start',	'',	'',	'',	'192.168.1.1',	1,	0,	0,	0,	1761559888,	0,	0,	2,	1761559955,	1,	0,	0,	1761562915,	1,	0,	'',	'',	'',	1,	0,	0,	1761559950,	0,	'Visitor has left the chat!',	0,	0,	'',	0,	0,	0,	32,	0,	13,	1761559952,	0,	'',	'Europe/Vilnius',	'0',	'0',	'',	'',	'',	'',	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',	'en-US',	'',	0,	0,	3015,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0),
(4,	'Visitor',	1,	0,	0,	1761562893,	1,	'QtoE2rOD61YuI4BwXg9noJBNNefgE1XRJ1lMg8PR',	'/example.com/testpages/lara.html',	'',	'',	'',	'192.168.1.1',	1,	0,	0,	0,	1761562893,	0,	0,	2,	1761566220,	1,	0,	0,	1761573630,	1,	0,	'',	'',	'',	0,	0,	0,	1761566215,	0,	'Visitor has left the chat!',	0,	0,	'',	0,	1761562907,	0,	34,	0,	14,	1761566184,	0,	'',	'Europe/Vilnius',	'0',	'0',	'',	'',	'',	'',	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',	'en-US',	'',	0,	0,	5,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0),
(5,	'Visitor',	1,	0,	0,	1761576417,	1,	'0xavgm5Z67qjEfUjInV1j72eTn0mzIIwANk05bhs',	'//example.com/testpages/lara.html',	'',	'',	'',	'192.168.1.1',	1,	0,	0,	0,	1761576417,	0,	0,	0,	1761576559,	1,	0,	0,	1761576423,	0,	0,	'',	'',	'',	0,	0,	0,	1761576559,	0,	'//example.com',	0,	0,	'',	0,	0,	0,	34,	0,	17,	1761584063,	0,	'',	'Europe/Vilnius',	'0',	'0',	'',	'',	'',	'',	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',	'en-US',	'',	0,	0,	4,	0,	0,	0,	0,	0,	0,	0,	0,	0,	1,	0,	0,	0,	0,	0);

DROP TABLE IF EXISTS `lh_chatbox`;
CREATE TABLE `lh_chatbox` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_id` int(11) NOT NULL,
  `active` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_accept`;
CREATE TABLE `lh_chat_accept` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `hash` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) NOT NULL,
  `wused` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_action`;
CREATE TABLE `lh_chat_action` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `action` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_archive_range`;
CREATE TABLE `lh_chat_archive_range` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `range_from` bigint(20) unsigned NOT NULL,
  `range_to` bigint(20) unsigned NOT NULL,
  `year_month` int(11) NOT NULL,
  `older_than` int(11) NOT NULL,
  `last_id` bigint(20) NOT NULL,
  `first_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_blocked_user`;
CREATE TABLE `lh_chat_blocked_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `datets` bigint(20) unsigned NOT NULL,
  `chat_id` bigint(20) unsigned NOT NULL,
  `dep_id` bigint(20) unsigned NOT NULL,
  `expires` bigint(20) unsigned NOT NULL DEFAULT 0,
  `btype` tinyint(1) NOT NULL DEFAULT 0,
  `nick` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_user_id` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `ip` (`ip`),
  KEY `nick` (`nick`),
  KEY `online_user_id` (`online_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_config`;
CREATE TABLE `lh_chat_config` (
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `explain` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hidden` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_chat_config` (`identifier`, `value`, `type`, `explain`, `hidden`) VALUES
('accept_chat_link_timeout',	'300',	0,	'How many seconds chat accept link is valid. Set 0 to force login all the time manually.',	0),
('accept_tos_link',	'#',	0,	'Change to your site Terms of Service',	0),
('activity_timeout',	'5',	0,	'How long operator should go offline automatically because of inactivity. Value in minutes',	0),
('activity_track_all',	'0',	0,	'Track all logged operators activity and ignore their individual settings.',	0),
('allow_reopen_closed',	'0',	0,	'Allow user to reopen closed chats?',	0),
('application_name',	'a:6:{s:3:\"eng\";s:31:\"Live Helper Chat - live support\";s:3:\"lit\";s:26:\"Live Helper Chat - pagalba\";s:3:\"hrv\";s:0:\"\";s:3:\"esp\";s:0:\"\";s:3:\"por\";s:0:\"\";s:10:\"site_admin\";s:31:\"Live Helper Chat - live support\";}',	1,	'Support application name, visible in browser title.',	0),
('assign_workflow_timeout',	'0',	0,	'Chats waiting in pending line more than n seconds should be auto assigned first. Time in seconds',	0),
('audit_cleanup_last',	'1761568507',	0,	'Track last audit cleanup',	1),
('audit_configuration',	'a:7:{s:8:\"days_log\";i:90;s:11:\"log_objects\";a:0:{}s:6:\"log_js\";i:0;s:9:\"log_block\";i:0;s:11:\"log_routing\";i:0;s:9:\"log_files\";i:0;s:8:\"log_user\";i:0;}',	0,	'',	1),
('autoclose_abandon_pending',	'0,0',	0,	'Automatically close pending chats where visitor has left a chat. Timeout in minutes, last activity by visitor <desktop timeout>,<mobile timeout>,<status chat>',	0),
('autoclose_activity_timeout',	'0',	0,	'Automatically close active chat if from last visitor/operator message passed. 0 - disabled, n > 0 time in minutes',	0),
('autoclose_timeout',	'0',	0,	'Automatic chats closing. 0 - disabled, n > 0 time in minutes before chat is automatically closed',	0),
('autoclose_timeout_active',	'0',	0,	'Automatic active chats closing. 0 - disabled, n > 0 time in minutes before chat is automatically closed',	0),
('autoclose_timeout_bot',	'0',	0,	'Automatic bot chats closing. 0 - disabled, n > 0 time in minutes before chat is automatically closed',	0),
('autoclose_timeout_pending',	'0',	0,	'Automatic pending chats closing. 0 - disabled, n > 0 time in minutes before chat is automatically closed',	0),
('autologin_data',	'a:3:{i:0;b:0;s:11:\"secret_hash\";s:40:\"CHANGE_THIS_SECRET_HASH_IN_PRODUCTION!!\";s:7:\"enabled\";i:0;}',	0,	'Autologin configuration data',	1),
('automatically_reopen_chat',	'1',	0,	'Automatically reopen chat on widget open',	0),
('autopurge_timeout',	'0',	0,	'Automatic chats purging. 0 - disabled, n > 0 time in minutes before chat is automatically deleted',	0),
('banned_ip_range',	'',	0,	'Which ip should not be allowed to chat',	0),
('bbc_button_visible',	'1',	0,	'Show BB Code button',	0),
('bbcode_options',	'a:2:{s:3:\"div\";a:0:{}s:3:\"dio\";a:0:{}}',	0,	'',	1),
('canned_msg_last',	'1761568507',	0,	'Track last canned messages cleanup',	1),
('cduration_timeout_operator',	'10',	0,	'How long visitor can wait for message from operator before time between messages are ignored. Values in minutes.',	0),
('cduration_timeout_user',	'4',	0,	'How long operator can wait for message from visitor before time between messages are ignored. Values in minutes.',	0),
('chatbox_data',	'a:6:{i:0;b:0;s:20:\"chatbox_auto_enabled\";i:0;s:19:\"chatbox_secret_hash\";s:40:\"CHANGE_THIS_CHATBOX_SECRET_HASH_PROD!!\";s:20:\"chatbox_default_name\";s:7:\"Chatbox\";s:17:\"chatbox_msg_limit\";i:50;s:22:\"chatbox_default_opname\";s:7:\"Manager\";}',	0,	'Chatbox configuration',	1),
('checkstatus_timeout',	'0',	0,	'Interval between chat status checks in seconds, 0 disabled.',	0),
('cleanup_cronjob',	'0',	0,	'Cleanup should be done only using cronjob.',	0),
('customer_company_name',	'Live Helper Chat',	0,	'Your company name - visible in bottom left corner',	0),
('customer_site_url',	'http://livehelperchat.com',	0,	'Your site URL address',	0),
('dashboard_order',	'[[\"online_operators\",\"departments_stats\",\"online_visitors\"],[\"group_chats\",\"my_chats\",\"pending_chats\",\"transfered_chats\"],[\"active_chats\",\"bot_chats\"]]',	0,	'Home page dashboard widgets order',	0),
('default_admin_theme_id',	'0',	0,	'Default admin theme ID',	1),
('default_theme_id',	'0',	0,	'Default theme ID.',	1),
('del_on_close_no_msg',	'0',	0,	'Delete chat on close if there are no messages from the visitor',	0),
('departament_availability',	'364',	0,	'How long department availability statistic should be kept? (days)',	0),
('departament_availability_last',	'1761568507',	0,	'Track last department availability cleanup',	1),
('disable_html5_storage',	'1',	0,	'Disable HMTL5 storage, check it if your site is switching between http and https',	0),
('disable_iframe_sharing',	'1',	0,	'Disable iframes in sharing mode',	0),
('disable_js_execution',	'1',	0,	'Disable JS execution in Co-Browsing operator window',	0),
('disable_live_autoassign',	'0',	0,	'Disable live auto assign',	0),
('disable_popup_restore',	'0',	0,	'Disable option in widget to open new window. Restore icon will be hidden',	0),
('disable_print',	'0',	0,	'Disable chat print',	0),
('disable_send',	'0',	0,	'Disable chat transcript send',	0),
('disable_txt_dwnld',	'0',	0,	'Disable chat download',	0),
('do_no_track_ip',	'0',	0,	'Do not track visitors IP',	0),
('enable_status_cache',	'0',	0,	'Enable status check cache using Redis. PHPResque extension is required.',	0),
('encrypt_msg_after',	'0',	0,	'After how many days anonymize messages',	0),
('encrypt_msg_op',	'0',	0,	'Anonymize also operators messages',	0),
('explicit_http_mode',	'',	0,	'Please enter explicit http mode. Either http: or https:, do not forget : at the end.',	0),
('export_hash',	'CHANGE_EXPORT_HASH',	0,	'Chats export secret hash',	0),
('faq_email_required',	'0',	0,	'Is visitor e-mail required for FAQ',	0),
('file_configuration',	'a:7:{i:0;b:0;s:5:\"ft_op\";s:47:\"gif|jpe?g|png|zip|svg|rar|xls|doc|docx|xlsx|pdf\";s:5:\"ft_us\";s:30:\"gif|jpe?g|png|svg|doc|docx|pdf\";s:6:\"fs_max\";i:2048;s:18:\"active_user_upload\";b:0;s:16:\"active_op_upload\";b:1;s:19:\"active_admin_upload\";b:1;}',	0,	'Files configuration item',	1),
('footprint_background',	'0',	0,	'Footprint updates should be processed in the background. Make sure you are running workflow background cronjob.',	0),
('front_tabs',	'dashboard,online_users,online_map',	0,	'Home page tabs order',	0),
('geo_data',	'a:5:{i:0;b:0;s:21:\"geo_detection_enabled\";i:1;s:22:\"geo_service_identifier\";s:8:\"max_mind\";s:23:\"max_mind_detection_type\";s:7:\"country\";s:22:\"max_mind_city_location\";s:37:\"var/external/geoip/GeoLite2-City.mmdb\";}',	0,	'',	1),
('geo_location_data',	'a:3:{s:4:\"zoom\";i:4;s:3:\"lat\";s:7:\"49.8211\";s:3:\"lng\";s:7:\"11.7835\";}',	0,	'',	1),
('geoadjustment_data',	'a:8:{i:0;b:0;s:18:\"use_geo_adjustment\";b:0;s:13:\"available_for\";s:0:\"\";s:15:\"other_countries\";s:6:\"custom\";s:8:\"hide_for\";s:0:\"\";s:12:\"other_status\";s:7:\"offline\";s:11:\"rest_status\";s:6:\"hidden\";s:12:\"apply_widget\";i:0;}',	0,	'Geo adjustment settings',	1),
('hide_button_dropdown',	'0',	0,	'Hide close button in dropdown',	0),
('hide_disabled_department',	'1',	0,	'Hide disabled department widget',	0),
('hide_right_column_frontpage',	'1',	0,	'Hide right column in frontpage',	0),
('ignorable_ip',	'',	0,	'Which ip should be ignored in online users list, separate by comma',	0),
('ignore_typing',	'0',	0,	'Do not store what visitor is typing',	0),
('ignore_user_status',	'0',	0,	'Ignore users online statuses and use departments online hours',	0),
('inform_unread_message',	'0',	0,	'Inform visitor about unread messages from operator, value in minutes. 0 - disabled',	0),
('list_closed',	'0',	0,	'List closed chats',	0),
('list_online_operators',	'1',	0,	'List online operators.',	0),
('list_unread',	'0',	0,	'List unread chats',	0),
('listd_op',	'10',	0,	'Default number of online operators to show',	0),
('max_message_length',	'500',	0,	'Maximum message length in characters',	0),
('message_seen_timeout',	'24',	0,	'Proactive message timeout in hours. After how many hours proactive chat mesasge should be shown again.',	0),
('mheight',	'',	0,	'Messages box height',	0),
('mheight_op',	'200',	0,	'Messages box height for operator',	0),
('min_phone_length',	'8',	0,	'Minimum phone number length',	0),
('mobile_options',	'a:2:{s:13:\"notifications\";i:0;s:7:\"fcm_key\";s:60:\"REPLACE_WITH_YOUR_FIREBASE_CLOUD_MESSAGING_SERVER_KEY_HERE\";}',	0,	'',	1),
('need_help_tip',	'1',	0,	'Show need help tooltip?',	0),
('need_help_tip_timeout',	'24',	0,	'Need help tooltip timeout, after how many hours show again tooltip?',	0),
('no_wildcard_cookie',	'0',	0,	'Cookie should be valid only for domain where Javascript is embedded (excludes subdomains)',	0),
('notice_message',	'',	0,	'',	1),
('on_close_exit_chat',	'0',	0,	'On chat close exit chat',	0),
('online_if',	'0',	0,	'',	0),
('open_closed_chat_timeout',	'1800',	0,	'How many seconds customer has to open already closed chat.',	0),
('paidchat_data',	'',	0,	'Paid chat configuration',	1),
('password_data',	'',	0,	'Password requirements',	1),
('preload_iframes',	'0',	0,	'Preload widget. It will avoid loading delay after clicking widget',	0),
('pro_active_invite',	'1',	0,	'Is pro active chat invitation active. Online users tracking also has to be enabled',	0),
('pro_active_limitation',	'-1',	0,	'Pro active chats invitations limitation based on pending chats, (-1) do not limit, (0,1,n+1) number of pending chats can be for invitation to be shown.',	0),
('pro_active_show_if_offline',	'0',	0,	'Should invitation logic be executed if there is no online operators',	0),
('product_enabled_module',	'0',	0,	'Product module is enabled',	1),
('product_show_departament',	'0',	0,	'Enable products show by departments',	1),
('recaptcha_data',	'a:4:{i:0;b:0;s:8:\"site_key\";s:0:\"\";s:10:\"secret_key\";s:0:\"\";s:7:\"enabled\";i:0;}',	0,	'Re-captcha configuration',	1),
('remember_phone_email',	'1',	0,	'Should we remember E-Mail, Phone for the next time visitor starts a chat?',	0),
('remember_username',	'1',	0,	'Should we remember username for the next time visitor starts a chat?',	0),
('reopen_as_new',	'1',	0,	'Reopen closed chat as new? Otherwise it will be reopened as active.',	0),
('reopen_chat_enabled',	'0',	0,	'Reopen chat functionality enabled',	0),
('reverse_pending',	'0',	0,	'Make default pending chats order from old to new',	0),
('run_departments_workflow',	'0',	0,	'Should cronjob run departments transfer workflow, even if user leaves a chat',	0),
('run_unaswered_chat_workflow',	'0',	0,	'Should cronjob run unanswered chats workflow and execute unaswered chats callback, 0 - no, any other number bigger than 0 is a minits how long chat have to be not accepted before executing callback.',	0),
('session_captcha',	'0',	0,	'Use session captcha. LHC have to be installed on the same domain or subdomain.',	0),
('sharing_auto_allow',	'0',	0,	'Do not ask permission for users to see their screen',	0),
('sharing_nodejs_enabled',	'0',	0,	'NodeJs support enabled',	0),
('sharing_nodejs_path',	'',	0,	'socket.io path, optional',	0),
('sharing_nodejs_secure',	'0',	0,	'Connect to NodeJs in https mode',	0),
('sharing_nodejs_sllocation',	'https://cdn.jsdelivr.net/npm/socket.io-client@2/dist/socket.io.js',	0,	'Location of SocketIO JS library',	0),
('sharing_nodejs_socket_host',	'',	0,	'Host where NodeJs is running',	0),
('show_language_switcher',	'0',	0,	'Show users option to switch language at widget',	0),
('show_languages',	'eng,lit,hrv,esp,por,nld,ara,ger,pol,rus,ita,fre,chn,cse,nor,tur,vnm,idn,sve,per,ell,dnk,rou,bgr,tha,geo,fin,alb',	0,	'Between what languages user should be able to switch',	0),
('smtp_data',	'a:5:{s:4:\"host\";s:0:\"\";s:4:\"port\";s:2:\"25\";s:8:\"use_smtp\";i:0;s:8:\"username\";s:0:\"\";s:8:\"password\";s:0:\"\";}',	0,	'SMTP configuration',	1),
('sound_invitation',	'1',	0,	'Play sound on invitation to chat.',	0),
('speech_data',	'a:3:{i:0;b:0;s:8:\"language\";i:7;s:7:\"dialect\";s:5:\"en-US\";}',	1,	'',	1),
('start_chat_data',	'a:80:{i:0;b:0;s:21:\"name_visible_in_popup\";b:0;s:27:\"name_visible_in_page_widget\";b:0;s:19:\"name_require_option\";s:8:\"required\";s:22:\"email_visible_in_popup\";b:0;s:28:\"email_visible_in_page_widget\";b:0;s:20:\"email_require_option\";s:8:\"required\";s:24:\"message_visible_in_popup\";b:1;s:30:\"message_visible_in_page_widget\";b:1;s:22:\"message_require_option\";s:8:\"required\";s:22:\"phone_visible_in_popup\";b:0;s:28:\"phone_visible_in_page_widget\";b:0;s:20:\"phone_require_option\";s:8:\"required\";s:21:\"force_leave_a_message\";b:0;s:29:\"offline_name_visible_in_popup\";b:1;s:35:\"offline_name_visible_in_page_widget\";b:1;s:27:\"offline_name_require_option\";s:8:\"required\";s:30:\"offline_phone_visible_in_popup\";b:0;s:36:\"offline_phone_visible_in_page_widget\";b:0;s:28:\"offline_phone_require_option\";s:8:\"required\";s:32:\"offline_message_visible_in_popup\";b:1;s:38:\"offline_message_visible_in_page_widget\";b:1;s:30:\"offline_message_require_option\";s:8:\"required\";s:15:\"auto_start_chat\";b:0;s:12:\"mobile_popup\";b:0;s:17:\"dont_auto_process\";b:0;s:20:\"tos_visible_in_popup\";b:0;s:12:\"requires_dep\";b:0;s:17:\"requires_dep_lock\";b:0;s:17:\"show_messages_box\";b:1;s:26:\"tos_visible_in_page_widget\";b:0;s:19:\"tos_checked_offline\";b:0;s:18:\"tos_checked_online\";b:0;s:28:\"offline_tos_visible_in_popup\";b:0;s:34:\"offline_tos_visible_in_page_widget\";b:0;s:35:\"offline_file_visible_in_page_widget\";b:0;s:29:\"offline_file_visible_in_popup\";b:0;s:11:\"name_hidden\";b:0;s:15:\"name_hidden_bot\";b:0;s:24:\"custom_fields_encryption\";s:0:\"\";s:19:\"offline_name_hidden\";b:0;s:13:\"pre_chat_html\";s:0:\"\";s:21:\"pre_offline_chat_html\";s:0:\"\";s:12:\"email_hidden\";b:0;s:16:\"email_hidden_bot\";b:0;s:20:\"offline_email_hidden\";b:0;s:15:\"user_msg_height\";s:0:\"\";s:12:\"phone_hidden\";b:0;s:16:\"phone_hidden_bot\";b:0;s:20:\"offline_phone_hidden\";b:0;s:14:\"message_hidden\";b:0;s:18:\"message_hidden_bot\";b:0;s:18:\"message_auto_start\";b:0;s:28:\"message_auto_start_key_press\";b:0;s:22:\"offline_message_hidden\";b:0;s:21:\"show_operator_profile\";b:1;s:21:\"remove_operator_space\";b:0;s:18:\"hide_message_label\";b:0;s:17:\"custom_fields_url\";s:0:\"\";s:13:\"custom_fields\";s:0:\"\";s:21:\"name_hidden_prefilled\";b:0;s:22:\"email_hidden_prefilled\";b:0;s:24:\"message_hidden_prefilled\";b:0;s:22:\"phone_hidden_prefilled\";b:0;s:29:\"offline_name_hidden_prefilled\";b:0;s:32:\"offline_message_hidden_prefilled\";b:0;s:30:\"offline_phone_hidden_prefilled\";b:0;s:18:\"disable_start_chat\";b:0;s:18:\"offline_name_width\";i:0;s:19:\"offline_email_width\";i:0;s:19:\"offline_phone_width\";i:0;s:10:\"name_width\";i:0;s:11:\"email_width\";i:0;s:11:\"phone_width\";i:0;s:17:\"hide_start_button\";b:0;s:9:\"lazy_load\";b:0;s:28:\"offline_email_require_option\";s:8:\"required\";s:30:\"offline_email_hidden_prefilled\";b:0;s:36:\"offline_email_visible_in_page_widget\";b:1;s:30:\"offline_email_visible_in_popup\";b:1;}',	0,	'',	1),
('suggest_leave_msg',	'1',	0,	'Suggest user to leave a message then user chooses offline department',	0),
('sync_sound_settings',	'a:16:{i:0;b:0;s:12:\"repeat_sound\";i:1;s:18:\"repeat_sound_delay\";i:5;s:10:\"show_alert\";b:0;s:22:\"new_chat_sound_enabled\";b:1;s:31:\"new_message_sound_admin_enabled\";b:1;s:30:\"new_message_sound_user_enabled\";b:1;s:14:\"online_timeout\";d:300;s:22:\"check_for_operator_msg\";d:10;s:21:\"back_office_sinterval\";d:10;s:22:\"chat_message_sinterval\";d:3.5;s:20:\"long_polling_enabled\";b:0;s:30:\"polling_chat_message_sinterval\";d:1.5;s:29:\"polling_back_office_sinterval\";d:5;s:18:\"connection_timeout\";i:30;s:28:\"browser_notification_message\";b:0;}',	0,	'',	1),
('track_activity',	'0',	0,	'Track users activity on site?',	0),
('track_domain',	'',	0,	'Set your domain to enable user tracking across different domain subdomains.',	0),
('track_footprint',	'0',	0,	'Track users footprint. For this also online visitors tracking should be enabled',	0),
('track_if_offline',	'0',	0,	'Track online visitors even if there is no online operators',	0),
('track_is_online',	'0',	0,	'Track is user still on site, chat status checks also has to be enabled',	0),
('track_mouse_activity',	'0',	0,	'Should mouse movement be tracked as activity measure, if not checked only basic events would be tracked',	0),
('track_online_visitors',	'1',	0,	'Enable online site visitors tracking',	0),
('tracked_footprint_cleanup',	'90',	0,	'How many days keep records of users footprint.',	0),
('tracked_users_cleanup',	'160',	0,	'How many days keep records of online users.',	0),
('tracked_users_cleanup_last',	'1761568507',	0,	'Track last cleanup',	1),
('transfer_configuration',	'0',	0,	'Transfer configuration',	1),
('translation_data',	'a:6:{i:0;b:0;s:19:\"translation_handler\";s:4:\"bing\";s:19:\"enable_translations\";b:0;s:14:\"bing_client_id\";s:0:\"\";s:18:\"bing_client_secret\";s:0:\"\";s:14:\"google_api_key\";s:0:\"\";}',	0,	'Translation data',	1),
('unban_ip_range',	'',	0,	'Which ip should not be allowed to be blocked',	0),
('uonline_sessions',	'364',	0,	'How long keep operators online sessions data? (days)',	0),
('uonline_sessions_last',	'1761568507',	0,	'Track last online operators cleanup',	1),
('update_ip',	'127.0.0.1',	0,	'Which ip should be allowed to update DB by executing http request, separate by comma?',	0),
('use_secure_cookie',	'0',	0,	'Use secure cookie, check this if you want to force SSL all the time',	0),
('valid_domains',	'',	0,	'Domains where script can be embedded. E.g example.com, google.com',	0),
('version_updates',	'339',	0,	'',	1),
('voting_days_limit',	'7',	0,	'How many days voting widget should not be expanded after last show',	0),
('vwait_to_long',	'120',	0,	'How long we should wait before we inform operator about unanswered chat.',	0),
('xmp_data',	'a:14:{i:0;b:0;s:4:\"host\";s:15:\"talk.google.com\";s:6:\"server\";s:9:\"gmail.com\";s:8:\"resource\";s:6:\"xmpphp\";s:4:\"port\";s:4:\"5222\";s:7:\"use_xmp\";i:0;s:8:\"username\";s:0:\"\";s:8:\"password\";s:0:\"\";s:11:\"xmp_message\";s:98:\"New chat request [{chat_id}] from [{department}]\r\n{messages}\r\nClick to accept a chat\r\n{url_accept}\";s:10:\"recipients\";s:0:\"\";s:20:\"xmp_accepted_message\";s:89:\"{user_name} has accepted a chat [{chat_id}] from [{department}]\r\n{messages}\r\n{url_accept}\";s:16:\"use_standard_xmp\";i:0;s:15:\"test_recipients\";s:0:\"\";s:21:\"test_group_recipients\";s:0:\"\";}',	0,	'XMP data',	1);

DROP TABLE IF EXISTS `lh_chat_event_track`;
CREATE TABLE `lh_chat_event_track` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_file`;
CREATE TABLE `lh_chat_file` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `upload_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `size` int(11) NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `extension` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `persistent` int(11) NOT NULL,
  `online_user_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `date` int(11) NOT NULL,
  `meta_msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `width` int(11) unsigned NOT NULL DEFAULT 0,
  `height` int(11) unsigned NOT NULL DEFAULT 0,
  `tmp` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `online_user_id` (`online_user_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_incoming`;
CREATE TABLE `lh_chat_incoming` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `utime` bigint(20) NOT NULL,
  `incoming_id` int(11) NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_external_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `incoming_ext_id_uniq` (`incoming_id`,`chat_external_id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_online_user`;
CREATE TABLE `lh_chat_online_user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `vid` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `current_page` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `page_title` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `referrer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_id` bigint(20) NOT NULL,
  `invitation_seen_count` int(11) NOT NULL,
  `invitation_id` int(11) NOT NULL,
  `last_visit` int(11) NOT NULL,
  `first_visit` int(11) NOT NULL,
  `total_visits` int(11) NOT NULL,
  `pages_count` int(11) NOT NULL,
  `tt_pages_count` int(11) NOT NULL,
  `invitation_count` int(11) NOT NULL,
  `last_check_time` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `notes` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_country_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_country_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `visitor_tz` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_user_proactive` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operator_user_id` int(11) NOT NULL,
  `conversion_id` int(11) NOT NULL,
  `message_seen` int(11) NOT NULL,
  `message_seen_ts` int(11) NOT NULL,
  `user_active` int(11) NOT NULL,
  `lat` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lon` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reopen_chat` int(11) NOT NULL,
  `time_on_site` int(11) NOT NULL,
  `tt_time_on_site` int(11) NOT NULL,
  `requires_email` int(11) NOT NULL,
  `requires_username` int(11) NOT NULL,
  `requires_phone` int(11) NOT NULL,
  `screenshot_id` int(11) NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_attr_system` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation_chat` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_attr` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` tinyint(1) NOT NULL DEFAULT 0,
  `chat_time` bigint(20) unsigned NOT NULL DEFAULT 0,
  `last_visit_prev` bigint(20) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `vid` (`vid`),
  KEY `dep_id` (`dep_id`),
  KEY `last_visit_dep_id` (`last_visit`,`dep_id`),
  KEY `first_visit` (`first_visit`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_chat_online_user` (`id`, `vid`, `ip`, `current_page`, `page_title`, `referrer`, `chat_id`, `invitation_seen_count`, `invitation_id`, `last_visit`, `first_visit`, `total_visits`, `pages_count`, `tt_pages_count`, `invitation_count`, `last_check_time`, `dep_id`, `user_agent`, `notes`, `user_country_code`, `user_country_name`, `visitor_tz`, `operator_message`, `operator_user_proactive`, `operator_user_id`, `conversion_id`, `message_seen`, `message_seen_ts`, `user_active`, `lat`, `lon`, `city`, `reopen_chat`, `time_on_site`, `tt_time_on_site`, `requires_email`, `requires_username`, `requires_phone`, `screenshot_id`, `identifier`, `operation`, `online_attr_system`, `operation_chat`, `online_attr`, `device_type`, `chat_time`, `last_visit_prev`) VALUES
(32,	'3b5bcd7c07be4c6dd659',	'192.168.1.1',	'',	'',	'',	3,	0,	0,	1762411928,	1761552891,	8,	1,	26,	0,	1762411928,	1,	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36',	'',	'',	'',	'Europe/Vilnius',	'',	'',	0,	0,	0,	0,	1,	'0',	'0',	'',	1,	0,	3480,	0,	0,	0,	0,	'',	'',	'',	'',	'',	1,	1761559888,	1762341232),
(33,	'3b55f52f2c4d6b1dad66',	'192.168.1.1',	'',	'',	'',	0,	0,	0,	1761552891,	1761552891,	1,	1,	1,	0,	1761552891,	0,	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',	'',	'',	'',	'',	'',	'',	0,	0,	0,	0,	1,	'0',	'0',	'',	0,	0,	0,	0,	0,	0,	0,	'',	'',	'',	'',	'',	1,	0,	0),
(34,	'c68444b249e59d1f284c',	'192.168.1.1',	'//example.com/testpages/lara.html',	'User Applicatio sdsdfn',	'',	5,	0,	0,	1761576559,	1761562883,	2,	9,	18,	0,	1761576559,	1,	'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36',	'',	'',	'',	'Europe/Vilnius',	'',	'',	0,	0,	1,	1761576417,	1,	'0',	'0',	'',	1,	158,	781,	0,	0,	0,	0,	'',	'',	'',	'',	'{\"init\":\"NEW_VID: c68444b249e59d1f284c | \\/\\/example.com\\/testpages\\/lara.html\"}',	1,	1761576417,	1761563504);

DROP TABLE IF EXISTS `lh_chat_online_user_footprint`;
CREATE TABLE `lh_chat_online_user_footprint` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `online_user_id` int(11) NOT NULL,
  `page` varchar(2083) COLLATE utf8mb4_unicode_ci NOT NULL,
  `vtime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `online_user_id` (`online_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_online_user_footprint_update`;
CREATE TABLE `lh_chat_online_user_footprint_update` (
  `online_user_id` bigint(20) NOT NULL,
  `command` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `args` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) NOT NULL,
  KEY `online_user_id` (`online_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_paid`;
CREATE TABLE `lh_chat_paid` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hash` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hash` (`hash`(191)),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_participant`;
CREATE TABLE `lh_chat_participant` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `duration` int(11) unsigned NOT NULL,
  `time` bigint(20) unsigned NOT NULL,
  `dep_id` bigint(20) unsigned NOT NULL,
  `frt` int(11) unsigned NOT NULL DEFAULT 0,
  `aart` int(11) unsigned NOT NULL DEFAULT 0,
  `mart` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `time` (`time`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_start_settings`;
CREATE TABLE `lh_chat_start_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `data` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `department_id` int(11) NOT NULL,
  `dep_ids` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `department_id` (`department_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_chat_voice_video`;
CREATE TABLE `lh_chat_voice_video` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `op_status` tinyint(4) NOT NULL,
  `vi_status` tinyint(4) NOT NULL,
  `voice` tinyint(4) NOT NULL,
  `video` tinyint(4) NOT NULL,
  `screen_share` tinyint(4) NOT NULL,
  `status` tinyint(4) NOT NULL,
  `ctime` int(11) NOT NULL,
  `token` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_cobrowse`;
CREATE TABLE `lh_cobrowse` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `online_user_id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  `url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `initialize` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `modifications` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `finished` tinyint(1) NOT NULL,
  `w` int(11) NOT NULL,
  `wh` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `online_user_id` (`online_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament`;
CREATE TABLE `lh_departament` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xmpp_recipients` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `xmpp_group_recipients` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int(11) NOT NULL,
  `sort_priority` int(11) NOT NULL,
  `department_transfer_id` int(11) NOT NULL,
  `transfer_timeout` int(11) NOT NULL,
  `exclude_inactive_chats` int(11) NOT NULL,
  `delay_before_assign` int(11) NOT NULL,
  `max_ac_dep_chats` int(11) NOT NULL,
  `assign_same_language` int(11) NOT NULL,
  `archive` tinyint(1) NOT NULL DEFAULT 0,
  `max_load` int(11) NOT NULL DEFAULT 0,
  `max_load_h` int(11) NOT NULL DEFAULT 0,
  `disabled` int(11) NOT NULL,
  `hidden` int(11) NOT NULL,
  `delay_lm` int(11) NOT NULL,
  `max_active_chats` int(11) NOT NULL,
  `max_timeout_seconds` int(11) NOT NULL,
  `identifier` varchar(2083) COLLATE utf8mb4_unicode_ci NOT NULL,
  `mod_start_hour` int(4) NOT NULL DEFAULT -1,
  `mod_end_hour` int(4) NOT NULL DEFAULT -1,
  `tud_start_hour` int(4) NOT NULL DEFAULT -1,
  `tud_end_hour` int(4) NOT NULL DEFAULT -1,
  `wed_start_hour` int(4) NOT NULL DEFAULT -1,
  `wed_end_hour` int(4) NOT NULL DEFAULT -1,
  `thd_start_hour` int(4) NOT NULL DEFAULT -1,
  `thd_end_hour` int(4) NOT NULL DEFAULT -1,
  `frd_start_hour` int(4) NOT NULL DEFAULT -1,
  `frd_end_hour` int(4) NOT NULL DEFAULT -1,
  `sad_start_hour` int(4) NOT NULL DEFAULT -1,
  `sad_end_hour` int(4) NOT NULL DEFAULT -1,
  `sud_start_hour` int(4) NOT NULL DEFAULT -1,
  `sud_end_hour` int(4) NOT NULL DEFAULT -1,
  `nc_cb_execute` tinyint(1) NOT NULL,
  `na_cb_execute` tinyint(1) NOT NULL,
  `inform_unread` tinyint(1) NOT NULL,
  `active_balancing` tinyint(1) NOT NULL,
  `visible_if_online` tinyint(1) NOT NULL,
  `inform_close` int(11) NOT NULL,
  `inform_unread_delay` int(11) NOT NULL,
  `inform_options` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `online_hours_active` tinyint(1) NOT NULL,
  `inform_delay` int(11) NOT NULL,
  `attr_int_1` int(11) NOT NULL DEFAULT 0,
  `attr_int_2` int(11) NOT NULL DEFAULT 0,
  `attr_int_3` int(11) NOT NULL DEFAULT 0,
  `pending_max` int(11) NOT NULL,
  `pending_group_max` int(11) NOT NULL,
  `active_chats_counter` int(11) NOT NULL DEFAULT 0,
  `inactive_chats_cnt` int(11) NOT NULL DEFAULT 0,
  `pending_chats_counter` int(11) NOT NULL DEFAULT 0,
  `bot_chats_counter` int(11) NOT NULL DEFAULT 0,
  `inop_chats_cnt` int(11) NOT NULL DEFAULT 0,
  `acop_chats_cnt` int(11) NOT NULL DEFAULT 0,
  `inform_close_all` int(11) NOT NULL DEFAULT 0,
  `inform_close_all_email` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',
  `alias` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_configuration` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `dep_offline` tinyint(1) NOT NULL DEFAULT 0,
  `max_load_op` int(11) unsigned NOT NULL DEFAULT 0,
  `max_load_op_h` int(11) unsigned NOT NULL DEFAULT 0,
  `max_ac_dep_mails` int(11) NOT NULL,
  `delay_before_assign_mail` int(11) NOT NULL,
  `ignore_op_status` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `max_active_mails` int(11) NOT NULL DEFAULT 0,
  `max_timeout_seconds_mail` int(11) NOT NULL,
  `active_mail_balancing` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier_2` (`identifier`(191)),
  KEY `archive` (`archive`),
  KEY `alias` (`alias`),
  KEY `attr_int_1` (`attr_int_1`),
  KEY `attr_int_2` (`attr_int_2`),
  KEY `attr_int_3` (`attr_int_3`),
  KEY `active_chats_counter` (`active_chats_counter`),
  KEY `pending_chats_counter` (`pending_chats_counter`),
  KEY `bot_chats_counter` (`bot_chats_counter`),
  KEY `disabled_hidden` (`disabled`,`hidden`),
  KEY `sort_priority_name` (`sort_priority`,`name`),
  KEY `active_mod` (`online_hours_active`,`mod_start_hour`,`mod_end_hour`),
  KEY `active_tud` (`online_hours_active`,`tud_start_hour`,`tud_end_hour`),
  KEY `active_wed` (`online_hours_active`,`wed_start_hour`,`wed_end_hour`),
  KEY `active_thd` (`online_hours_active`,`thd_start_hour`,`thd_end_hour`),
  KEY `active_frd` (`online_hours_active`,`frd_start_hour`,`frd_end_hour`),
  KEY `active_sad` (`online_hours_active`,`sad_start_hour`,`sad_end_hour`),
  KEY `active_sud` (`online_hours_active`,`sud_start_hour`,`sud_end_hour`),
  KEY `ignore_op_status` (`ignore_op_status`),
  KEY `dep_offline` (`dep_offline`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_departament` (`id`, `name`, `email`, `xmpp_recipients`, `xmpp_group_recipients`, `priority`, `sort_priority`, `department_transfer_id`, `transfer_timeout`, `exclude_inactive_chats`, `delay_before_assign`, `max_ac_dep_chats`, `assign_same_language`, `archive`, `max_load`, `max_load_h`, `disabled`, `hidden`, `delay_lm`, `max_active_chats`, `max_timeout_seconds`, `identifier`, `mod_start_hour`, `mod_end_hour`, `tud_start_hour`, `tud_end_hour`, `wed_start_hour`, `wed_end_hour`, `thd_start_hour`, `thd_end_hour`, `frd_start_hour`, `frd_end_hour`, `sad_start_hour`, `sad_end_hour`, `sud_start_hour`, `sud_end_hour`, `nc_cb_execute`, `na_cb_execute`, `inform_unread`, `active_balancing`, `visible_if_online`, `inform_close`, `inform_unread_delay`, `inform_options`, `online_hours_active`, `inform_delay`, `attr_int_1`, `attr_int_2`, `attr_int_3`, `pending_max`, `pending_group_max`, `active_chats_counter`, `inactive_chats_cnt`, `pending_chats_counter`, `bot_chats_counter`, `inop_chats_cnt`, `acop_chats_cnt`, `inform_close_all`, `inform_close_all_email`, `alias`, `product_configuration`, `bot_configuration`, `dep_offline`, `max_load_op`, `max_load_op_h`, `max_ac_dep_mails`, `delay_before_assign_mail`, `ignore_op_status`, `max_active_mails`, `max_timeout_seconds_mail`, `active_mail_balancing`) VALUES
(1,	'default',	'',	'',	'',	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	'',	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	-1,	0,	0,	0,	0,	0,	0,	0,	'',	0,	0,	0,	0,	0,	0,	0,	3,	0,	0,	0,	0,	0,	0,	'',	'',	'',	'',	0,	0,	0,	0,	0,	0,	0,	0,	0);

DROP TABLE IF EXISTS `lh_departament_availability`;
CREATE TABLE `lh_departament_availability` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `hour` int(11) NOT NULL,
  `hourminute` int(4) NOT NULL,
  `minute` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `ymdhi` bigint(20) NOT NULL,
  `ymd` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ymdhi` (`ymdhi`),
  KEY `dep_id` (`dep_id`),
  KEY `hourminute` (`hourminute`),
  KEY `time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_custom_work_hours`;
CREATE TABLE `lh_departament_custom_work_hours` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `date_from` int(11) NOT NULL,
  `date_to` int(11) NOT NULL,
  `start_hour` int(11) NOT NULL,
  `end_hour` int(11) NOT NULL,
  `repetitiveness` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`),
  KEY `date_from` (`date_from`),
  KEY `search_active` (`date_from`,`date_to`,`dep_id`),
  KEY `repetitiveness` (`repetitiveness`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_group`;
CREATE TABLE `lh_departament_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `achats_cnt` int(11) NOT NULL DEFAULT 0,
  `inachats_cnt` int(11) NOT NULL DEFAULT 0,
  `pchats_cnt` int(11) NOT NULL DEFAULT 0,
  `max_load` int(11) NOT NULL DEFAULT 0,
  `max_load_h` int(11) NOT NULL DEFAULT 0,
  `bchats_cnt` int(11) NOT NULL DEFAULT 0,
  `inopchats_cnt` int(11) NOT NULL DEFAULT 0,
  `acopchats_cnt` int(11) NOT NULL DEFAULT 0,
  `max_load_op` int(11) unsigned NOT NULL DEFAULT 0,
  `max_load_op_h` int(11) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_group_member`;
CREATE TABLE `lh_departament_group_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `dep_group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `dep_group_id_dep_id` (`dep_group_id`,`dep_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_group_user`;
CREATE TABLE `lh_departament_group_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `read_only` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `exc_indv_autoasign` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `assign_priority` int(11) NOT NULL DEFAULT 0,
  `chat_min_priority` int(11) NOT NULL DEFAULT 0,
  `chat_max_priority` int(11) NOT NULL DEFAULT 0,
  `only_priority` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dep_group_id` (`dep_group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_group_user_disabled`;
CREATE TABLE `lh_departament_group_user_disabled` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dep_group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `read_only` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `exc_indv_autoasign` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `assign_priority` int(11) NOT NULL DEFAULT 0,
  `chat_min_priority` int(11) NOT NULL DEFAULT 0,
  `chat_max_priority` int(11) NOT NULL DEFAULT 0,
  `only_priority` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dep_group_id` (`dep_group_id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_limit_group`;
CREATE TABLE `lh_departament_limit_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pending_max` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_departament_limit_group_member`;
CREATE TABLE `lh_departament_limit_group_member` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `dep_limit_group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_limit_group_id` (`dep_limit_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_faq`;
CREATE TABLE `lh_faq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `answer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` int(11) NOT NULL,
  `has_url` tinyint(1) NOT NULL,
  `is_wildcard` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `active` (`active`),
  KEY `active_url_2` (`active`,`url`(191)),
  KEY `has_url` (`has_url`),
  KEY `identifier` (`identifier`),
  KEY `is_wildcard` (`is_wildcard`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_forgotpasswordhash`;
CREATE TABLE `lh_forgotpasswordhash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `hash` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_bot`;
CREATE TABLE `lh_generic_bot_bot` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filepath` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nick` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_1` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_2` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attr_str_3` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_chat_event`;
CREATE TABLE `lh_generic_bot_chat_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `counter` int(11) NOT NULL,
  `content` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_chat_workflow`;
CREATE TABLE `lh_generic_bot_chat_workflow` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `trigger_id` bigint(20) NOT NULL,
  `time` int(11) NOT NULL,
  `identifier` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `collected_data` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_command`;
CREATE TABLE `lh_generic_bot_command` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_id` int(11) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `enabled_display` tinyint(1) NOT NULL DEFAULT 0,
  `position` int(11) unsigned NOT NULL DEFAULT 1000,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fields` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `shortcut_1` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `shortcut_2` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sub_command` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `info_msg` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`),
  KEY `command` (`command`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_exception`;
CREATE TABLE `lh_generic_bot_exception` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_exception_message`;
CREATE TABLE `lh_generic_bot_exception_message` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception_group_id` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `active` tinyint(1) NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `code` (`code`),
  KEY `exception_group_id` (`exception_group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_group`;
CREATE TABLE `lh_generic_bot_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_collapsed` int(11) NOT NULL DEFAULT 0,
  `pos` int(11) NOT NULL DEFAULT 0,
  `bot_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_id` (`bot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_payload`;
CREATE TABLE `lh_generic_bot_payload` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_id` int(11) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `bot_id` (`bot_id`),
  KEY `trigger_id` (`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_pending_event`;
CREATE TABLE `lh_generic_bot_pending_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_repeat_restrict`;
CREATE TABLE `lh_generic_bot_repeat_restrict` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `trigger_id` bigint(20) DEFAULT NULL,
  `identifier` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `counter` int(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `chat_id_trigger_id` (`chat_id`,`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_rest_api`;
CREATE TABLE `lh_generic_bot_rest_api` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(250) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_rest_api_cache`;
CREATE TABLE `lh_generic_bot_rest_api_cache` (
  `hash` varchar(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `rest_api_id` bigint(20) unsigned NOT NULL,
  `response` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` bigint(20) NOT NULL,
  UNIQUE KEY `rest_api_id_hash` (`rest_api_id`,`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_trigger`;
CREATE TABLE `lh_generic_bot_trigger` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actions` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `bot_id` int(11) NOT NULL,
  `default` int(11) NOT NULL,
  `default_unknown` int(11) NOT NULL,
  `as_argument` int(11) NOT NULL DEFAULT 0,
  `default_unknown_btn` int(11) NOT NULL DEFAULT 0,
  `default_always` int(11) NOT NULL,
  `pos` int(11) NOT NULL DEFAULT 0,
  `in_progress` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `bot_id` (`bot_id`),
  KEY `default_unknown` (`default_unknown`),
  KEY `default_unknown_btn` (`default_unknown_btn`),
  KEY `default_always` (`default_always`),
  KEY `group_id` (`group_id`),
  KEY `in_progress` (`in_progress`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_trigger_event`;
CREATE TABLE `lh_generic_bot_trigger_event` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pattern` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `pattern_exc` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `trigger_id` bigint(20) NOT NULL,
  `bot_id` int(11) NOT NULL,
  `on_start_type` tinyint(1) NOT NULL,
  `priority` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `skip` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `pattern_v2` (`pattern`(191)),
  KEY `type` (`type`),
  KEY `on_start_type` (`on_start_type`),
  KEY `trigger_id` (`trigger_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_trigger_event_template`;
CREATE TABLE `lh_generic_bot_trigger_event_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_trigger_template`;
CREATE TABLE `lh_generic_bot_trigger_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `actions` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_tr_group`;
CREATE TABLE `lh_generic_bot_tr_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filepath` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `nick` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_lang` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `use_translation_service` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_generic_bot_tr_item`;
CREATE TABLE `lh_generic_bot_tr_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `translation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `auto_translate` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_group`;
CREATE TABLE `lh_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` tinyint(1) NOT NULL,
  `required` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `disabled` (`disabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_group` (`id`, `name`, `disabled`, `required`) VALUES
(1,	'Administrators',	0,	0),
(2,	'Operators',	0,	0);

DROP TABLE IF EXISTS `lh_grouprole`;
CREATE TABLE `lh_grouprole` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`role_id`,`group_id`),
  KEY `group_id_primary` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_grouprole` (`id`, `group_id`, `role_id`) VALUES
(1,	1,	1),
(2,	2,	2);

DROP TABLE IF EXISTS `lh_groupuser`;
CREATE TABLE `lh_groupuser` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `group_id_2` (`group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_groupuser` (`id`, `group_id`, `user_id`) VALUES
(1,	1,	1);

DROP TABLE IF EXISTS `lh_group_chat`;
CREATE TABLE `lh_group_chat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `chat_id` bigint(20) NOT NULL DEFAULT 0,
  `last_msg_op_id` bigint(20) NOT NULL,
  `last_msg` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_user_msg_time` int(11) NOT NULL,
  `last_msg_id` bigint(20) NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `tm` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `chat_id` (`chat_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_group_chat_member`;
CREATE TABLE `lh_group_chat_member` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `last_activity` int(11) NOT NULL,
  `last_msg_id` bigint(20) NOT NULL DEFAULT 0,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `jtime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `type` (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_group_msg`;
CREATE TABLE `lh_group_msg` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name_support` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id_id` (`chat_id`,`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_group_object`;
CREATE TABLE `lh_group_object` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `object_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  `type` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `object_id_type` (`object_id`,`type`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_group_work`;
CREATE TABLE `lh_group_work` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `group_work_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_incoming_webhook`;
CREATE TABLE `lh_incoming_webhook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dep_id` int(11) NOT NULL,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `scope` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `disabled` tinyint(1) NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `log_incoming` tinyint(1) unsigned NOT NULL,
  `log_failed_parse` tinyint(1) unsigned NOT NULL,
  `icon` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `icon_color` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_mail_archive_range`;
CREATE TABLE `lh_mail_archive_range` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `range_from` bigint(20) unsigned NOT NULL,
  `range_to` bigint(20) unsigned NOT NULL,
  `older_than` int(11) NOT NULL,
  `last_id` bigint(20) NOT NULL,
  `first_id` bigint(20) NOT NULL,
  `year_month` int(11) NOT NULL,
  `type` tinyint(1) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_mail_continuous_event`;
CREATE TABLE `lh_mail_continuous_event` (
  `webhook_id` bigint(20) unsigned NOT NULL,
  `message_id` bigint(20) unsigned NOT NULL,
  `created_at` bigint(20) unsigned NOT NULL,
  UNIQUE KEY `webhook_id_message_id` (`webhook_id`,`message_id`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_msg`;
CREATE TABLE `lh_msg` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `meta_msg` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL DEFAULT 0,
  `user_id` int(11) NOT NULL DEFAULT 0,
  `name_support` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `del_st` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `chat_id_id` (`chat_id`,`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_msg` (`id`, `msg`, `meta_msg`, `time`, `chat_id`, `user_id`, `name_support`, `del_st`) VALUES
(7,	'asd',	'',	1761559888,	3,	0,	'',	0),
(8,	'sdfsdf',	'',	1761562893,	4,	0,	'',	0),
(9,	'Admin User has accepted the chat!',	'{\"content\":{\"accept_action\":{\"puser_id\":0,\"ol\":[\"popup_open\"],\"user_id\":1,\"name_support\":\"Admin User\"}}}',	1761562898,	4,	-1,	'Admin User',	0),
(10,	'Admin User has accepted the chat!',	'{\"content\":{\"accept_action\":{\"puser_id\":0,\"ol\":[\"click\"],\"user_id\":1,\"name_support\":\"Admin User\"}}}',	1761562903,	3,	-1,	'Admin User',	0),
(11,	'asdfsadf',	'',	1761562904,	3,	1,	'Admin User',	1),
(12,	'asdfasd',	'',	1761562907,	4,	0,	'',	0),
(13,	'Jj',	'',	1761562915,	3,	1,	'Admin User',	1),
(14,	'Dfgdfg',	'',	1761573630,	4,	1,	'Admin User',	1),
(15,	'asdf',	'',	1761576417,	5,	0,	'',	0),
(16,	'Admin User has accepted the chat!',	'{\"content\":{\"accept_action\":{\"puser_id\":0,\"ol\":[\"click\"],\"user_id\":1,\"name_support\":\"Admin User\"}}}',	1761576421,	5,	-1,	'Admin User',	0),
(17,	'Dfgdsfg',	'',	1761576423,	5,	1,	'Admin User',	3);

DROP TABLE IF EXISTS `lh_notification_op_subscriber`;
CREATE TABLE `lh_notification_op_subscriber` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `device_type` tinyint(1) NOT NULL,
  `ctime` bigint(20) unsigned NOT NULL,
  `utime` bigint(20) unsigned NOT NULL,
  `status` tinyint(1) unsigned NOT NULL,
  `achat` tinyint(1) unsigned NOT NULL,
  `pchat` tinyint(1) unsigned NOT NULL,
  `params` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_error` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `subscriber_hash` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `status` (`status`),
  KEY `user_id` (`user_id`),
  KEY `subscriber_hash` (`subscriber_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_notification_subscriber`;
CREATE TABLE `lh_notification_subscriber` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `chat_id` bigint(20) NOT NULL,
  `online_user_id` bigint(20) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `theme_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `utime` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `params` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` tinyint(1) NOT NULL,
  `subscriber_hash` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `uagent` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_error` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`),
  KEY `dep_id` (`dep_id`),
  KEY `online_user_id` (`online_user_id`),
  KEY `subscriber_hash` (`subscriber_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_question`;
CREATE TABLE `lh_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `active` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `is_voting` int(11) NOT NULL,
  `question_intro` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `revote` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `priority` (`priority`),
  KEY `active_priority` (`active`,`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_question_answer`;
CREATE TABLE `lh_question_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` bigint(20) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `ctime` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ip` (`ip`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_question_option`;
CREATE TABLE `lh_question_option` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `option_name` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  `priority` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_question_option_answer`;
CREATE TABLE `lh_question_option_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_id` int(11) NOT NULL,
  `option_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `ip` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_role`;
CREATE TABLE `lh_role` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_role` (`id`, `name`) VALUES
(1,	'Administrators'),
(2,	'Operators');

DROP TABLE IF EXISTS `lh_rolefunction`;
CREATE TABLE `lh_rolefunction` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `module` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `function` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `limitation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_rolefunction` (`id`, `role_id`, `module`, `function`, `limitation`, `type`) VALUES
(1,	1,	'*',	'*',	'',	0),
(2,	2,	'lhuser',	'selfedit',	'',	0),
(3,	2,	'lhuser',	'change_chat_nickname',	'',	0),
(4,	2,	'lhuser',	'changephoto',	'',	0),
(5,	2,	'lhuser',	'change_job_title',	'',	0),
(6,	2,	'lhuser',	'change_core_attributes',	'',	0),
(7,	2,	'lhuser',	'change_name_surname',	'',	0),
(8,	2,	'lhuser',	'selfedit',	'',	0),
(9,	2,	'lhuser',	'changeonlinestatus',	'',	0),
(10,	2,	'lhuser',	'changeskypenick',	'',	0),
(11,	2,	'lhuser',	'personalcannedmsg',	'',	0),
(12,	2,	'lhuser',	'change_visibility_list',	'',	0),
(13,	2,	'lhuser',	'see_assigned_departments',	'',	0),
(14,	2,	'lhuser',	'canseedepartmentstats',	'',	0),
(15,	2,	'lhchat',	'use',	'',	0),
(16,	2,	'lhchat',	'open_all',	'',	0),
(17,	2,	'lhchat',	'chattabschrome',	'',	0),
(18,	2,	'lhchat',	'singlechatwindow',	'',	0),
(19,	2,	'lhchat',	'allowopenremotechat',	'',	0),
(20,	2,	'lhchat',	'writeremotechat',	'',	0),
(21,	2,	'lhchat',	'allowchattabs',	'',	0),
(22,	2,	'lhchat',	'use_onlineusers',	'',	0),
(23,	2,	'lhchat',	'take_screenshot',	'',	0),
(24,	2,	'lhfront',	'use',	'',	0),
(25,	2,	'lhsystem',	'use',	'',	0),
(26,	2,	'lhtranslation',	'use',	'',	0),
(27,	2,	'lhchat',	'allowblockusers',	'',	0),
(28,	2,	'lhsystem',	'generatejs',	'',	0),
(29,	2,	'lhsystem',	'changelanguage',	'',	0),
(30,	2,	'lhchat',	'allowredirect',	'',	0),
(31,	2,	'lhchat',	'allowtransfer',	'',	0),
(32,	2,	'lhchat',	'allowtransferdirectly',	'',	0),
(33,	2,	'lhchat',	'administratecannedmsg',	'',	0),
(34,	2,	'lhchat',	'sees_all_online_visitors',	'',	0),
(35,	2,	'lhpermission',	'see_permissions',	'',	0),
(36,	2,	'lhquestionary',	'manage_questionary',	'',	0),
(37,	2,	'lhfaq',	'manage_faq',	'',	0),
(38,	2,	'lhchatbox',	'manage_chatbox',	'',	0),
(39,	2,	'lhbrowseoffer',	'manage_bo',	'',	0),
(40,	2,	'lhxml',	'*',	'',	0),
(41,	2,	'lhcobrowse',	'browse',	'',	0),
(42,	2,	'lhfile',	'use_operator',	'',	0),
(43,	2,	'lhfile',	'file_delete_chat',	'',	0),
(44,	2,	'lhstatistic',	'use',	'',	0),
(45,	2,	'lhspeech',	'changedefaultlanguage',	'',	0),
(46,	2,	'lhspeech',	'use',	'',	0),
(47,	2,	'lhcannedmsg',	'use',	'',	0),
(48,	2,	'lhcannedmsg',	'see_global',	'',	0),
(49,	2,	'lhchat',	'prev_chats',	'',	0),
(50,	2,	'lhtheme',	'personaltheme',	'',	0),
(51,	2,	'lhuser',	'userlistonline',	'',	0),
(52,	2,	'lhspeech',	'change_chat_recognition',	'',	0),
(53,	2,	'lhgroupchat',	'use',	'',	0),
(54,	2,	'lhuser',	'see_all_group_users',	'',	0),
(55,	2,	'lhvoicevideo',	'use',	'',	0),
(56,	1,	'lhaudit',	'use',	'',	1);

DROP TABLE IF EXISTS `lh_speech_chat_language`;
CREATE TABLE `lh_speech_chat_language` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `dialect` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_speech_language`;
CREATE TABLE `lh_speech_language` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `siteaccess` varchar(3) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_speech_language` (`id`, `name`, `siteaccess`) VALUES
(1,	'Afrikaans',	''),
(2,	'Bahasa Indonesia',	''),
(3,	'Bahasa Melayu',	''),
(4,	'Català',	''),
(5,	'Čeština',	'cse'),
(6,	'Deutsch',	'ger'),
(7,	'English',	''),
(8,	'Español',	'esp'),
(9,	'Euskara',	''),
(10,	'Français',	'fre'),
(11,	'Galego',	''),
(12,	'Hrvatski',	''),
(13,	'IsiZulu',	''),
(14,	'Íslenska',	''),
(15,	'Italiano',	'ita'),
(16,	'Magyar',	''),
(17,	'Nederlands',	'nld'),
(18,	'Norsk bokmål',	''),
(19,	'Polski',	'pol'),
(20,	'Português',	'por'),
(21,	'Română',	''),
(22,	'Slovenčina',	'svk'),
(23,	'Suomi',	'fin'),
(24,	'Svenska',	''),
(25,	'Türkçe',	'tur'),
(26,	'български',	''),
(27,	'Pусский',	'rus'),
(28,	'Српски',	''),
(29,	'한국어',	''),
(30,	'中文',	''),
(31,	'日本語',	''),
(32,	'Lingua latīna',	''),
(33,	'Lithuanian',	'lit'),
(34,	'Latvia',	''),
(35,	'Afar',	''),
(36,	'Arabic',	''),
(37,	'Assamese',	''),
(38,	'Azerbaijani',	''),
(39,	'Bulgarian',	'bgr'),
(40,	'Bangla',	''),
(41,	'Bosnian',	''),
(42,	'Cakchiquel',	''),
(43,	'Danish',	''),
(44,	'Greek',	''),
(45,	'Estonian',	''),
(46,	'Persian',	''),
(47,	'Filipino',	''),
(48,	'Gujarati',	''),
(49,	'Hebrew',	''),
(50,	'Croatian',	''),
(51,	'Indonesia',	''),
(52,	'Icelandic',	''),
(53,	'Georgian',	''),
(54,	'Maori (New Zealand)',	''),
(55,	'Macedonian',	''),
(56,	'Malay (Latin)',	''),
(57,	'Maltese',	''),
(58,	'Norwegian Nynorsk',	''),
(59,	'Norwegian',	'nor'),
(60,	'Northern Sotho (South Africa)',	''),
(61,	'Slovenian',	''),
(63,	'Thai',	''),
(64,	'Tagalog',	''),
(65,	'Tongan',	''),
(66,	'Ukrainian',	''),
(67,	'Vietnamese',	'vnm'),
(68,	'Chinese',	'chn');

DROP TABLE IF EXISTS `lh_speech_language_dialect`;
CREATE TABLE `lh_speech_language_dialect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language_id` int(11) NOT NULL,
  `lang_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `lang_code` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_code` varchar(4) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `language_id` (`language_id`),
  KEY `short_code` (`short_code`),
  KEY `lang_code` (`lang_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_speech_language_dialect` (`id`, `language_id`, `lang_name`, `lang_code`, `short_code`) VALUES
(1,	1,	'Afrikaans',	'af-ZA',	'af'),
(2,	2,	'Bahasa Indonesia',	'id-ID',	'id'),
(3,	3,	'Bahasa Melayu',	'ms-MY',	''),
(4,	4,	'Català',	'ca-ES',	''),
(5,	5,	'Čeština',	'cs-CZ',	'cs'),
(6,	6,	'Deutsch',	'de-DE',	'de'),
(7,	7,	'Australia',	'en-AU',	''),
(8,	7,	'Canada',	'en-CA',	''),
(9,	7,	'India',	'en-IN',	''),
(10,	7,	'New Zealand',	'en-NZ',	''),
(11,	7,	'South Africa',	'en-ZA',	''),
(12,	7,	'United Kingdom',	'en-GB',	'en'),
(13,	7,	'United States',	'en-US',	''),
(14,	8,	'Argentina',	'es-AR',	''),
(15,	8,	'Bolivia',	'es-BO',	''),
(16,	8,	'Chile',	'es-CL',	''),
(17,	8,	'Colombia',	'es-CO',	''),
(18,	8,	'Costa Rica',	'es-CR',	''),
(19,	8,	'Ecuador',	'es-EC',	''),
(20,	8,	'El Salvador',	'es-SV',	''),
(21,	8,	'España',	'es-ES',	'es'),
(22,	8,	'Estados Unidos',	'es-US',	''),
(23,	8,	'Guatemala',	'es-GT',	''),
(24,	8,	'Honduras',	'es-HN',	''),
(25,	8,	'México',	'es-MX',	''),
(26,	8,	'Nicaragua',	'es-NI',	''),
(27,	8,	'Panamá',	'es-PA',	''),
(28,	8,	'Paraguay',	'es-PY',	''),
(29,	8,	'Perú',	'es-PE',	''),
(30,	8,	'Puerto Rico',	'es-PR',	''),
(31,	8,	'República Dominicana',	'es-DO',	''),
(32,	8,	'Uruguay',	'es-UY',	''),
(33,	8,	'Venezuela',	'es-VE',	''),
(34,	9,	'Euskara',	'eu-ES',	''),
(35,	10,	'Français',	'fr-FR',	'fr'),
(36,	11,	'Galego',	'gl-ES',	''),
(37,	12,	'Hrvatski',	'hr_HR',	''),
(38,	13,	'IsiZulu',	'zu-ZA',	''),
(39,	14,	'Íslenska',	'is-IS',	''),
(40,	15,	'Italia',	'it-IT',	'it'),
(41,	15,	'Svizzera',	'it-CH',	'it'),
(42,	16,	'Magyar',	'hu-HU',	'hu'),
(43,	17,	'Nederlands',	'nl-NL',	'nl'),
(44,	18,	'Norsk bokmål',	'nb-NO',	'nb'),
(45,	19,	'Polski',	'pl-PL',	'pl'),
(46,	20,	'Brasil',	'pt-BR',	''),
(47,	20,	'Portugal',	'pt-PT',	'pt'),
(48,	21,	'Română',	'ro-RO',	'ro'),
(49,	22,	'Slovenčina',	'sk-SK',	'sk'),
(50,	23,	'Suomi',	'fi-FI',	'fi'),
(51,	24,	'Swedish',	'sv-SE',	'sv'),
(52,	25,	'Türkçe',	'tr-TR',	'tr'),
(53,	26,	'български',	'bg-BG',	''),
(54,	27,	'Pусский',	'ru-RU',	'ru'),
(55,	28,	'Serbian',	'sr-RS',	'sr'),
(56,	29,	'한국어',	'ko-KR',	'ko'),
(57,	30,	'普通话 (中国大陆)',	'cmn-Hans-CN',	''),
(58,	30,	'普通话 (香港)',	'cmn-Hans-HK',	''),
(59,	30,	'中文 (台灣)',	'cmn-Hant-TW',	''),
(60,	30,	'粵語 (香港)',	'yue-Hant-HK',	''),
(61,	31,	'日本語',	'ja-JP',	'ja'),
(62,	32,	'Lingua latīna',	'la',	''),
(64,	33,	'Lithuanian',	'lt-LT',	'lt'),
(65,	34,	'Latvia',	'lv-LV',	'lv'),
(66,	35,	'Afar',	'aa-DJ',	'aa'),
(67,	36,	'Egypt',	'ar-EG',	'ar'),
(68,	37,	'India',	'as-IN',	'as'),
(69,	38,	'Azerbaijani',	'az-AZ',	'az'),
(70,	39,	'Bulgarian',	'bg',	'bg'),
(71,	40,	'Bangla',	'bn',	'bn'),
(72,	41,	'Bosnian',	'bs-BA',	'bs'),
(73,	42,	'Cakchiquel',	'cak',	'cak'),
(74,	43,	'Danish',	'da-dk',	'da'),
(75,	44,	'Greek',	'el-GR',	'el'),
(76,	45,	'Estonian',	'et-EE',	'et'),
(77,	46,	'Persian',	'fa-IR',	'fa'),
(78,	47,	'Filipino',	'fil',	'fil'),
(79,	48,	'Gujarati',	'gu-IN',	'gu'),
(80,	49,	'Hebrew',	'he',	'he'),
(81,	50,	'Croatian',	'hr-HR',	'hr'),
(82,	51,	'Indonesia',	'in',	'in'),
(83,	52,	'Icelandic',	'is',	'is'),
(84,	53,	'Georgian',	'ka-ge',	'ka'),
(85,	54,	'Maori (New Zealand)',	'mi-nz',	'mi'),
(86,	55,	'Macedonian',	'mk-MK',	'mk'),
(87,	56,	'Malay (Latin)',	'ms',	'ms'),
(88,	57,	'Maltese',	'mt',	'mt'),
(89,	58,	'Norwegian Nynorsk',	'nn-NO',	'nn'),
(90,	59,	'Norwegian',	'no',	'no'),
(91,	60,	'Northern Sotho (South Africa)',	'nso-za',	'nso'),
(92,	61,	'Slovenian',	'sl-SI',	'sl'),
(94,	63,	'Thai',	'th-TH',	'th'),
(95,	64,	'Tagalog',	'tl',	'tl'),
(96,	65,	'Tongan',	'to-TO',	'to'),
(97,	66,	'Ukrainian',	'uk-UA',	'uk'),
(98,	67,	'Vietnamese',	'vi-VN',	'vi'),
(99,	68,	'Chinese',	'zh-CN',	'zh'),
(100,	36,	'Egypt',	'ar-AE',	''),
(101,	36,	'Egypt',	'ar-IQ',	''),
(102,	41,	'Bosnian',	'bs-Latn-BA',	''),
(103,	6,	'Deutsch',	'de-at',	''),
(104,	6,	'Deutsch',	'de-ch',	''),
(105,	6,	'Deutsch',	'de-GB',	''),
(106,	6,	'Deutsch',	'de-LI',	''),
(107,	6,	'Deutsch',	'de-LU',	''),
(108,	7,	'United Kingdom',	'en-029',	''),
(109,	7,	'United Kingdom',	'en-AS',	''),
(110,	7,	'United Kingdom',	'en-BE',	''),
(111,	7,	'United Kingdom',	'en-BM',	''),
(112,	7,	'United Kingdom',	'en-BS',	''),
(113,	7,	'United Kingdom',	'en-BW',	''),
(114,	7,	'United Kingdom',	'en-CH',	''),
(115,	7,	'United Kingdom',	'en-CX',	''),
(116,	7,	'United Kingdom',	'en-CY',	''),
(117,	7,	'United Kingdom',	'en-DE',	''),
(118,	7,	'United Kingdom',	'en-DK',	''),
(119,	7,	'United Kingdom',	'en-DM',	''),
(120,	7,	'United Kingdom',	'en-GY',	''),
(121,	7,	'United Kingdom',	'en-HK',	''),
(122,	7,	'United Kingdom',	'en-ie',	''),
(123,	7,	'United Kingdom',	'en-IM',	''),
(124,	7,	'United Kingdom',	'en-JM',	''),
(125,	7,	'United Kingdom',	'en-KY',	''),
(126,	7,	'United Kingdom',	'en-MY',	''),
(127,	7,	'United Kingdom',	'en-NF',	''),
(128,	7,	'United Kingdom',	'en-NG',	''),
(129,	7,	'United Kingdom',	'en-NL',	''),
(130,	7,	'United Kingdom',	'en-PH',	''),
(131,	7,	'United Kingdom',	'en-SE',	''),
(132,	7,	'United Kingdom',	'en-sg',	''),
(133,	7,	'United Kingdom',	'en-SI',	''),
(134,	7,	'United Kingdom',	'en-SS',	''),
(135,	7,	'United Kingdom',	'en-TO',	''),
(136,	7,	'United Kingdom',	'en-TZ',	''),
(137,	7,	'United Kingdom',	'en-UG',	''),
(138,	7,	'United Kingdom',	'en-UK',	''),
(139,	7,	'United Kingdom',	'en-ZG',	''),
(140,	7,	'United Kingdom',	'en-ZM',	''),
(141,	7,	'United Kingdom',	'en-ZW',	''),
(142,	8,	'España',	'es-419',	''),
(143,	8,	'España',	'es-xl',	''),
(144,	47,	'Filipino',	'fil-PH',	''),
(145,	10,	'Français',	'fr-BE',	''),
(146,	10,	'Français',	'fr-ca',	''),
(147,	10,	'Français',	'fr-ch',	''),
(148,	10,	'Français',	'fr-CM',	''),
(149,	10,	'Français',	'fr-MC',	''),
(150,	49,	'Hebrew',	'he-IL',	''),
(151,	50,	'Croatian',	'hr-BA',	''),
(152,	17,	'Nederlands',	'nl-BE',	''),
(153,	19,	'Polski',	'pl-GB',	''),
(154,	27,	'Pусский',	'ru-KZ',	''),
(155,	27,	'Pусский',	'ru-UA',	''),
(156,	28,	'Serbian',	'sr-BA',	''),
(157,	28,	'Serbian',	'sr-Latn-RS',	''),
(158,	68,	'Chinese',	'zh-MO',	''),
(159,	68,	'Chinese',	'zh-SG',	''),
(160,	68,	'Chinese',	'zh-TW',	'');

DROP TABLE IF EXISTS `lh_speech_user_language`;
CREATE TABLE `lh_speech_user_language` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `language` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_language` (`user_id`,`language`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_transfer`;
CREATE TABLE `lh_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `chat_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `transfer_user_id` int(11) NOT NULL,
  `from_dep_id` int(11) NOT NULL,
  `ctime` int(11) NOT NULL,
  `transfer_to_user_id` int(11) NOT NULL,
  `transfer_scope` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`),
  KEY `transfer_user_id_dep_id` (`transfer_user_id`,`dep_id`),
  KEY `transfer_to_user_id` (`transfer_to_user_id`),
  KEY `chat_id_transfer` (`chat_id`,`transfer_scope`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_userdep`;
CREATE TABLE `lh_userdep` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `last_activity` int(11) NOT NULL,
  `lastd_activity` int(11) NOT NULL DEFAULT 0,
  `exclude_autoasign` tinyint(1) NOT NULL DEFAULT 0,
  `hide_online` int(11) NOT NULL,
  `last_accepted` int(11) NOT NULL DEFAULT 0,
  `active_chats` int(11) NOT NULL DEFAULT 0,
  `pending_chats` int(11) NOT NULL DEFAULT 0,
  `inactive_chats` int(11) NOT NULL DEFAULT 0,
  `max_chats` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `ro` tinyint(1) NOT NULL DEFAULT 0,
  `hide_online_ts` int(11) NOT NULL DEFAULT 0,
  `dep_group_id` int(11) NOT NULL DEFAULT 0,
  `always_on` tinyint(1) NOT NULL DEFAULT 0,
  `exclude_autoasign_mails` tinyint(1) NOT NULL DEFAULT 0,
  `exc_indv_autoasign` tinyint(1) NOT NULL DEFAULT 0,
  `last_accepted_mail` int(11) NOT NULL DEFAULT 0,
  `active_mails` int(11) NOT NULL DEFAULT 0,
  `pending_mails` int(11) NOT NULL DEFAULT 0,
  `max_mails` int(11) NOT NULL DEFAULT 0,
  `assign_priority` int(11) NOT NULL DEFAULT 0,
  `chat_max_priority` int(11) NOT NULL DEFAULT 0,
  `chat_min_priority` int(11) NOT NULL DEFAULT 0,
  `only_priority` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `last_activity_hide_online_dep_id` (`last_activity`,`hide_online`,`dep_id`),
  KEY `dep_id` (`dep_id`),
  KEY `user_id_type` (`user_id`,`type`),
  KEY `online_op_widget_2` (`dep_id`,`last_activity`,`user_id`),
  KEY `online_op_widget_3` (`user_id`,`active_chats`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_userdep` (`id`, `user_id`, `dep_id`, `last_activity`, `lastd_activity`, `exclude_autoasign`, `hide_online`, `last_accepted`, `active_chats`, `pending_chats`, `inactive_chats`, `max_chats`, `type`, `ro`, `hide_online_ts`, `dep_group_id`, `always_on`, `exclude_autoasign_mails`, `exc_indv_autoasign`, `last_accepted_mail`, `active_mails`, `pending_mails`, `max_mails`, `assign_priority`, `chat_max_priority`, `chat_min_priority`, `only_priority`) VALUES
(1,	1,	0,	1762412339,	1762411937,	0,	0,	0,	3,	0,	0,	0,	0,	0,	1685955908,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0);

DROP TABLE IF EXISTS `lh_userdep_alias`;
CREATE TABLE `lh_userdep_alias` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `dep_id` bigint(20) unsigned NOT NULL,
  `dep_group_id` bigint(20) unsigned NOT NULL,
  `job_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `nick` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filepath` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dep_id_user_id` (`dep_id`,`user_id`),
  KEY `dep_group_id_user_id` (`dep_group_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_userdep_disabled`;
CREATE TABLE `lh_userdep_disabled` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `dep_id` int(11) NOT NULL,
  `last_activity` bigint(20) unsigned NOT NULL,
  `hide_online` int(11) NOT NULL,
  `last_accepted` bigint(20) unsigned NOT NULL DEFAULT 0,
  `active_chats` int(11) NOT NULL DEFAULT 0,
  `type` int(11) NOT NULL DEFAULT 0,
  `dep_group_id` int(11) NOT NULL DEFAULT 0,
  `hide_online_ts` bigint(20) unsigned NOT NULL DEFAULT 0,
  `pending_chats` int(11) NOT NULL DEFAULT 0,
  `inactive_chats` int(11) NOT NULL DEFAULT 0,
  `max_chats` int(11) NOT NULL DEFAULT 0,
  `exclude_autoasign` tinyint(1) NOT NULL DEFAULT 0,
  `ro` tinyint(1) NOT NULL DEFAULT 0,
  `always_on` tinyint(1) NOT NULL DEFAULT 0,
  `lastd_activity` bigint(20) unsigned NOT NULL DEFAULT 0,
  `exc_indv_autoasign` tinyint(1) NOT NULL DEFAULT 0,
  `exclude_autoasign_mails` tinyint(1) NOT NULL DEFAULT 0,
  `active_mails` int(11) NOT NULL DEFAULT 0,
  `pending_mails` int(11) NOT NULL DEFAULT 0,
  `max_mails` int(11) NOT NULL DEFAULT 0,
  `last_accepted_mail` bigint(20) unsigned NOT NULL DEFAULT 0,
  `assign_priority` int(11) NOT NULL DEFAULT 0,
  `chat_max_priority` int(11) NOT NULL DEFAULT 0,
  `chat_min_priority` int(11) NOT NULL DEFAULT 0,
  `only_priority` tinyint(1) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `dep_id` (`dep_id`),
  KEY `user_id_type` (`user_id`,`type`),
  KEY `last_activity_hide_online_dep_id` (`last_activity`,`hide_online`,`dep_id`),
  KEY `online_op_widget_2` (`dep_id`,`last_activity`,`user_id`),
  KEY `online_op_widget_3` (`user_id`,`active_chats`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_users`;
CREATE TABLE `lh_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_zone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `surname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filepath` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_title` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `departments_ids` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `chat_nickname` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `xmpp_username` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `session_id` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `operation_admin` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `skype` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `exclude_autoasign` tinyint(1) NOT NULL,
  `disabled` tinyint(4) NOT NULL,
  `hide_online` tinyint(1) NOT NULL,
  `all_departments` tinyint(1) NOT NULL,
  `invisible_mode` tinyint(1) NOT NULL,
  `inactive_mode` tinyint(1) NOT NULL,
  `rec_per_req` tinyint(1) NOT NULL,
  `auto_accept` tinyint(1) NOT NULL,
  `max_active_chats` int(11) NOT NULL,
  `cache_version` int(11) unsigned NOT NULL DEFAULT 0,
  `pswd_updated` int(11) NOT NULL,
  `attr_int_1` int(11) NOT NULL,
  `attr_int_2` int(11) NOT NULL,
  `attr_int_3` int(11) NOT NULL,
  `force_logout` tinyint(1) unsigned NOT NULL DEFAULT 0,
  `llogin` bigint(20) unsigned NOT NULL DEFAULT 0,
  `always_on` tinyint(1) NOT NULL DEFAULT 0,
  `exclude_autoasign_mails` tinyint(1) NOT NULL DEFAULT 0,
  `max_active_mails` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `hide_online` (`hide_online`),
  KEY `rec_per_req` (`rec_per_req`),
  KEY `disabled` (`disabled`),
  KEY `email` (`email`),
  KEY `xmpp_username` (`xmpp_username`(191)),
  KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_users` (`id`, `username`, `password`, `email`, `time_zone`, `name`, `surname`, `filepath`, `filename`, `job_title`, `departments_ids`, `chat_nickname`, `xmpp_username`, `session_id`, `avatar`, `operation_admin`, `skype`, `exclude_autoasign`, `disabled`, `hide_online`, `all_departments`, `invisible_mode`, `inactive_mode`, `rec_per_req`, `auto_accept`, `max_active_chats`, `cache_version`, `pswd_updated`, `attr_int_1`, `attr_int_2`, `attr_int_3`, `force_logout`, `llogin`, `always_on`, `exclude_autoasign_mails`, `max_active_mails`) VALUES
(1,	'admin',	'$2y$10$EXAMPLE.HASH.PLACEHOLDER.CHANGE.IN.PRODUCTION',	'admin@example.com',	'',	'Admin',	'User',	'var/userphoto/2022y/01/01/1/',	'ad5e293b9db6191f696b1c519e93f1af.png',	'',	'0',	'',	'',	'',	'',	'',	'',	0,	0,	0,	1,	0,	0,	0,	0,	0,	2,	1641021220,	0,	0,	0,	0,	1762342315,	0,	0,	0);

DROP TABLE IF EXISTS `lh_users_login`;
CREATE TABLE `lh_users_login` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` int(11) NOT NULL,
  `ctime` bigint(20) NOT NULL,
  `status` int(11) NOT NULL,
  `ip` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `msg` varchar(250) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id_type` (`user_id`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_users_login` (`id`, `user_id`, `type`, `ctime`, `status`, `ip`, `msg`) VALUES
(1,	1,	0,	1641021223,	0,	'192.168.1.100',	'Failed login. WEB'),
(2,	1,	1,	1641021227,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(3,	1,	0,	1641035169,	0,	'192.168.1.100',	'Failed login. WEB'),
(4,	1,	1,	1641035171,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(5,	1,	0,	1641060248,	0,	'192.168.1.100',	'Failed login. WEB'),
(6,	1,	1,	1641060251,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(7,	1,	0,	1641189254,	0,	'192.168.1.100',	'Failed login. WEB'),
(8,	1,	1,	1641189257,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(9,	1,	0,	1685504504,	0,	'192.168.1.100',	'Failed login. WEB'),
(10,	1,	0,	1685504524,	0,	'192.168.1.100',	'Failed login. WEB'),
(11,	1,	1,	1685504578,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(12,	1,	1,	1685765863,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(13,	1,	1,	1685932371,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(14,	1,	1,	1687247894,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(15,	1,	0,	1689582528,	0,	'192.168.1.100',	'Failed login. WEB'),
(16,	1,	1,	1689582535,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(17,	1,	1,	1695018578,	0,	'192.168.1.100',	'Logged in successfully. WEB'),
(18,	1,	0,	1761552908,	0,	'192.168.1.1',	'Failed login. WEB'),
(19,	1,	0,	1761552911,	0,	'192.168.1.1',	'Failed login. WEB'),
(20,	1,	0,	1761552916,	0,	'192.168.1.1',	'Failed login. WEB'),
(21,	1,	1,	1761552921,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(22,	1,	1,	1761553066,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(23,	1,	1,	1761557015,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(24,	1,	0,	1761558704,	0,	'192.168.1.1',	'Failed login. WEB'),
(25,	1,	1,	1761558706,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(26,	1,	0,	1761574223,	0,	'192.168.1.1',	'Failed login. WEB'),
(27,	1,	0,	1761574226,	0,	'192.168.1.1',	'Failed login. WEB'),
(28,	1,	1,	1761574229,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(29,	1,	1,	1761576412,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(30,	1,	0,	1762334186,	0,	'192.168.1.1',	'Failed login. WEB'),
(31,	1,	1,	1762334188,	0,	'192.168.1.1',	'Logged in successfully. WEB'),
(32,	1,	0,	1762342312,	0,	'192.168.1.1',	'Failed login. WEB'),
(33,	1,	1,	1762342315,	0,	'192.168.1.1',	'Logged in successfully. WEB');

DROP TABLE IF EXISTS `lh_users_online_session`;
CREATE TABLE `lh_users_online_session` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `time` int(11) NOT NULL,
  `duration` int(11) NOT NULL,
  `lactivity` int(11) NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `user_id_lactivity` (`user_id`,`lactivity`),
  KEY `lactivity` (`lactivity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_users_online_session` (`id`, `user_id`, `time`, `duration`, `lactivity`, `type`) VALUES
(1,	1,	1641021227,	10480,	1641031707,	0),
(2,	1,	1641032728,	0,	1641032728,	0),
(3,	1,	1641035172,	4030,	1641039202,	0),
(4,	1,	1641039404,	1305,	1641040709,	0),
(5,	1,	1641040797,	1253,	1641042050,	0),
(6,	1,	1641042127,	6072,	1641048199,	0),
(7,	1,	1641059232,	1399,	1641060631,	0),
(8,	1,	1641063837,	328,	1641064165,	0),
(9,	1,	1641065170,	6006,	1641071176,	0),
(10,	1,	1641071338,	30711,	1641102049,	0),
(11,	1,	1641189257,	1282,	1641190539,	0),
(12,	1,	1685504581,	7079,	1685511660,	0),
(13,	1,	1685511735,	15485,	1685527220,	0),
(14,	1,	1685595187,	12541,	1685607728,	0),
(15,	1,	1685607784,	5978,	1685613762,	0),
(16,	1,	1685689127,	5696,	1685694823,	0),
(17,	1,	1685760122,	459,	1685760581,	0),
(18,	1,	1685761965,	3570,	1685765535,	0),
(19,	1,	1685765865,	14380,	1685780245,	0),
(20,	1,	1685780875,	4424,	1685785299,	0),
(21,	1,	1685932372,	5311,	1685937683,	0),
(22,	1,	1685937767,	3801,	1685941568,	0),
(23,	1,	1685942087,	13796,	1685955883,	0),
(24,	1,	1685955927,	3364,	1685959291,	0),
(25,	1,	1686017228,	28417,	1686045645,	0),
(26,	1,	1686104157,	15586,	1686119743,	0),
(27,	1,	1686121346,	1337,	1686122683,	0),
(28,	1,	1686122837,	9161,	1686131998,	0),
(29,	1,	1686190196,	19491,	1686209687,	0),
(30,	1,	1687247897,	30,	1687247927,	0),
(31,	1,	1689582543,	5496,	1689588039,	0),
(32,	1,	1689588586,	6433,	1689595019,	0),
(33,	1,	1689652375,	3515,	1689655890,	0),
(34,	1,	1689655937,	3629,	1689659566,	0),
(35,	1,	1689669724,	4729,	1689674453,	0),
(36,	1,	1689674533,	3013,	1689677546,	0),
(37,	1,	1689741005,	8100,	1689749105,	0),
(38,	1,	1689765594,	11408,	1689777002,	0),
(39,	1,	1689777364,	4187,	1689781551,	0),
(40,	1,	1689819232,	155,	1689819387,	0),
(41,	1,	1695018584,	234,	1695018818,	0),
(42,	1,	1761552922,	43,	1761552965,	0),
(43,	1,	1761553066,	1720,	1761554786,	0),
(44,	1,	1761555463,	26,	1761555489,	0),
(45,	1,	1761557015,	707,	1761557722,	0),
(46,	1,	1761558160,	52,	1761558212,	0),
(47,	1,	1761558523,	43,	1761558566,	0),
(48,	1,	1761558643,	0,	1761558643,	0),
(49,	1,	1761558707,	131,	1761558838,	0),
(50,	1,	1761559649,	1648,	1761561297,	0),
(51,	1,	1761562498,	528,	1761563026,	0),
(52,	1,	1761566695,	3293,	1761569988,	0),
(53,	1,	1761570043,	1285,	1761571328,	0),
(54,	1,	1761573557,	105,	1761573662,	0),
(55,	1,	1761574229,	1325,	1761575554,	0),
(56,	1,	1761575609,	109,	1761575718,	0),
(57,	1,	1761575759,	70,	1761575829,	0),
(58,	1,	1761575873,	264,	1761576137,	0),
(59,	1,	1761576412,	184,	1761576596,	0),
(60,	1,	1761579370,	584,	1761579954,	0),
(61,	1,	1761580007,	58,	1761580065,	0),
(62,	1,	1761580241,	242,	1761580483,	0),
(63,	1,	1762334189,	5578,	1762339767,	0),
(64,	1,	1762339959,	1463,	1762341422,	0),
(65,	1,	1762342315,	0,	1762342315,	0),
(66,	1,	1762411933,	406,	1762412339,	0);

DROP TABLE IF EXISTS `lh_users_remember`;
CREATE TABLE `lh_users_remember` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `mtime` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_users_session`;
CREATE TABLE `lh_users_session` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_type` int(11) NOT NULL,
  `device_token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_on` int(11) NOT NULL,
  `updated_on` int(11) NOT NULL,
  `expires_on` int(11) NOT NULL,
  `notifications_status` int(11) NOT NULL DEFAULT 1,
  `error` int(11) NOT NULL DEFAULT 0,
  `last_error` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `token` (`token`),
  KEY `device_token_device_type_v2` (`device_token`(191),`device_type`),
  KEY `error` (`error`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `lh_users_setting`;
CREATE TABLE `lh_users_setting` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`,`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_users_setting` (`id`, `user_id`, `identifier`, `value`) VALUES
(1,	1,	'user_language',	'en_EN'),
(2,	1,	'new_dashboard',	'1'),
(3,	1,	'enable_pending_list',	'1'),
(4,	1,	'enable_active_list',	'1'),
(5,	1,	'enable_close_list',	'0'),
(6,	1,	'enable_unread_list',	'0'),
(7,	1,	'enable_mchats_list',	'1'),
(8,	1,	'dwo',	''),
(9,	1,	'new_user_bn',	'0'),
(10,	1,	'new_user_sound',	'0'),
(11,	1,	'dw_filters',	'{}'),
(12,	1,	'ouser_timeout',	'3600'),
(13,	1,	'oupdate_timeout',	'10'),
(14,	1,	'omax_rows',	'50'),
(15,	1,	'ogroup_by',	'none'),
(16,	1,	'ocountry',	'none'),
(17,	1,	'otime_on_site',	''),
(18,	1,	'omap_depid',	'0'),
(19,	1,	'omap_mtimeout',	'30'),
(20,	1,	'online_connected',	'0'),
(21,	1,	'left_list',	'1'),
(22,	1,	'enable_bot_list',	'1'),
(23,	1,	'hide_tabs',	'1'),
(24,	1,	'dark_mode',	'0'),
(25,	1,	'admin_theme_enabled',	'0'),
(26,	1,	'chat_message',	'1'),
(27,	1,	'show_alert_transfer',	'1'),
(28,	1,	'show_alert_chat',	'0'),
(29,	1,	'auto_join_private',	'1'),
(30,	1,	'new_chat_sound',	'1'),
(31,	1,	'sn_off',	'1'),
(32,	1,	'ownntfonly',	'0'),
(33,	1,	'auto_uppercase',	'1'),
(34,	1,	'no_scroll_bottom',	'0'),
(35,	1,	'scroll_load',	'1'),
(36,	1,	'auto_preload',	'0'),
(37,	1,	'trackactivitytimeout',	'-1'),
(38,	1,	'trackactivity',	'0'),
(39,	1,	'dwic',	''),
(40,	1,	'dw_nic',	''),
(41,	1,	'bot_msg_nm',	'3'),
(42,	1,	'bot_notifications',	'0'),
(43,	1,	'show_all_pending',	'1'),
(44,	1,	'speech_language',	''),
(45,	1,	'speech_dialect',	''),
(46,	1,	'auto_accept_mail',	'0'),
(47,	1,	'hide_quick_notifications',	'0'),
(48,	1,	'oattrf_key_1',	''),
(49,	1,	'oattrf_val_1',	''),
(50,	1,	'oattrf_key_2',	''),
(51,	1,	'oattrf_val_2',	''),
(52,	1,	'oattrf_key_3',	''),
(53,	1,	'oattrf_val_3',	''),
(54,	1,	'oattrf_key_4',	''),
(55,	1,	'oattrf_val_4',	''),
(56,	1,	'oattrf_key_5',	''),
(57,	1,	'oattrf_val_5',	''),
(58,	1,	'static_order',	'0'),
(59,	1,	'new_editor',	'0'),
(60,	1,	'column_chats',	'0'),
(61,	1,	'remove_closed_chats',	'0'),
(62,	1,	'remove_closed_chats_remote',	'0'),
(63,	1,	'remove_close_timeout',	'5'),
(64,	1,	'chat_text_rows',	'2'),
(65,	1,	'hide_pers_chat',	'0');

DROP TABLE IF EXISTS `lh_users_setting_option`;
CREATE TABLE `lh_users_setting_option` (
  `identifier` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `class` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `attribute` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `lh_users_setting_option` (`identifier`, `class`, `attribute`) VALUES
('chat_message',	'',	''),
('dwo',	'',	''),
('enable_active_list',	'',	''),
('enable_close_list',	'',	''),
('enable_pending_list',	'',	''),
('enable_unread_list',	'',	''),
('new_chat_sound',	'',	''),
('new_user_bn',	'',	''),
('new_user_sound',	'',	''),
('o_department',	'',	''),
('ocountry',	'',	''),
('ogroup_by',	'',	''),
('omap_depid',	'',	''),
('omap_mtimeout',	'',	''),
('omax_rows',	'',	''),
('otime_on_site',	'',	''),
('oupdate_timeout',	'',	''),
('ouser_timeout',	'',	'');

DROP TABLE IF EXISTS `lh_webhook`;
CREATE TABLE `lh_webhook` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_id_alt` int(11) NOT NULL DEFAULT 0,
  `trigger_id_alt` int(11) NOT NULL DEFAULT 0,
  `bot_id` int(11) NOT NULL,
  `trigger_id` int(11) NOT NULL,
  `disabled` tinyint(1) NOT NULL,
  `configuration` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `delay` int(11) NOT NULL DEFAULT 0,
  `status` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `event_disabled` (`event`,`disabled`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `migrations`;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1,	'0001_01_01_000000_create_users_table',	1),
(2,	'0001_01_01_000001_create_cache_table',	1),
(3,	'0001_01_01_000002_create_jobs_table',	1);

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `sessions`;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2025-11-06 06:59:07
