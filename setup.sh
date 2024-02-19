ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa_$(hostname)

mkdir .bashrc.d
touch .bashrc.d/alias
alias_file="~/.bashrc.d/alias.bashrc"


install="sudo dnf install"

$install neovim
$install tmux
echo "alias vim='nvim'" >> $alias_file

$install git
$install ripgrep
$install fd-find
$install delta
$install bat
$install xclip
echo "alias clip='xclip -selection c'" >> $alias_file

# languge servers
$install python3-pip
pip install pyright
