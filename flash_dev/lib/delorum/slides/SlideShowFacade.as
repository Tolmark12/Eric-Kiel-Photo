package delorum.slides
{
import org.puremvc.as3.multicore.interfaces.IFacade;
import org.puremvc.as3.multicore.patterns.facade.Facade;
import org.puremvc.as3.multicore.patterns.observer.Notification;
import delorum.slides.control.*;

public class SlideShowFacade extends Facade implements IFacade
{
	
	public static const STARTUP:String 					= "startup";
	public static const UNMAKE:String 					= "unmake";
	public static const BUILD_SLIDES:String 			= "build_slides";
	
	public static const NEXT_SLIDE:String 				= "next_slide";
	public static const PREV_SLIDE:String 				= "prev_slide";
	public static const CHANGE_SLIDE_BY_INDEX:String 	= "change_slide_by_index";
	
	public static const DISPLAY_NEW_SLIDE:String 		= "display_new_slide";
	public static const INIT_SLIDES:String 				= "init_slides";
	                                               
	public static const START_AUTOPLAY:String	   		= "start_autoplay";
	public static const STOP_AUTOPLAY:String 	   		= "stop_autoplay";
	
	// TransitionSpeed
	public static const TRANSITION_SPEED_TO_CLICK		= "transition_speed_to_click"
	public static const TRANSITION_SPEED_TO_AUTO		= "transition_speed_to_auto"
	
	// Example: var myFacade:SlideShowFacade = SlideShowFacade.getInstance( 'slide_show_facade' );
	public function SlideShowFacade( key:String ):void
	{
		super(key);	
	}

	/** Singleton factory method */
	public static function getInstance( key:String ):SlideShowFacade 
    {
        if ( instanceMap[ key ] == null ) instanceMap[ key ]  = new SlideShowFacade( key );
        return instanceMap[ key ] as SlideShowFacade;
    }
	
	public function startup( $holder:SlideShow ):void
	{
	 	sendNotification( STARTUP, $holder ); 
	}
	
	public function buildSlideShow( $slideShowVo:SlideShow_VO ):void
	{
	 	sendNotification( BUILD_SLIDES, $slideShowVo ); 
	}
	
	public function unmake (  ):void
	{
		sendNotification( UNMAKE );
		super.removeCore( super.multitonKey );
	}

	/** Register Controller commands */
	override protected function initializeController( ):void 
	{
		super.initializeController();
		registerCommand( STARTUP, Startup );
		registerCommand( UNMAKE, Startup );
		registerCommand( BUILD_SLIDES, BuildSlides );
		registerCommand( NEXT_SLIDE, 	 IncramentSlide );
		registerCommand( PREV_SLIDE, 	 IncramentSlide );
		registerCommand( CHANGE_SLIDE_BY_INDEX, ChangeSlideByIndex );
		registerCommand( TRANSITION_SPEED_TO_AUTO, ChangeTransitionSpeed  );
		registerCommand( TRANSITION_SPEED_TO_CLICK, ChangeTransitionSpeed );
	}
	
	// ______________________________________________________________ API

	public function stop (  ):void{ sendNotification(TRANSITION_SPEED_TO_AUTO);  sendNotification(STOP_AUTOPLAY); };
	public function start (  ):void{ sendNotification(TRANSITION_SPEED_TO_AUTO); sendNotification(START_AUTOPLAY); };
	public function reset (  ):void{ sendNotification(TRANSITION_SPEED_TO_AUTO); sendNotification(CHANGE_SLIDE_BY_INDEX, 0); };
	public function gotoSlide ( $slideIndex:uint ):void{ 
		sendNotification(TRANSITION_SPEED_TO_AUTO);
		sendNotification(CHANGE_SLIDE_BY_INDEX, $slideIndex); 
	};
	
	
	// ______________________________________________________________ Application wide vars
	
	public static function getTransitionSpeed (  ):Number
	{
		if( useAutoSpeed ) 
			return transitionSpeed;
		else
			return clickTransitionSpeed;
	}
	
	public static var useAutoSpeed:Boolean = false;
	public static var slidesWidth:Number;
	public static var slidesHeight:Number;
	public static var slideDisplayTime:Number;
	public static var transitionSpeed:Number;
	public static var clickTransitionSpeed:Number;

}
}


