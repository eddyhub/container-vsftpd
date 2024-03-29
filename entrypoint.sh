#!/bin/bash

# ALL environment variables starting with VSFTPD_* are options and should be
# written to /etc/vsftpd/vsftpd.conf

CONFIG_FILE_PATH='/etc/vsftpd/vsftpd.conf'

# generate associative array with default configs taken from the man page
declare -A CONFIGURATION
CONFIGURATION[allow_anon_ssl]="NO"
CONFIGURATION[seccomp_sandbox]="NO"
CONFIGURATION[anon_mkdir_write_enable]="NO"
CONFIGURATION[anon_other_write_enable]="NO"
CONFIGURATION[anon_upload_enable]="NO"
CONFIGURATION[anon_world_readable_only]="YES"
CONFIGURATION[anonymous_enable]="YES"
CONFIGURATION[ascii_download_enable]="NO"
CONFIGURATION[ascii_upload_enable]="NO"
CONFIGURATION[async_abor_enable]="NO"
CONFIGURATION[background]="NO"
CONFIGURATION[check_shell]="YES"
CONFIGURATION[chmod_enable]="YES"
CONFIGURATION[chown_uploads]="NO"
CONFIGURATION[chroot_list_enable]="NO"
CONFIGURATION[chroot_local_user]="NO"
CONFIGURATION[connect_from_port_20]="NO"
CONFIGURATION[debug_ssl]="NO"
CONFIGURATION[delete_failed_uploads]="NO"
CONFIGURATION[deny_email_enable]="NO"
CONFIGURATION[dirlist_enable]="YES"
CONFIGURATION[dirmessage_enable]="NO"
CONFIGURATION[download_enable]="YES"
CONFIGURATION[dual_log_enable]="NO"
CONFIGURATION[force_dot_files]="NO"
CONFIGURATION[force_anon_data_ssl]="NO"
CONFIGURATION[force_anon_logins_ssl]="NO"
CONFIGURATION[force_local_data_ssl]="YES"
CONFIGURATION[force_local_logins_ssl]="YES"
CONFIGURATION[guest_enable]="NO"
CONFIGURATION[hide_ids]="NO"
CONFIGURATION[implicit_ssl]="NO"
CONFIGURATION[listen]="YES"
CONFIGURATION[listen_ipv6]="NO"
CONFIGURATION[local_enable]="NO"
CONFIGURATION[lock_upload_files]="YES"
CONFIGURATION[log_ftp_protocol]="NO"
CONFIGURATION[ls_recurse_enable]="NO"
CONFIGURATION[mdtm_write]="YES"
CONFIGURATION[no_anon_password]="YES"
CONFIGURATION[no_log_lock]="NO"
CONFIGURATION[one_process_model]="NO"
CONFIGURATION[passwd_chroot_enable]="NO"
CONFIGURATION[pasv_addr_resolve]="NO"
CONFIGURATION[pasv_enable]="YES"
CONFIGURATION[pasv_promiscuous]="NO"
CONFIGURATION[port_enable]="YES"
CONFIGURATION[port_promiscuous]="NO"
CONFIGURATION[require_cert]="NO"
CONFIGURATION[require_ssl_reuse]="YES"
CONFIGURATION[run_as_launching_user]="NO"
CONFIGURATION[secure_email_list_enable]="NO"
CONFIGURATION[session_support]="NO"
CONFIGURATION[setproctitle_enable]="NO"
CONFIGURATION[ssl_enable]="NO"
CONFIGURATION[ssl_request_cert]="YES"
CONFIGURATION[ssl_sslv2]="NO"
CONFIGURATION[ssl_sslv3]="NO"
CONFIGURATION[ssl_tlsv1]="YES"
CONFIGURATION[strict_ssl_read_eof]="NO"
CONFIGURATION[strict_ssl_write_shutdown]="NO"
CONFIGURATION[syslog_enable]="NO"
CONFIGURATION[tcp_wrappers]="NO"
CONFIGURATION[text_userdb_names]="NO"
CONFIGURATION[tilde_user_enable]="NO"
CONFIGURATION[use_localtime]="NO"
CONFIGURATION[use_sendfile]="YES"
CONFIGURATION[userlist_deny]="YES"
CONFIGURATION[userlist_enable]="NO"
CONFIGURATION[validate_cert]="NO"
CONFIGURATION[virtual_use_local_privs]="NO"
CONFIGURATION[write_enable]="NO"
CONFIGURATION[xferlog_enable]="NO"
CONFIGURATION[xferlog_std_format]="NO"
 
