#! /bin/bash
#
# crea-palindrome-year.sh
#
# create picture of palindromatic years with markup of prime numbers,
# using ImageMagick tools

MY_PROG=$( basename $0 )


##----- INITIALISE VARIABLES ------------------------------------##

IMAGE_FILE=palindrome-year.png     # final output
TEMP_DIR=/tmp/palindrome           # temporary folder
TEMP_DIR_PICT=$TEMP_DIR/pict       # picture folder in temporary folder

# files containing palindromic numbers
# palindromic numbers only
LIST_PALINDROME=$TEMP_DIR/list-palindrome-anno.txt
# palindromic numbers + prime number indicator
LIST_PALINDROME_PRIME=$TEMP_DIR/list-palindrome-anno-v2.txt

# range of years to be analysed
FIRST=${FIRST:=10}   # first year
LAST=${LAST:=2000}   # last year

mkdir -p $TEMP_DIR_PICT


##----- CHECK REQUIRED PROGRAMS ---------------------------------##

for f in convert shuf rev montage composite mogrify
do
    zz=$( which "$f" )
    if [ -z "$zz" ]; then
	progMissing+=("$f")
    fi
done

if [ "${#progMissing[@]}" -gt 0 ]; then
    echo "ERROR: programs(s) NOT FOUND:" ${progMissing[*]}
    exit 1
fi


##----- HELP FUNCTIONS ------------------------------------------##


function version()
{
   (
     echo "$MY_PROG (V1.0: 01-Jul-2019)"
     echo "bash script by hpauluss"
   ) >&2
   exit 0
}

function usage()
{
   (
      echo -e "Usage:      Create palindromic image\n"
      echo -e 'Call:       '$MY_PROG' [-options]\n'
      echo -e "Options:    -h: help"
      echo -e "            -s: shuffle"
      echo -e "            -v: version\n"

   ) >&2
   exit 0
}

# If you do not want to shuffle the list of years,
# cat will be used instead of shuf
PROCESS_YEARS=cat

# process options
while getopts "hvs" opt; do
   case $opt in
     h ) usage; exit 0 ;;
     v ) version; exit 0 ;;
     s ) PROCESS_YEARS=shuf ;;
     * ) usage; exit 1 ;;
   esac
done
shift $(($OPTIND - 1))


##----- RESET VARIABLES -----------------------------------------##

# resetting variables is required to avoid
# conflicts with previous versions of the
# images created

rm $IMAGE_FILE
rm -f $TEMP_DIR_PICT/*


##----- FUNCTIONS -----------------------------------------------##


function list_palindromic_years () {

    FIRST=$1
    LAST=$2
    
    for i in $( seq $FIRST $LAST);
    do
	anno=$i
	annoREV=$( echo $anno | rev )
	if [ "$anno" == "$annoREV" ]; then
	    echo $anno
        fi
    done > $LIST_PALINDROME

}


function mark_primes () {

    cat $LIST_PALINDROME |
	while read f;
	do
	    res=$( echo $f | check_prime.pl ) ;
	    echo $f $res;
	done > $LIST_PALINDROME_PRIME
    
}


function crea_images () {

    # create images from palindromic year numbers

    cat $LIST_PALINDROME_PRIME |
	# head -30 |
	$PROCESS_YEARS |
	while read f p;
	do
	    echo '    ===' $f;
	    if [ "$p" == "1" ]; then
		BACKGROUND=SkyBlue
	    else
		BACKGROUND=LightSteelBlue1
	    fi
	    let COUNTER++;
	    f2=$( printf "%4.4d_%s" $COUNTER $f) ;
	    convert \
		-font Times-New-Roman \
		-pointsize 120 \
		-size 340x150 \
		-background $BACKGROUND \
		-gravity center \
		-bordercolor red -border 5 \
		-density 90 label:$f $TEMP_DIR_PICT/palindrome-$f2.png;
	done
    
}


function crea_montage () {

    # create montage of all palindrome images
    
    montage -page 80x80 \
	    +polaroid \
            +set label \
            -geometry '100x100>+2+2' \
            $TEMP_DIR_PICT/palindrome*.png $TEMP_DIR_PICT/montage2.png

}


function crea_watermark () {

    # creat watermark image

    convert -size 900x250 xc:transparent \
	    -pointsize 120 -font Times-New-Roman-Bold \
	    -gravity center \
	    -annotate +0+0 "palindrome-anno" $TEMP_DIR_PICT/logo_palindrome.png

}


function fuse_wm_montage () {

    # fuse watermark image and montage image

    composite -dissolve 15% \
	      -bordercolor white -border 30 \
	      -gravity center \
	      -quality 100 \
	      $TEMP_DIR_PICT/logo_palindrome.png \
	      $TEMP_DIR_PICT/montage2.png $IMAGE_FILE

}


function add_borders () {
    
    # add borders to final image
    
    mogrify -bordercolor black -border 2 $IMAGE_FILE
    mogrify -bordercolor white -border 50 $IMAGE_FILE

}


function do_main () {

    echo ">>> LIST PALINDROMIC YEARS: $FIRST -- $LAST"
    list_palindromic_years $FIRST $LAST

    echo '>>> MARK PRIMES'
    mark_primes

    echo '>>> CREATE IMAGES'
    crea_images

    echo '>>> CREATE MONTAGE'
    crea_montage

    echo '>>> CREATE WATERMARK'
    crea_watermark

    echo '>>> FUSE WATERMARK WITH MONTAGE'
    fuse_wm_montage

    echo '>>> ADD BORDERS'
    add_borders
    
}


##----- MAIN ----------------------------------------------------##

do_main

exit 0
