FROM ubuntu:20.04

LABEL AboutImage "Ubuntu20.04_Fluxbox_NoVNC"

LABEL Maintainer "Apoorv Vyavahare <apoorvvyavahare@pm.me>"

ARG DEBIAN_FRONTEND=noninteractive

#VNC Server Password
ENV	VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
	VNC_TITLE="Vubuntu_Desktop" \
#VNC Resolution(720p is preferable)
	VNC_RESOLUTION="1280x720" \
#VNC Shared Mode (0=off, 1=on)
	VNC_SHARED=0 \
#Local Display Server Port
	DISPLAY=:0 \
#NoVNC Port
	NOVNC_PORT=$PORT \
#Ngrok Token (Strictly use private token if using the service)
	NGROK_AUTH_TOKEN="22rvkgvxGNg8GQ7anRPxVdGvjiy_3n69b4XmHGcFWGjFbTvrG" \
#Locale
	LANG=en_US.UTF-8 \
	LANGUAGE=en_US.UTF-8 \
	LC_ALL=C.UTF-8 \
	TZ="Asia/Bangkok"

COPY . /app/.vubuntu

SHELL ["/bin/bash", "-c"]

RUN rm -f /etc/apt/sources.list && \
#All Official Focal Repos
	bash -c 'echo -e "deb http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb-src http://archive.ubuntu.com/ubuntu/ focal-backports main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu focal partner\ndeb-src http://archive.canonical.com/ubuntu focal partner" >/etc/apt/sources.list' && \
	apt-get update && \
	apt-get install -y \
#Packages Installation
	tzdata \
        xrdp \
	software-properties-common \
	apt-transport-https \
	wget \
	htop \
	git \
	curl \
	vim \
	zip \
	sudo \
	net-tools \
	iputils-ping \
	build-essential \
	python3 \
	python3-pip \
	python-is-python3 \
	#perl \
	#ruby \
	golang \
	#lua5.3 \
	#scala \
	#mono-complete \
	#r-base \
	default-jre \
	default-jdk \
	#clojure \
	#php \
	nodejs \
	npm \
	chromium \
	gnome-terminal \
	gnome-system-monitor \
	gedit \
	vim-gtk3 \
	mousepad \
	pcmanfm \
	terminator \
	supervisor \
	x11vnc \
	xvfb \
	gnupg \
	dirmngr \
	gdebi-core \
	nginx \
	openvpn \
	ffmpeg \
	pluma && \
#Fluxbox
	apt-get install -y /app/.vubuntu/assets/packages/fluxbox.deb && \
#noVNC
	apt-get install -y /app/.vubuntu/assets/packages/novnc.deb && \
	cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
        openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
#Websockify
	npm i websockify && \
#MATE Desktop
	#apt-get install -y \ 
	#ubuntu-mate-core \
	#ubuntu-mate-desktop && \
#XFCE Desktop
	#apt-get install -y \
	#xubuntu-desktop && \
#TimeZone
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone && \

#Chrome
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
	apt install -qqy --no-install-recommends ./google-chrome-stable_current_amd64.deb \
	
#PeaZip
	wget https://github.com/peazip/PeaZip/releases/download/8.1.0/peazip_8.1.0.LINUX.x86_64.GTK2.deb -P /tmp && \
	apt-get install -y /tmp/peazip_8.1.0.LINUX.x86_64.GTK2.deb && \
#Sublime
	curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - && \
	add-apt-repository "deb https://download.sublimetext.com/ apt/stable/" && \
	apt-get install -y sublime-text && \
#Telegram
	wget https://updates.tdesktop.com/tlinux/tsetup.2.9.2.tar.xz -P /tmp && \
	tar -xvf /tmp/tsetup.2.9.2.tar.xz -C /tmp && \
	mv /tmp/Telegram/Telegram /usr/bin/telegram && \
#PowerShell
	wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -P /tmp && \
	apt-get install -y /tmp/packages-microsoft-prod.deb && \
	apt-get update && \
	apt-get install -y powershell && \
#Ngrok
	wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip -P /tmp && \
	unzip /tmp/ngrok-stable-linux-amd64.zip -d /usr/bin && \
	ngrok authtoken $NGROK_AUTH_TOKEN && \
#Wipe Temp Files
	rm -rf /var/lib/apt/lists/* && \ 
	apt-get clean && \
	rm -rf /tmp/*
#google-remote-Desktop
       wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
	

ENTRYPOINT ["supervisord", "-l", "/app/.vubuntu/supervisord.log", "-c"]

CMD ["/app/.vubuntu/assets/configs/supervisordconf"]
