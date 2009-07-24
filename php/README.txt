MDL is a modified Damerau-Levenshtein algorithm which calculates edit distance taking in account substitutions, deletions, insertions, one and multiple letter transpositions.

INTRODUCTION

mdl.so provides distance_utf function.

This function takes 2 arrays of integers and calculates editing distance for there arrys, assuming that for example substitution of one integer correpsonds to 1 editing distance. This function works with arrays of integers instead of strings to be able to work with unicode characters. 

Please see example below how to convert utf8 strings into arrays of integers.


INSTALLATION
cd /source_dir
./configure --enable-mdl --with-php-config=/usr/local/bin/php-config
make

copy mdl.so file from modules directory into your php extension modules path, for example into /opt/local/lib/php/extensions/no-debug-non-zts-20060613/

In your php.ini:

* Under 'Dynamic Extensions' add 

extension=mdl.so

* Set extension dir to your standard place for modules, for example:

extension_dir = "/opt/local/lib/php/extensions/no-debug-non-zts-20060613/"


* You can also download the module dynamically from your script with the following function:
dl('mdl.so');

USAGE

To use modified Damerau-Levenshtein algorithm you can write a wrapper similar to this one:

<?php
 
class DamerauLevenshteinMod {

	static function distance($ustr1, $ustr2, $block_size=2, $max_distance=4) {
		if (function_exists('distance_utf')) {
			$a1 = self::utf8_to_int_ary($ustr1);
			$a2 = self::utf8_to_int_ary($ustr2);
			return distance_utf($a1, $a2, $block_size, $max_distance);
		} else return levenshtein( $ustr1, $ustr2 );
	}
 
	static function utf8_to_int_ary($utf8_string){
		$expanded = iconv("UTF-8", "UTF-32", $utf8_string);
		$converted = unpack("L*", $expanded);
		return $converted;
	} 
}