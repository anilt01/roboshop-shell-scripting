ID=$ (id -u)
if [ id -ne 0 ]; then
  echo "you should run this script as a root user or with sudo privileges"
fi

StatusCheck() {
if [ $? -eq 0 ];
then
echo -e status= "\e[32mSUCCESS\e[0m"
else
echo -e status= "\e[31mFAILURE\e[0m"
exit 1
fi
}