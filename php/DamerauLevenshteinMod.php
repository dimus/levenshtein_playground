<?php

class DamerauLevenshteinMod {
	static function distance($ustr1, $ustr2, $block_size=2, $max_distance=10) {
		$a1 = self::utf8_to_unicode_code($ustr1);
		$a2 = self::utf8_to_unicode_code($ustr2);
		return self::distance_ary($a1, $a2, $block_size, $max_distance);
	}
	
	static function utf8_to_unicode_code($utf8_string){
		$expanded = iconv("UTF-8", "UTF-32", $utf8_string);
		$converted =  unpack("L*", $expanded);
		return $converted;
	}
	
	static function distance_ary($ar1, $ar2, $block_size=2, $max_distance=10) {
		$res = distance_utf($ar1, $ar2, $block_size, $max_distance);
		return $res > $max_distance ? null : $res;
	}
}

