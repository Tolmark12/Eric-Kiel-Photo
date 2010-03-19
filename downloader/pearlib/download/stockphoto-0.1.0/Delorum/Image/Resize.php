<?php
/**
 * PHP class resizing images
 * Delorum Framework
 *
 * LICENSE
 *
 * This source file is subject to the new BSD license that is bundled
 * with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://framework.delorum.com/license/new-bsd
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@delorum.com so we can send you a copy immediately.
 *
 * @category   Delorum
 * @package    Delorum
 * @copyright  Copyright (c) 2009 Delorum Inc. (http://www.delorum.com)
 * @license    http://framework.delorum.com/license/new-bsd     New BSD License
 * @version    1.0
*/

class Delorum_Image_Resize {

    private $errmsg;
    private $error;
    private $format;
    private $fileName;
    public $imageMeta;
    private $currentDimensions;
    private $newDimensions;
    private $newImage;
    private $oldImage;
    private $workingImage;
    private $percent;
    private $maxWidth;
    private $maxHeight;


    public function __construct($fileName) {
        //make sure the GD library is installed
    	if(!function_exists("gd_info")) {
        	echo 'You do not have the GD Library installed.  This class requires the GD library to function properly.' . "\n";
        	echo 'visit http://us2.php.net/manual/en/ref.image.php for more information';
        	exit;
        }
    	//initialize variables
        $this->errmsg               = '';
        $this->error                = false;
        $this->currentDimensions    = array();
        $this->newDimensions        = array();
        $this->fileName             = $fileName;
        $this->imageMeta			= array();
        $this->percent              = 100;
        $this->maxWidth             = 0;
        $this->maxHeight            = 0;

        //check to see if file exists
        if(!file_exists($this->fileName)) {
            $this->errmsg = 'File not found';
            $this->error = true;
        }
        //check to see if file is readable
        elseif(!is_readable($this->fileName)) {
            $this->errmsg = 'File is not readable';
            $this->error = true;
        }

        //if there are no errors, determine the file format
        if($this->error == false) {
            //check if gif
            if(stristr(strtolower($this->fileName),'.gif')) $this->format = 'GIF';
            //check if jpg
            elseif(stristr(strtolower($this->fileName),'.jpg') || stristr(strtolower($this->fileName),'.jpeg')) $this->format = 'JPG';
            //check if png
            elseif(stristr(strtolower($this->fileName),'.png')) $this->format = 'PNG';
            //unknown file format
            else {
                $this->errmsg = 'Unknown file format';
                $this->error = true;
            }
        }

        //initialize resources if no errors
        if($this->error == false) {
            switch($this->format) {
                case 'GIF':
                    $this->oldImage = ImageCreateFromGif($this->fileName);
                    break;
                case 'JPG':
                    $this->oldImage = ImageCreateFromJpeg($this->fileName);
                    break;
                case 'PNG':
                    $this->oldImage = ImageCreateFromPng($this->fileName);
                    break;
            }

            $size = GetImageSize($this->fileName);
            $this->currentDimensions = array('width'=>$size[0],'height'=>$size[1]);
            $this->newImage = $this->oldImage;
            $this->gatherImageMeta();
        }

        if($this->error == true) {
            $this->showErrorImage();
            break;
        }
    }

    public function __destruct() {
        if(is_resource($this->newImage)) @ImageDestroy($this->newImage);
        if(is_resource($this->oldImage)) @ImageDestroy($this->oldImage);
        if(is_resource($this->workingImage)) @ImageDestroy($this->workingImage);
    }

    private function getCurrentWidth() {
        return $this->currentDimensions['width'];
    }


    private function getCurrentHeight() {
        return $this->currentDimensions['height'];
    }

    private function calcWidth($width,$height) {
        $newWp = (100 * $this->maxWidth) / $width;
        $newHeight = ($height * $newWp) / 100;
        return array('newWidth'=>intval($this->maxWidth),'newHeight'=>intval($newHeight));
    }

    private function calcHeight($width,$height) {
        $newHp = (100 * $this->maxHeight) / $height;
        $newWidth = ($width * $newHp) / 100;
        return array('newWidth'=>intval($newWidth),'newHeight'=>intval($this->maxHeight));
    }

