#set -e

myDir="../work-dir/"
if [ ! -d "$myDir" ]; then
	mkdir "$myDir"
fi

cd "$myDir"

apt-get install -y libogg-dev

dpkg -l | grep python2.7-dev  > /dev/null
if [ $? -eq 0 ]; then
	echo "python2.7-dev already exit"
else
	apt-get install -y python2.7-dev
fi

wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py

dpkg -l | grep python-pip  > /dev/null
if [ $? -eq 0 ]; then
	echo "python-pip already exit"
else
	apt-get install -y python-pip
fi

dpkg -l | grep speex  > /dev/null
if [ $? -eq 0 ]; then
	echo "speex already exit"
else
	apt-get install -y speex
fi

pip freeze | grep Pyrex  > /dev/null
if [ $? -eq 0 ]; then
	echo "pyrex already exit"
else
	pip install pyrex
fi

pkg-config --list-all | grep portaudio > /dev/null
if [ $? -eq 1 ]; then
    myFile0="./pa_stable_v19_20140130.tgz"
    if [ ! -f "$myFile0" ]; then
    	wget http://www.portaudio.com/archives/pa_stable_v19_20140130.tgz
    fi
    tar -xzvf pa_stable_v19_20140130.tgz
    ./portaudio/configure&&make clean&&make&&make install
else echo "portaudio already exit "
fi

pip freeze | grep PyAudio  > /dev/null
if [ $? -eq 0 ]; then
	echo "pyaudio already exit"
else
	pip install pyaudio
fi


myFile1="./speex-1.2rc1.tar.gz"
if [ ! -f "$myFile1" ]; then  
	wget http://downloads.xiph.org/releases/speex/speex-1.2rc1.tar.gz
	tar -xzvf speex-1.2rc1.tar.gz  
fi

#myFile2="./pySpeex-0.2.tar.gz"
#if [ ! -f "$myFile2" ]; then  
#	wget http://freenet.mcnabhosting.com/python/pySpeex/pySpeex-0.2.tar.gz
#	tar -xzvf pySpeex-0.2.tar.gz -C ./speex-1.2rc2/
#fi 
#cd ./speex-1.2rc1/pySpeex-0.2/
#python setup.py install
#cd "$myDir"

echo "Deploy Successed"
