#!/bin/bash
set -e

if [ -n "$FTP_PASSWORD_FILE" ] && [ -f "$FTP_PASSWORD_FILE" ]; then
    FTP_PASSWORD=$(cat "$FTP_PASSWORD_FILE")
fi

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASSWORD=${FTP_PASSWORD:-ftppassword}

echo "Configuring FTP server..."

if ! id "$FTP_USER" >/dev/null 2>&1; then
    echo "Creating FTP user '$FTP_USER' with group 'www-data'..."
    useradd -s /bin/bash -d /var/www/html -g www-data "$FTP_USER"
else
    echo "FTP user '$FTP_USER' already exists. Ensuring primary group is 'www-data'..."
    usermod -g www-data "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

if [ -n "$FTP_PASV_ADDRESS" ]; then
    echo "Setting passive IP address to $FTP_PASV_ADDRESS..."
    sed -i "s|^pasv_address=.*|pasv_address=${FTP_PASV_ADDRESS}|" /etc/vsftpd.conf
fi

mkdir -p /var/run/vsftpd/empty
mkdir -p /var/www/html

echo "Setting permissions on /var/www/html..."
chown -R "$FTP_USER:www-data" /var/www/html
chmod -R 775 /var/www/html
find /var/www/html -type d -exec chmod g+s {} + 2>/dev/null || true

echo "FTP setup completed successfully!"
echo "Starting vsftpd in the foreground..."

exec /usr/sbin/vsftpd /etc/vsftpd.conf