    private function calcPercent($width,$height) {
        $newWidth = ($width * $this->percent) / 100;
        $newHeight = ($height * $this->percent) / 100;
        return array('newWidth'=>intval($newWidth),'newHeight'=>intval($newHeight));
    }

    private function calcImageSize($width,$height) {
        $newSize = array('newWidth'=>$width,'newHeight'=>$height);

        if($this->maxWidth > 0) {

            $newSize = $this->calcWidth($width,$height);

            if($this->maxHeight > 0 && $newSize['newHeight'] > $this->maxHeight) {
                $newSize = $this->calcHeight($newSize['newWidth'],$newSize['newHeight']);
            }
        }

        if($this->maxHeight > 0) {
            $newSize = $this->calcHeight($width,$height);

            if($this->maxWidth > 0 && $newSize['newWidth'] > $this->maxWidth) {
                $newSize = $this->calcWidth($newSize['newWidth'],$newSize['newHeight']);
            }
        }

        $this->newDimensions = $newSize;
    }

    private function calcImageSizePercent($width,$height) {
        if($this->percent > 0) {
            $this->newDimensions = $this->calcPercent($width,$height);
        }
    }

    private function showErrorImage() {
        header('Content-type: image/png');
        $errImg = ImageCreate(220,25);
        $bgColor = imagecolorallocate($errImg,0,0,0);
        $fgColor1 = imagecolorallocate($errImg,255,255,255);
        $fgColor2 = imagecolorallocate($errImg,255,0,0);
        imagestring($errImg,3,6,6,'Error:',$fgColor2);
        imagestring($errImg,3,55,6,$this->errmsg,$fgColor1);
        imagepng($errImg);
        imagedestroy($errImg);
    }

    public function resize($maxWidth = 0, $maxHeight = 0) {
        $this->maxWidth = $maxWidth;
        $this->maxHeight = $maxHeight;

        $this->calcImageSize($this->currentDimensions['width'],$this->currentDimensions['height']);

//		if(function_exists("ImageCreateTrueColor")) {
			$this->workingImage = ImageCreateTrueColor($this->newDimensions['newWidth'],$this->newDimensions['newHeight']);
//		}
//		else {
//			$this->workingImage = ImageCreate($this->newDimensions['newWidth'],$this->newDimensions['newHeight']);
//		}

		ImageCopyResampled(
			$this->workingImage,
			$this->oldImage,
			0,
			0,
			0,
			0,
			$this->newDimensions['newWidth'],
			$this->newDimensions['newHeight'],
			$this->currentDimensions['width'],
			$this->currentDimensions['height']
		);

		$this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $this->newDimensions['newWidth'];
		$this->currentDimensions['height'] = $this->newDimensions['newHeight'];
	}

	public function resizePercent($percent = 0) {
	    $this->percent = $percent;

	    $this->calcImageSizePercent($this->currentDimensions['width'],$this->currentDimensions['height']);

		if(function_exists("ImageCreateTrueColor")) {
			$this->workingImage = ImageCreateTrueColor($this->newDimensions['newWidth'],$this->newDimensions['newHeight']);
		}
		else {
			$this->workingImage = ImageCreate($this->newDimensions['newWidth'],$this->newDimensions['newHeight']);
		}

		ImageCopyResampled(
			$this->workingImage,
			$this->oldImage,
			0,
			0,
			0,
			0,
			$this->newDimensions['newWidth'],
			$this->newDimensions['newHeight'],
			$this->currentDimensions['width'],
			$this->currentDimensions['height']
		);

		$this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $this->newDimensions['newWidth'];
		$this->currentDimensions['height'] = $this->newDimensions['newHeight'];
	}

