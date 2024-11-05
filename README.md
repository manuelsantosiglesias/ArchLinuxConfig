# ArchLinux Configuraciones

Lista de configuraciones de ArchLinux una vez instalado el sistema, configurado el bspwn e instalado el tema 

# Instalación de dotfiles

Copia de los comandos de instalación de los dotfiles de gh0stzk

### 💾 Installation:
The installer only works for **ARCH** Linux, and based distros.

<b>Open a terminal in HOME</b>
- **First download the installer**
```sh
curl https://raw.githubusercontent.com/gh0stzk/dotfiles/master/RiceInstaller -o $HOME/RiceInstaller

# Maybe you want a short url??

curl -L https://is.gd/gh0stzk_dotfiles -o $HOME/RiceInstaller
```
- **Now give it execute permissions**
```sh
chmod +x RiceInstaller
```
- **Finally run the installer**
```sh
./RiceInstaller
```

# Selecion de temas

```
Por defecto con Alt + espacio podemos seleccionar temas
Con Windows + Alt + W tenemos el selector de temas
Con F1 la ayuda
Con Windows + Enter abrimos terminal
Con Windows + q cerramos terminal
```

Más adelante cambiaremos shortcuts que nos chocan

# Arrancar Vmware-tools al inicio

Queremos cargar las vmware tools al iniciar
```
sudo echo vmware-user >> .config/bspwm/bspwmrc
```

Queremos refrescar por este motivo también, esperamos 5 segundos para ello
```
(sleep 3 && if [ ! -f /tmp/bspwm-refreshed ]; then
    bspc wm -r && rm /tmp/bspwm-refreshed
    touch /tmp/bspwm-refreshed
fi) &
```

# Cambiar algunos shortcuts

El problema de vmware es que chocan algunos shortcuts con las apps que tengo en windows
Primero la tecla windows tengo que configurar siempre activa en el armoury crate, que a veces el soft la desactiva sin razón

locate sxhkd
/home/s4ints/.config/bspwm/src/config/sxhkdrc

nano sxhkdrc

- **Cambiar el tema de la w a la q y la tecla alt por control**
```
# Random wallpaper
ctrl + shift + q
        WallSelect
```
- **Cerrar terminal de la q a la w (me gusta así personalmente) y reload con ctrl**
```
#|||----- Bspwm hotkeys -----|||#

# Reload BSPWM
ctrl + shift + r
        bspc wm -r

# close and kill
super + {_,shift + }w
        bspc node -{c,k}
```

- **Clipboard con control**
```
# Clipboard
super + ctrl + c
        OpenApps --clipboard
```

- **Terminal asignación con control**
```
#Terminal Selector
super + ctrl + t
        Term --selecterm
```

- **Selector de app**
```
# rofi show
super + d
        rofi -show run
```

- **Shortcuts de burpsuite y chrome (Instalar ambos)**
```
# Google-Chrome

super + ctrl + g
	google-chrome

# Open Burpsuite Professional

super + ctrl + b
	gksudo burp
```

- **Finalmente:**
    Abrimos con: windows + enter
    Cerramos con: windows + w
    Recargamos con: ctrl + shift + r
    Cambiamos tema con: ctrl + shift + q
    Abrir launcher: Windows + d

Dejaré copia del archivo en files, no deberían pisarseme los shortcuts del anfitrion y la máquina virtual

- **Modificar menú**
```
# jgmenu
~button3
  xqp 0 $(xdo id -N Bspwm -n root) && jgmenu --csv-file=~/.config/bspwm/src/config/jgmenu.txt --config-file=~/.config/bspwm/src/config/jgmenurc
```

TODO: Arreglar ctrl + shift + return

# Añadir 10 desktop

~/.config/bspwm

```
bspc monitor "$monitor" -d '1' '2' '3' '4' '5' '6' '7' '8' '9' '0'
```

- **comprobar que en ~/.config/bspwm/config/sxhkdrc aparece así**
```
# focus or send to the given desktop
super + {_,alt + }{1-9,0}
     bspc {desktop -f,node -d} '^{1-9,10}'
```

Reiniciamos y deberían aparecer los 10 escritorios

# Ver tema seleccionado actual

cat ~/.config/bspwm/.rice

cat ~/.config/bspwm/rice/$THEME/Theme.sh -> Configuración actual del tema


# Configurar Settarget, mkt, extractports

Añadir a ~/.zshrc el siguiente contenido

```
..............................
# FUNCTIONS

function mkt(){
    mkdir {nmap,content,exploits,scripts}
}

# Extract nmap information
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp
}

..............................
```
Por defecto viene target en el tema, si queremo settarget añadir a la lista y crear directorios

