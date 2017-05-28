source ~/.bashrc
if [ "$HOSTNAME" == "bwrcrdsl-2.EECS.Berkeley.EDU" ]; then
    exec fish
else
    printf 'not on bwrcrdsl-2, using bash\n'
fi