CONFIGURATION[accept_timeout]="60"
CONFIGURATION[anon_max_rate]="0"
CONFIGURATION[anon_umask]="077"
CONFIGURATION[chown_upload_mode]="0600"
CONFIGURATION[connect_timeout]="60"
CONFIGURATION[data_connection_timeout]="300"
CONFIGURATION[delay_failed_login]="1"
CONFIGURATION[delay_successful_login]="0"
CONFIGURATION[file_open_mode]="0666"
CONFIGURATION[ftp_data_port]="20"
CONFIGURATION[idle_session_timeout]="300"
CONFIGURATION[listen_port]="21"
CONFIGURATION[local_max_rate]="0"
CONFIGURATION[local_umask]="077"
CONFIGURATION[max_clients]="0"
CONFIGURATION[max_login_fails]="3"
CONFIGURATION[max_per_ip]="0"
CONFIGURATION[pasv_max_port]="0"
CONFIGURATION[pasv_min_port]="0"
CONFIGURATION[trans_chunk_size]="0"
 
CONFIGURATION[anon_root]=""
CONFIGURATION[banned_email_file]="/etc/vsftpd.banned_emails"
CONFIGURATION[banner_file]=""
CONFIGURATION[ca_certs_file]=""
CONFIGURATION[chown_username]="root"
CONFIGURATION[chroot_list_file]="/etc/vsftpd.chroot_list"
CONFIGURATION[cmds_allowed]=""
CONFIGURATION[cmds_denied]=""
CONFIGURATION[deny_file]=""
CONFIGURATION[dsa_cert_file]=""
CONFIGURATION[dsa_private_key_file]=""
CONFIGURATION[email_password_file]="/etc/vsftpd.email_passwords"
CONFIGURATION[ftp_username]="ftp"
CONFIGURATION[ftpd_banner]=""
CONFIGURATION[guest_username]="ftp"
CONFIGURATION[hide_file]=""
CONFIGURATION[listen_address]=""
CONFIGURATION[listen_address6]=""
CONFIGURATION[local_root]=""
CONFIGURATION[message_file]=".message"
CONFIGURATION[nopriv_user]="nobody"
CONFIGURATION[pam_service_name]="ftp"
CONFIGURATION[pasv_address]=""
CONFIGURATION[rsa_cert_file]="/usr/share/ssl/certs/vsftpd.pem"
CONFIGURATION[rsa_private_key_file]=""
CONFIGURATION[secure_chroot_dir]="/usr/share/empty"
CONFIGURATION[ssl_ciphers]="DES-CBC3-SHA"
CONFIGURATION[user_config_dir]=""
CONFIGURATION[user_sub_token]=""
CONFIGURATION[userlist_file]="/etc/vsftpd.user_list"
CONFIGURATION[vsftpd_log_file]="/var/log/vsftpd.log"
CONFIGURATION[xferlog_file]="/var/log/xferlog"

# set the values passed by the environment
for i in ${!VSFTPD_@}; do
	parameter="${!i}"
	option="${i,,}"
	option="${option#vsftpd_}"
	CONFIGURATION[${option}]="${parameter}"
done

for option in "${!CONFIGURATION[@]}"; do
	if [ -n "${CONFIGURATION[$option]}" ]; then
		echo "${option}=${CONFIGURATION[$option]}" >> "${CONFIG_FILE_PATH}"
	fi
done

# use admin as default user if none has been specified:
if [ -z "$FTP_USER" ]; then
    export FTP_USER='admin'
fi

if [ -z "${FTP_USER_HOME}" ]; then
	export FTP_USER_HOME="/home/${FTP_USER}"
fi

if ! id -u "${FTP_USER}" > /dev/null 2>&1; then
		useradd -m -d "${FTP_USER_HOME}" -U -s /sbin/nologin "${FTP_USER}"
fi

chown -R "${FTP_USER}:${FTP_USER}" "${FTP_USER_HOME}"

# generate passwort if none has been specified:
if [ -z "$FTP_PASSWORD" ]; then
	export FTP_PASSWORD=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c16)
fi

# set password for user
echo -e "${FTP_PASSWORD}\n${FTP_PASSWORD}" | passwd "${FTP_USER}"

echo -e "
#####################################################
#                                                   #
#    Container image: eddyhub/container-vsftpd      #
#    https://github.com/eddyhub/container-vsftpd    #
#    https://gitlab.com/eddyhub/container-vsftpd    #
#                                                   #
#####################################################

Server settings:
================
- FTP user: ${FTP_USER}
- FTP password: ${FTP_PASSWORD}
- FTP user home dir: ${FTP_USER_HOME}
"

touch "${CONFIGURATION[vsftpd_log_file]}"
tail -f "${CONFIGURATION[vsftpd_log_file]}" &
vsftpd $CONFIG_FILE_PATH

