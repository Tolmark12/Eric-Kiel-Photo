package app.model.vo
{

public class SearchVo
{
	public var word:String = "";
	//public var letters:Vector.<Object> = new Vector.<Object>();
	public var letters:Array = new Array();
	public var startIndex:Number;
	public var endIndex:Number;
	public var totalItemsInSearch:Number;
	
	public function SearchVo( $databaseLength:uint):void {
		startIndex = 0;
		totalItemsInSearch = endIndex   = $databaseLength - 1;
	}
	
	/** 
	*	Add a letter to the end of the Search string
	*	@param		The letter
	*	@param		The index marking the begining of the range of terms to search (used by next search)
	*	@param		The index marking the end of the range of terms to search
	*/
	public function addLetterToSearch ( $letter:String, $startIndex:Number, $endIndex:Number ):void
	{
		// Save the search params
		var obj:Object = {
				letter:$letter,
				position:$letter.length,		// Position of this letter in the word
				startIndex:$startIndex, 
				endIndex:$endIndex 
			} 
			
		//trace( "Result === " + $letter + '  :  ' + $startIndex + '  :  ' + $endIndex );
		letters.push( obj );
		
		startIndex 	= $startIndex;
		endIndex	= $endIndex;
		
		word += $letter;
	}
	
	/** 
	*	Delete the letter from the search string
	*/
	public function removeLastLetter (  ):void
	{
		letters.pop();
		word = word.slice(0,word.length - 1);
	}
	
	public function clearFromIndex ( $index ):void
	{
		letters.splice($index);
		word = word.slice(0,$index);
		
		if( letters.length != 0 ) {
			startIndex = letters[letters.length-1].startIndex;
			endIndex = letters[letters.length-1].endIndex;
		}else{
			startIndex = 0;
			endIndex = totalItemsInSearch;
		}
	}
	
	
}

}