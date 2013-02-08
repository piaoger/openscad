#!/bin/sh

# see doc/translation.txt for more info

help()
{
 echo 'translation.sh [option]'
 echo ' updateall - run updatepot, updatepo, and updatemo in that order'
 echo ' updatepot - update ./po/openscad.pot from source code files'
 echo ' updatepo - update old .po files with new keys from pot/openscad.pot'
 echo ' updatemo - create po/xx/LC_MESSAGES/openscad.mo files from po files'
}

updatepot()
{
 OPTS=
 OPTS=$OPTS'--package-name=OpenSCAD'
 VER=`date +"%Y.%m.%d"`
 OPTS=$OPTS' --package-version='$VER
 OPTS=$OPTS' --default-domain=openscad'
 OPTS=$OPTS' --keyword=_'
 xgettext $OPTS --files-from=./po/POTFILES.in -o ./po/openscad.pot
 sed -i s/"CHARSET"/"UTF-8"/g ./po/openscad.pot
 echo 'updated ./po/openscad.pot from files in po/POTFILES.in'
}

updatepo()
{
 for LANGCODE in `cat ./po/LINGUAS | grep -v "#"`; do
  echo "msgmerge for ./po/$LANGCODE.po from openscad.pot"
	OPTS=
  OPTS='--update --backup=t'
  msgmerge $OPTS ./po/$LANGCODE.po ./po/openscad.pot
 done
}

updatemo()
{
 for LANGCODE in `cat po/LINGUAS | grep -v "#"`; do
  echo creating .mo for language $LANGCODE from $LANGCODE.po
  mkdir -p ./po/$LANGCODE/LC_MESSAGES
  msgfmt -c -v -o ./po/$LANGCODE/LC_MESSAGES/openscad.mo ./po/$LANGCODE.po
  echo created ./po/$LANGCODE/LC_MESSAGES/openscad.mo
 done
}

if [ ! $1 ] ; then
 help
 exit 0
fi

if [ $1 = updatepot ]; then
 updatepot
elif [ $1 = updatepo ]; then
 updatepo
elif [ $1 = updatemo ]; then
 updatemo
elif [ $1 = updateall ]; then
 updatepot && updatepo && updatemo
fi
