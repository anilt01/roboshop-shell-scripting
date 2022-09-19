statuscheck() {
if [ $? -eq 0 ];
then
echo -e status= "\e[32mSUCCESS\e[0m"
else
echo -e status= "\e[31mFAILURE\e[0m"
exit 1
fi
}