
DIRPATH='$HOME/bin'
#~/binがない場合は作成
if [ ! -e $DIRPATH ] ; then
mkdir $DIRPATH
fi

#補完関数の置き場所に_checkのシンボリックリンクを貼る
ln -s _check /usr/local/share/zsh/site-functions

#$HOME/binにcheckのシンボリックリンクを貼る
chmod a+x ../check
ln -s ../check $HOME/bin


cat << EOF >> \$HOME/.zshrc
#checkコマンドによる書き込み
##補完機能の有効化
autoload -U compinit
compinit -u

##~/binをPATHに読み込む
export PATH=$PATH:\$HOME/bin
EOF

source $HOME/.zshrc