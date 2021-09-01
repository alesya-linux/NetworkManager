appname="NetwrkMgr"
app="NetworkManager-1.22.6"
PREFIX="/usr/src/tools/$appname"
appPython="$(ls -l /usr/bin/python3 | cut -d'>' -f2 | cut -d' ' -f2)" 

export LIBRARY_PATH="$XORG_PREFIX/lib:$GTK3_PREFIX/lib"
export LD_LIBRARY_PATH="$GTK3_PREFIX/usr/lib:$GTK3_PREFIX/lib:$GTK3_PREFIX/usr/lib64"

if [ ! -x /usr/bin/cc ]; then
  sudo ln -s /usr/bin/gcc /usr/bin/cc
fi &&
sudo perl -MCPAN -e 'install YAML::XS'    &&
sudo perl -MCPAN -e 'install XML::Parser' &&

python3 -m pip install -U pip         &&
python3 -m pip install -U pyaml       &&
python3 -m pip install -U PyGObject   &&

#  pushd intltool && 
#  ./config.sh $appname && 
#  if [ $? -eq 0 ]; then 
#    make
#  else
#    exit 1
#  fi &&  
#  if [ $? -eq 0 ]; then
#    sudo make install
#  else
#    exit 1
#  fi && popd
#  
#  pushd libnl && 
#  ./config.sh $appname && 
#  if [ $? -eq 0 ]; then 
#    make
#  else
#    exit 1
#  fi &&  
#  if [ $? -eq 0 ]; then
#    sudo make install
#  else
#    exit 1
#  fi && popd

#  pushd libcap && 
#  ./config.sh $appname && 
#  if [ $? -eq 0 ]; then 
#    make
#  else
#    exit 1
#  fi &&  
#  if [ $? -eq 0 ]; then
#    sudo make install
#  else
#    exit 1
#  fi && popd

#  pushd libndp && 
#  ./config.sh $appname && 
#  if [ $? -eq 0 ]; then 
#    make
#  else
#    exit 1
#  fi &&  
#  if [ $? -eq 0 ]; then
#    sudo make install
#  else
#    exit 1
#  fi && popd

 pushd elogind && 
 ./config.sh $appname && 
 if [ $? -eq 0 ]; then 
   make
 else
   exit 1
 fi &&  
 if [ $? -eq 0 ]; then
   sudo make install
 else
   exit 1
 fi && popd

if [ -d ../build ]; then
  rm -rfd ../build
fi

if [ "$appPython" != "" ]; then
mkdir -p ../build &&
cp $app.tar.xz ../build &&
cd    ../build &&
tar -xf $app.tar.xz &&
cd $app

# sed '/initrd/d' -i src/meson.build &&
#rm /usr/bin/$appPython &&
#ln -s /usr/local/bin/$appPython /usr/bin/$appPython && 
# python3 -m pip install -U python-libuuid &&
# grep -rl '^#!.*python$' | xargs sed -i '1s/python/&3/' &&

  CXXFLAGS+="-O2 -fPIC"             \
  meson --prefix $PREFIX            \
        --sysconfdir $PREFIX/etc    \
        --localstatedir $PREFIX/var \
        -Djson_validation=false     \
        -Dlibaudit=no               \
        -Dlibpsl=true               \
        -Dnmtui=true                \
        -Dovs=false                 \
        -Dppp=false                 \
        -Dselinux=false             \
        -Dsession_tracking=elogind  \
        -Dudev_dir=/lib/udev        \
        -Dmodem_manager=false       \
        -Dsystemdsystemunitdir=no   \
        -Dsystemd_journal=false     \
        -Dqt=false                  \
  .. 
fi