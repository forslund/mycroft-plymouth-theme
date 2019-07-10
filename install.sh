# Set global values
STEPCOUNTER=false # Changes to true if user choose to install Tux Everywhere
YELLOW='\033[1;33m'
LIGHT_GREEN='\033[1;32m'
LIGHT_RED='\033[1;31m'
NC='\033[0m' # No Color

function install {
    printf "\033c"
    header "MYCROFT PLYMOUTH THEME" "$1"
    
    # Here we check if OS is supported
    # More info on other OSes regarding plymouth: http://brej.org/blog/?p=158
    if [ -d "/usr/share/plymouth/themes/" ]; then
    # Control will enter here if $DIRECTORY exists.
        check_sudo

        # Want the folder where the script is (can't use pwd since that gives us from where the script where run, which often is tux-install but not when we run locally)
        DIR=${BASH_SOURCE}
        DIR=${DIR%"install.sh"}
        sudo cp -r $DIR/src /usr/share/plymouth/themes/
        sudo rsync -a /usr/share/plymouth/themes/src/ /usr/share/plymouth/themes/mycroft-plymouth-theme/
        #sudo mv /usr/share/plymouth/themes/src/ /usr/share/plymouth/themes/mycroft-plymouth-theme/
        sudo rm -r /usr/share/plymouth/themes/src
        # Then we can add it to default.plymouth and update update-initramfs accordingly
        sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/mycroft-plymouth-theme/mycroft-plymouth-theme.plymouth 100;
        printf "\033c"
        header "MYCROFT PLYMOUTH THEME" "$1"
        printf "${YELLOW}Below you will see a list with all themes available to choose MYCROFT in the\n"
        sudo update-alternatives --config default.plymouth;
        printf "${YELLOW}Updating initramfs. This could take a while.${NC}\n"
        sudo update-initramfs -u;
        printf "\033c"
        header "MYCROFT PLYMOUTH THEME" "$1"
        printf "${LIGHT_GREEN}MYCROFT successfully moved in as your new Boot Logo.${NC}\n"
    else
        printf "\033c"
        header "MYCROFT PLYMOUTH THEME" "$1"
        printf "${LIGHT_RED}Couldn't find the Plymouth themes folder.${NC}\n"   
        echo "Check out our website for manual instructions where you can comment questions and solutions:"
        echo "https://tux4ubuntu.org"
        echo ""
        echo "Otherwise, read the instructions more carefully before continuing :)"
    fi
    
    echo ""
    read -n1 -r -p "Press any key to continue..." key
    exit
}

function uninstall { 
    printf "\033c"
    header "MYCROFT PLYMOUTH THEME" "$1"
    printf "${LIGHT_RED}Really sure you want to uninstall MYCROFT BOOT THEME from your boot screen"
    printf "(Plymouth)?${NC}\n"
    echo ""
    echo "(Type 1 or 2, then press ENTER)"            
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) 
                printf "\033c"
                header "MYCROFT PLYMOUTH THEME" "$1"
                sudo rm -rf /usr/share/plymouth/themes/mycroft-plymouth-theme
                printf "\033c"
                header "MYCROFT PLYMOUTH THEME" "$1"
                echo "If you have more than one theme, choose below which one you want as default."
                echo "on boot now when Tux is removed."
                echo ""
                read -n1 -r -p "Press any key to continue..." key
                sudo update-alternatives --config default.plymouth;
                echo "Updating initramfs. This could take a while."
                sudo update-initramfs -u;
                printf "\033c"
                sudo sed -i 's_background: #000;_background: #2c001e url(resource:///org/gnome/shell/theme/noise-texture.png);_g' /usr/share/gnome-shell/theme/ubuntu.css
                sudo sed -i 's_background-color: #2f343f;_background-color: #dd4814;_g' /usr/share/gnome-shell/theme/ubuntu.css
                sudo sed -i 's_border-right: 2px solid #2f343f;_border-right: 2px solid #dd4814;_g' /usr/share/gnome-shell/theme/ubuntu.css
                header "MYCROFT PLYMOUTH THEME" "$1"
                echo "Tux is successfully removed from your boot."
                printf "${LIGHT_GREEN}MYCROFT Boot Logo theme is successfully uninstalled.${NC}\n"
                break;;
            No )
                printf "\033c"
                header "MYCROFT PLYMOUTH THEME" "$1"
                echo "Awesome! Tux smiles and gives you a pat on the shoulder."
            break;;
        esac
    done
    echo ""
    read -n1 -r -p "Press any key to continue..." key
    exit
}

function header {
    var_size=${#1}
    # 80 is a full width set by us (to work in the smallest standard terminal window)
    if [ $STEPCOUNTER = false ]; then
        # 80 - 2 - 1 = 77 to allow space for side lines and the first space after border.
        len=$(expr 77 - $var_size)
    else   
        # "Step X/X " is 9
        # 80 - 2 - 1 - 9 = 68 to allow space for side lines and the first space after border.
        len=$(expr 68 - $var_size)
    fi
    ch=' '
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    printf "║"
    printf " ${YELLOW}$1${NC}"
    printf '%*s' "$len" | tr ' ' "$ch"
    if [ $STEPCOUNTER = true ]; then
        printf "Step "${LIGHT_GREEN}$2${NC}
        printf "/5 "
    fi
    printf "║\n"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo ""
}

function check_sudo {
    if sudo -n true 2>/dev/null; then 
        :
    else
        printf "Oh, MYCROFT will ask below about sudo rights to copy and install everything...\n\n"
    fi
}

function goto_tux4ubuntu_org {
    echo ""
    printf "${YELLOW}Launching website in your favourite browser...${NC}\n"
    x-www-browser https://tux4ubuntu.org/portfolio/plymouth &
    echo ""
    sleep 2
    read -n1 -r -p "Press any key to continue..." key
    exit
}

clear
header "MYCROFT PLYMOUTH THEME" "$1"
install $1
sleep 1
