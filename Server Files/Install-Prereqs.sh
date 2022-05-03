dpkg --add-architecture i386
apt update -qq -y
apt upgrade -y -qq
apt install software-properties-common curl gnupg2 -y -qq
# Install wine
# Add repository keys
curl https://dl.winehq.org/wine-builds/winehq.key | apt-key add -
curl https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/Release.key | apt-key add -
# Add repositories
apt-add-repository non-free
apt-add-repository "deb https://dl.winehq.org/wine-builds/debian/ bullseye main"
apt-add-repository "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11 ./"
apt-get update -qq

# Install PowerShell
# Install system components
apt install apt-transport-https -y
# Import the public repository GPG keys
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# Register the Microsoft Product feed
sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'
# Install PowerShell
apt update
apt install powershell -y

# Install winetricks
apt-get install --install-recommends winehq-stable=6.0.2~bullseye-1 wine-stable-i386=6.0.2~bullseye-1  \
wine-stable-amd64=6.0.2~bullseye-1 wine-stable=6.0.2~bullseye-1 xvfb cabextract -qq -y
curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks
chmod +x /usr/local/bin/winetricks

# Winetricks configuration
curl https://raw.githubusercontent.com/Devidian/docker-spaceengineers/master/winetricks.sh > winetricks.sh
chmod +x ./winetricks.sh
./winetricks.sh
# Not needed after running
rm -f ./winetricks.sh

# Install Steam
sh -c 'echo steam steam/question select "I AGREE" | debconf-set-selections'
sh -c 'echo steam steam/license note "" | debconf-set-selections'
apt install steamcmd libfaudio0:i386 libfaudio0 -qq -y

# Remove stuff we do not need anymore to reduce docker size
apt remove gnupg2 curl software-properties-common -qq -y
apt autoremove -qq -y
apt clean autoclean -qq
rm -rf /var/lib/{apt,dpkg,cache,log}/

# Update Steam
/usr/games/steamcmd +login anonymous +quit