package app.model
{
import org.puremvc.as3.multicore.interfaces.IProxy;
import org.puremvc.as3.multicore.patterns.proxy.Proxy;
import app.model.vo.*;
import app.AppFacade;

public class TagsProxy extends Proxy implements IProxy
{
	public static const NAME:String = "tags_proxy";
	public static const NUM_OF_SUGGESTIONS:Number = 15;
	
	private var _search:SearchVo ;
	
	// Constructor
	public function TagsProxy( ):void { 
		super( NAME ); 
	}
	
	public function parseStockDataTags ( $json:Object ):void {
		_tags = new Array();
		var len:uint = $json.tags.length;
		for ( var i:uint=0; i<len; i++ ) {
			_tags.push( new StockTagVo( $json.tags[i] ));
		}
		_search = new SearchVo(_tags.length);
	}
	
	/** 
	*	Clear the current search, and build a new one
	*/
	public function newSearch (  ):void
	{
		_search = new SearchVo(_tags.length);
	}
	
	/** 
	*	This is called everytime the search term changes
	*	@param		The entire new term
	*/
	public function onSearchTermChange ( $newTerm:String ):void
	{
		$newTerm = $newTerm.toLowerCase();
		var newWordLength:uint = $newTerm.length;
		
		// If string is empty:
		if( newWordLength == 0 ) {
			sendNotification( AppFacade.DISPLAY_TAG_HINTS, [] );
			_search = new SearchVo(_tags.length);
		}
		
		// else:
		else{
			// If current searched word is longer than the new one
			// trim off the extra letters.
			// ex: word    search  ->   sear
			if( _search.letters.length > newWordLength )
				_search.clearFromIndex(newWordLength)
			
			// Itterate through the word and compare each letter with 
			// the letters found in the current search. If they differ
			// at any point, we trim off that letter and the remaining
			// letters from the current search. Then call : addLetterToSearch( "newLetterThat'sDifferent" )
			var len:uint = newWordLength;
			for ( var i:uint=0; i<len; i++ ) 
			{
				// If a letter at this index exists...
				if( _search.letters.length > i ) {
					//...if the letters are different...
					if( _search.letters[i].letter != $newTerm.charAt(i) ){
						//..clear existing letters and...
						_search.clearFromIndex(i);
						//...add new letter
						addLetterToSearch( $newTerm.charAt(i) );
					}
					///...if letters are the same, send the existing array:
					else{
						_sendAr();
					}
				}
				// Else if there is no existing letter at this index, we simply
				// add the new letter to the existing word.
				else{
					addLetterToSearch( $newTerm.charAt(i) );
				}
			}
		}
	}
	
	/** 
	*	Add another letter to the existing search stack
	*	@param		the Letter to find in the words
	*/
	public function addLetterToSearch ( $letter:String ):void
	{
		//// if the last letter did find matches, search for next match:
		if( _search.startIndex != -1 ){
			var count:uint 					= _search.startIndex;		// Itterator
			var letterIndex:Number 			= _search.word.length;		// The position of the letter in the word we're looking at
			var firstInstanceFound:Boolean	= false;					// Set to true after the first match is found
			var firstIndex:Number			= -1;						// Index of the first match (in the array)
			var lastIndex:Number			= _search.endIndex;			// Index of the last match
			
			// Loop through each word in the stack, and test it's letter at letter
			// Index to see if it matches the new letter. Use the first and last words
			// matched to define the starting / ending points of the set
			while(count < _search.endIndex){
				var testLetter:String 	= _tags[count].tag.charAt(letterIndex);
				var isMatch:Boolean		= testLetter.toLowerCase() == $letter.toLowerCase();
				// If the first match has been found in previous itteration...
				if( firstInstanceFound ) {
					//...and the letters DON'T match... 
					if( !isMatch ){
						//...then this is the last index.
						lastIndex = count;
						break;
					}
				}
				// If the first match has not been found & the letters match..
				else if( !firstInstanceFound && isMatch ){
					//...this is the first index
					firstInstanceFound = true;
					firstIndex = count;
					// lastIndex  = count+1;
				}
				count++
			} // : Loop END
			
			// If no terms matched this new letter, add a non-match instance:
			if( !firstInstanceFound ){
				_search.addLetterToSearch($letter, -1, -1 );
			}
			
			// else match(es) were were found:
			else{
				_search.addLetterToSearch($letter, firstIndex, lastIndex );
				_sendAr()
			}
		}
		
		//// else, since the last letter didn't match, neither will this one
		//// add another letter matching nothing:
		else{
			_search.addLetterToSearch($letter, -1, -1 );
		}
	}
	
	
	
	// _____________________________ Helpers
	
	private function _sendAr (  ):void {
		var resultsAr:Array = _tags.slice(_search.startIndex, _search.endIndex);
		resultsAr.splice( NUM_OF_SUGGESTIONS );
		sendNotification( AppFacade.DISPLAY_TAG_HINTS, resultsAr );
	}
	
	
	
	
	//// TEMP DATA FOR TESTING
	private var _tags:Array = [ ];

}
}