	public function cropFromCenter($cropSize) {
	    if($cropSize > $this->currentDimensions['width']) $cropSize = $this->currentDimensions['width'];
	    if($cropSize > $this->currentDimensions['height']) $cropSize = $this->currentDimensions['height'];

	    $cropX = intval(($this->currentDimensions['width'] - $cropSize) / 2);
	    $cropY = intval(($this->currentDimensions['height'] - $cropSize) / 2);

	    if(function_exists("ImageCreateTrueColor")) {
			$this->workingImage = ImageCreateTrueColor($cropSize,$cropSize);
		}
		else {
			$this->workingImage = ImageCreate($cropSize,$cropSize);
		}

		imagecopyresampled(
            $this->workingImage,
            $this->oldImage,
            0,
            0,
            $cropX,
            $cropY,
            $cropSize,
            $cropSize,
            $cropSize,
            $cropSize
		);

		$this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $cropSize;
		$this->currentDimensions['height'] = $cropSize;
	}

	public function crop($startX,$startY,$width,$height) {
	    //make sure the cropped area is not greater than the size of the image
	    if($width > $this->currentDimensions['width']) $width = $this->currentDimensions['width'];
	    if($height > $this->currentDimensions['height']) $height = $this->currentDimensions['height'];
	    //make sure not starting outside the image
	    if(($startX + $width) > $this->currentDimensions['width']) $startX = ($this->currentDimensions['width'] - $width);
	    if(($startY + $height) > $this->currentDimensions['height']) $startY = ($this->currentDimensions['height'] - $height);
	    if($startX < 0) $startX = 0;
	    if($startY < 0) $startY = 0;

	    if(function_exists("ImageCreateTrueColor")) {
			$this->workingImage = ImageCreateTrueColor($width,$height);
		}
		else {
			$this->workingImage = ImageCreate($width,$height);
		}

		imagecopyresampled(
            $this->workingImage,
            $this->oldImage,
            0,
            0,
            $startX,
            $startY,
            $width,
            $height,
            $width,
            $height
		);

		$this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $width;
		$this->currentDimensions['height'] = $height;
	}

	public function show($quality=100,$name = '') {
	    switch($this->format) {
	        case 'GIF':
	            if($name != '') {
	                ImageGif($this->newImage,$name);
	            }
	            else {
	               header('Content-type: image/gif');
	               ImageGif($this->newImage);
	            }
	            break;
	        case 'JPG':
	            if($name != '') {
	                ImageJpeg($this->newImage,$name,$quality);
	            }
	            else {
	               header('Content-type: image/jpeg');
	               ImageJpeg($this->newImage,'',$quality);
	            }
	            break;
	        case 'PNG':
	            if($name != '') {
	                ImagePng($this->newImage,$name);
	            }
	            else {
	               header('Content-type: image/png');
	               ImagePng($this->newImage);
	            }
	            break;
	    }
	}

	public function save($name,$quality=100) {
	    $this->show($quality,$name);
	}

	public function createReflection($percent,$reflection,$white,$border = true,$borderColor = '#a4a4a4') {
        $width = $this->currentDimensions['width'];
        $height = $this->currentDimensions['height'];

        $reflectionHeight = intval($height * ($reflection / 100));
        $newHeight = $height + $reflectionHeight;
        $reflectedPart = $height * ($percent / 100);

        $this->workingImage = ImageCreateTrueColor($width,$newHeight);

        ImageAlphaBlending($this->workingImage,true);

        $colorToPaint = ImageColorAllocateAlpha($this->workingImage,255,255,255,0);
        ImageFilledRectangle($this->workingImage,0,0,$width,$newHeight,$colorToPaint);

        imagecopyresampled(
                            $this->workingImage,
                            $this->newImage,
                            0,
                            0,
                            0,
                            $reflectedPart,
                            $width,
                            $reflectionHeight,
                            $width,
                            ($height - $reflectedPart));
        $this->imageFlipVertical();

        imagecopy($this->workingImage,$this->newImage,0,0,0,0,$width,$height);

        imagealphablending($this->workingImage,true);

        for($i=0;$i<$reflectionHeight;$i++) {
            $colorToPaint = imagecolorallocatealpha($this->workingImage,255,255,255,($i/$reflectionHeight*-1+1)*$white);
            imagefilledrectangle($this->workingImage,0,$height+$i,$width,$height+$i,$colorToPaint);
        }

        if($border == true) {
            $rgb = $this->hex2rgb($borderColor,false);
            $colorToPaint = imagecolorallocate($this->workingImage,$rgb[0],$rgb[1],$rgb[2]);
            imageline($this->workingImage,0,0,$width,0,$colorToPaint); //top line
            imageline($this->workingImage,0,$height,$width,$height,$colorToPaint); //bottom line
            imageline($this->workingImage,0,0,0,$height,$colorToPaint); //left line
            imageline($this->workingImage,$width-1,0,$width-1,$height,$colorToPaint); //right line
        }

        $this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $width;
		$this->currentDimensions['height'] = $newHeight;
	}


