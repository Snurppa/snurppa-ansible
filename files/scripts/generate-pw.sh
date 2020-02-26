if [ -n "$1" ]; then
	LENGTH=$1
else 
	LENGTH=16
fi
LC_ALL=C < /dev/urandom tr -cd '[:alnum:]' | head -c$LENGTH
