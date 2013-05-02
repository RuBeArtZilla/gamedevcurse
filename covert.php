<?php
	print "begin<br>";
	$input = "test.txt";
	$output = "output.txt";
	if (file_exists($input))
	{
		$parser = file_get_contents($input);
		$parser = explode("\n", $parser);
		$out = "";
		foreach ($parser as $key => $value)
		{
			$val = explode(" ", $value);
			$out .= ($val[1] % 8) . "|0|" . 
				intval($val[0] * 1000 / 142 - 1500) . "|0|".
				(abs($val[2] + 3) / 40) . "|" . (abs($val[3] + 3) / 20). "|" .
				(1 - (abs($val[3] + 3) / 40)) . "|";
			$out .=  ((abs($val[3] + 3) / 20) > 0.5) ? 1 + (abs($val[3] + 3) / 20) : - (abs($val[3] + 3) / 20);
				
			$out .=	"|0|0|0|0\n";
		}
		print $out;
		file_put_contents($output, $out);
	}
	else 
		print "fuck<br>";



	print "end<br>";
?>