	private function imageFlipVertical() {
	    $x_i = imagesx($this->workingImage);
	    $y_i = imagesy($this->workingImage);

	    for($x = 0; $x < $x_i; $x++) {
	        for($y = 0; $y < $y_i; $y++) {
	            imagecopy($this->workingImage,$this->workingImage,$x,$y_i - $y - 1, $x, $y, 1, 1);
	        }
	    }
	}

	private function hex2rgb($hex, $asString = false) {
        // strip off any leading #
        if (0 === strpos($hex, '#')) {
           $hex = substr($hex, 1);
        } else if (0 === strpos($hex, '&H')) {
           $hex = substr($hex, 2);
        }

        // break into hex 3-tuple
        $cutpoint = ceil(strlen($hex) / 2)-1;
        $rgb = explode(':', wordwrap($hex, $cutpoint, ':', $cutpoint), 3);

        // convert each tuple to decimal
        $rgb[0] = (isset($rgb[0]) ? hexdec($rgb[0]) : 0);
        $rgb[1] = (isset($rgb[1]) ? hexdec($rgb[1]) : 0);
        $rgb[2] = (isset($rgb[2]) ? hexdec($rgb[2]) : 0);

        return ($asString ? "{$rgb[0]} {$rgb[1]} {$rgb[2]}" : $rgb);
    }
    
    private function gatherImageMeta() {
    	//only attempt to retrieve info if exif exists
    	if(function_exists("exif_read_data") && $this->format == 'JPG') {
			$imageData = exif_read_data($this->fileName);
			if(isset($imageData['Make'])) 
				$this->imageMeta['make'] = ucwords(strtolower($imageData['Make']));
			if(isset($imageData['Model'])) 
				$this->imageMeta['model'] = $imageData['Model'];
			if(isset($imageData['COMPUTED']['ApertureFNumber'])) {
				$this->imageMeta['aperture'] = $imageData['COMPUTED']['ApertureFNumber'];
				$this->imageMeta['aperture'] = str_replace('/','',$this->imageMeta['aperture']);
			}
			if(isset($imageData['ExposureTime'])) {
				$exposure = explode('/',$imageData['ExposureTime']);
				$exposure = round($exposure[1]/$exposure[0],-1);
				$this->imageMeta['exposure'] = '1/' . $exposure . ' second';
			}
			if(isset($imageData['Flash'])) {
				if($imageData['Flash'] > 0) {
					$this->imageMeta['flash'] = 'Yes';
				}
				else {
					$this->imageMeta['flash'] = 'No';
				}
			}
			if(isset($imageData['FocalLength'])) {
				$focus = explode('/',$imageData['FocalLength']);
				$this->imageMeta['focalLength'] = round($focus[0]/$focus[1],2) . ' mm';
			}
			if(isset($imageData['DateTime'])) {
				$date = $imageData['DateTime'];
				$date = explode(' ',$date);
				$date = str_replace(':','-',$date[0]) . ' ' . $date[1];
				$this->imageMeta['dateTaken'] = date('m/d/Y g:i A',strtotime($date));
			}
    	}
    }
    
    public function rotateImage($direction = 'CW') {
    	if($direction == 'CW') {
    		$this->workingImage = imagerotate($this->workingImage,-90,0);
    	}
    	else {
    		$this->workingImage = imagerotate($this->workingImage,90,0);
    	}
    	$newWidth = $this->currentDimensions['height'];
    	$newHeight = $this->currentDimensions['width'];
		$this->oldImage = $this->workingImage;
		$this->newImage = $this->workingImage;
		$this->currentDimensions['width'] = $newWidth;
		$this->currentDimensions['height'] = $newHeight;
    }
}
?>