```
# Settarget
function settarget() {
    local FILE=/tmp/target

    if [ $# -eq 0 ]; then
        if [ -e "$FILE" ]; then
            cat "$FILE"
        else
            echo "No Target"
        fi
    elif [ "$1" = "reset" ]; then
        rm -f "$FILE" && echo "Target reset." || echo "No target to reset."
    elif [ $# -eq 1 ]; then
        echo "$1" > "$FILE"
    elif [ $# -eq 2 ]; then
        echo "$1 $2" > "$FILE"
    else
        echo "Usage: settarget [IP] [NAME] | settarget [IP] | settarget reset"
    fi
}
```

mkdir ~/.config/bin
touch /tmp/target

Una vez realizado todo esto, abrimos terminal y probamos los comandos. (settarget no aparecerá en la polibar, pero creará el archivo)

# Añadir Target a la polibar
~/.config/bspwm/src/show_target.sh
```
#!/bin/sh

if [ -f /tmp/target ]; then
    ip_target=$(awk '{print $1}' /tmp/target)
    name_target=$(awk '{print $2}' /tmp/target)

    if [ "$ip_target" ] && [ "$name_target" ]; then
        echo "%{F#00C8FF}🍪%{F#00C8FF} $ip_target - $name_target"
    elif [ $(wc -w < /tmp/target) -eq 1 ]; then
        echo "%{F#00C8FF}🍪%{F#00C8FF} $ip_target"
    else
        echo "%{F#D32F2F}😱 %{u-}%{F#D32F2F} No target"
    fi
else
    echo "%{F#D32F2F}🍬 %{u-}%{F#D32F2F} No target"
fi
```
chmod +x show_target.sh

~/.config/bspwm/rices/yael/modules.ini -> cambiar por tema en uso
```
#####################################################

[module/show_target]
type = custom/script
exec = ~/.config/bspwm/src/show_target.sh
interval = 3

format = <label>
label = "%output%"
```

Añadir modulo a la polybar

~/.config/bspwm/rices/yael/config.ini
```
modules-right =  mpd sep sep mpd_control sep sep pulseaudio sep bluetooth sep battery sep sep filesystem sep sep memory_bar sep sep cpu_bar sep sep show_target sep sep network sep sep mplayer usercard sep sep updates sep sep power sep sep tray sep sep date
```
Se añade show_target (configurar al gusto y posición)


# Añadir VPN a la polibar

~/.config/bspwm/src/ethernet_status.sh
Instalar sudo pacman -S net-tools para ifconfig
```
#!/bin/sh
if ip link show tun0 > /dev/null 2>&1; then
    IP=$(ifconfig tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    if echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        echo "%{F#8bcc6a} %{F#87CEEB}$IP%{u-}"
    else
        echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
    fi
else
    echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
fi

```

Sin net-tools
```
#!/bin/sh
if ip link show tun0 > /dev/null 2>&1; then
    IP=$(ip addr show tun0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    if echo "$IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
        echo "%{F#8bcc6a} %{F#87CEEB}$IP%{u-}"
    else
        echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
    fi
else
    echo "%{F#8bcc6a} %{F#87CEEB}NOIP%{u-}"
fi

```

chmod +x ethernet_status.sh
(Cambiar ens33 en caso de ser otro el adaptador)

~/.config/bspwm/rices/yael/modules.ini
```
#####################################################

[module/ethernet_status]
type = custom/script
exec = ~/.config/bspwm/src/ethernet_status.sh
interval = 3

format = <label>
label = "%output%"
click-left = OpenApps --netmanager
```

Añadir modulo a la polybar

~/.config/bspwm/rices/yael/config.ini
```
modules-left = launcher sep sep bspwm sep ethernet_status
```

Por último ahora aparecería sin puntos la IP, para ello

sudo pacman -S ttf-nerd-fonts-symbols

# Instalación de blackarch

```
curl -O https://blackarch.org/strap.sh
echo 76363d41bd1caeb9ed2a0c984ce891c8a6075764 strap.sh | sha1sum -c
chmod +x strap.sh
sudo ./strap.sh
sudo pacman -Syu
```

Comandos Pacman
```
To list all of the available tools, run
sudo pacman -Sgg | grep blackarch | cut -d' ' -f2 | sort -u

To install a category of tools, run
sudo pacman -S blackarch-<category>

To see the blackarch categories, run
sudo pacman -Sg | grep blackarch

To search for a specific package, run
pacman -Ss <package_name>
```

# Instalación de herramientas generales


📒 Notas finales
-----
Instalar varias herramientas; añadir listado de herramientas comunes nmap, crackmapexec, bloodhound, etc...
