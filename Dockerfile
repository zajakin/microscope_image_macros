FROM debian:buster-slim
# docker run --rm -it debian:buster-slim bash
RUN sed -i 's/main$/main contrib non-free non-free-firmware/' /etc/apt/sources.list && \
  env DEBIAN_FRONTEND=noninteractive apt-get update && \
	env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils whiptail && \
	env DEBIAN_FRONTEND=noninteractive apt-get upgrade -y --no-install-recommends && \
	env DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y --no-install-recommends && \
	env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
		python3 python3-pip python3-setuptools python3-dev python3-venv python3-wheel \
		locales sudo mc curl wget htop nginx-light libnginx-mod-http-auth-pam \
		ssh mosh tmux supervisor bash-completion gpm bzip2 geany unzip \
		at-spi2-core lxqt-policykit dbus-x11 firefox-esr gpicview fonts-firacode \
		build-essential gfortran libgfortran-8-dev liblapack-dev libblas-dev libopenblas-dev \
		libxml2-dev libjpeg-dev libcurl4-openssl-dev libssl-dev zlib1g-dev \
		lxde-core lxlauncher lxterminal lxmenu-data lxtask xarchiver \
		tigervnc-standalone-server tigervnc-common tigervnc-xorg-extension novnc xbase-clients \
		gdebi-core r-base-core git gnumeric && \
    pip3 install wheel importlib-metadata && \
    pip3 install Deep-Tumour-Spheroid && \
	  apt-get autoremove -y && \
	  apt-get autoclean -y
RUN echo 'gtk-theme-name="Raleigh"\ngtk-icon-theme-name="nuoveXT2"\n' > /etc/skel/.gtkrc-2.0 && \
	mkdir -p /etc/skel/.config/gtk-3.0 && \
	echo '[Settings]\ngtk-theme-name="Raleigh"\ngtk-icon-theme-name="nuoveXT2"\n' > /etc/skel/.config/gtk-3.0/settings.ini && \
	mkdir -p /etc/skel/.config/pcmanfm/LXDE && \
	echo '[*]\nwallpaper_mode=stretch\nwallpaper_common=1\nwallpaper=/usr/share/lxde/wallpapers/lxde_blue.jpg\n' > /etc/skel/.config/pcmanfm/LXDE/desktop-items-0.conf && \
	mkdir -p /etc/skel/.config/libfm && \
	echo '[config]\nquick_exec=1\nterminal=lxterminal\n' > /etc/skel/.config/libfm/libfm.conf && \
	mkdir -p /etc/skel/.config/openbox/ && \
	echo '<?xml version="1.0" encoding="UTF-8"?>\n<theme>\n  <name>Clearlooks</name>\n</theme>\n' > /etc/skel/.config/openbox/lxde-rc.xml && \
	mkdir -p /etc/skel/.config/ && \
	echo '[Added Associations]\ntext/plain=mousepad.desktop;\n' > /etc/skel/.config/mimeapps.list && \
	ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
  sed -i 's@^<table>.*</table>@@' /usr/lib/python2.7/dist-packages/supervisor/ui/status.html && \
  sed -i 's@<div id="header">@<table><tr align="center"><td><a href="/home/"><h1>Home directory</h1></a></td><td><a href="/public/"><h1>Public directory</h1></a></td></tr><tr align="center" valign="bottom"><td><a href="/n/vnc.html"><h1>noVNC</h1></a></td></tr><tr align="center"><td STYLE="border-style:solid; border-width:1px 1px 1px 1px"><a href="https://github.com/zajakin/"><h3>Created by Pawel Zayakin</h3></a></td></tr></table><div id="header" hidden="">@' /usr/lib/python2.7/dist-packages/supervisor/ui/status.html && \
  mkdir -p /var/log/nginx && \
  echo '@include common-auth' > /etc/pam.d/nginx && \
  usermod -aG shadow www-data && \
  ln -sfn /home/fiji/public /usr/share/novnc/public && \
  ln -sfn /home/fiji /usr/share/novnc/home && \
  sed -i "s/UI.initSetting('resize', 'off');/UI.initSetting('resize', 'remote');/g" /usr/share/novnc/app/ui.js && \
	useradd -G sudo -d /home/fiji -s /bin/bash -m fiji -U fiji && \
	echo "fiji:fijipass" | chpasswd && \
	mkdir -p /home/fiji/.vnc && \
	echo fijipass | vncpasswd -f > /home/fiji/.vnc/passwd && \
	cp -r -n /etc/skel/.[!.]* /home/fiji && \
  chown -R fiji /home/fiji && \
	xhost +si:localuser:root
COPY supervisor/* /etc/supervisor/conf.d/
COPY nginx.conf /etc/nginx/nginx.conf
ENV NOTVISIBLE "in users profile"
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.utf8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.utf8 UTF-8/' /etc/locale.gen && \
	sed -i -e 's/# lv_LV.UTF-8 UTF-8/lv_LV.utf8 UTF-8/' /etc/locale.gen && \
	locale-gen && \
	mkdir -p /run/sshd /var/log/supervisor && \
	echo "export VISIBLE=now" >> /etc/profile
USER fiji:fiji
RUN mkdir -p /home/fiji/spheroids/ /home/fiji/public && \
  cd /home/fiji && \
  wget -nv https://downloads.imagej.net/fiji/latest/fiji-latest-linux-arm64-jre.zip && \
  unzip fiji-latest-linux-arm64-jre.zip && \
	rm fiji-latest-linux-arm64-jre.zip
  ln -sfn /usr/local/bin/deep-tumour-spheroid /home/fiji/spheroids/deep-tumour-spheroid
COPY spheroids/* /home/fuji/spheroids/
CMD ["/usr/bin/supervisord"]
