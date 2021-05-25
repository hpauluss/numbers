# numbers

Some demonstration scripts for number systems.

The bash script [crea-palindrome-year.sh](crea-palindrome-year.sh) creates an ImageMagick picture of *palindromic years* with markup of prime numbers.

By default, the script runs for the year range 10-2000. If you want to use another range, modify the variables `FIRST` and `LAST` at the beginning of the script.

The script needs access to the perl script [check_prime.pl](check_prime.pl) to analyse whether a year (or any number) is a prime or not.

## Sample calls

The following command will create a matrix of the (default set of) years 10-2000, whereby the years sequence is randomize (i.e. *shuffled*):

    $ crea-palindrome-year.sh -s

The following command will create a matrix of the years 50-500. The years appear in sequential order. The default watermark (*palindrome-anno*) is replaced by the strings *palindrome* and *50-500*:

    $ FIRST=50 LAST=500 crea-palindrome-year.sh  -p 'palindrome\n50-500'

You can have a look at some examples in the [palindromic-years](https://flickr.com/photos/193014685@N06/albums/72157719265366553) folder on Flickr.

## TODO

- Replace fixed width of watermark to size adapted to the number of selected years.




