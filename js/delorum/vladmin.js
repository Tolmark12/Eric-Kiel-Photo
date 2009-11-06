function openModal($url, $width, $height, $iframe){
	var modal =  new Window({
			className:'dialog',
			width: $width,
			height: $height, 
			top: 185,
			showEffect: Effect.Appear, 
			showEffectOptions: {duration: .5}, 
			hideEffect: Effect.Fade, 
			hideEffectOptions: {duration: .2},
			destroyOnClose: true,
			recenterAuto: false,
			draggable: false
		});
	modal.setZIndex(1000);
	if($iframe){
		modal.setURL($url);
		modal.showCenter(true, 115);
	}else{
		modal.setAjaxContent($url, {}, true, true);
	}
}