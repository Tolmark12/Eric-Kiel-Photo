package delorum.loading
{

public class Queue
{
	private static var _queueOrdering:Object = {};
	private static var _queues:Object = [];
	public var loadCount:uint = 100000;
	public var loadQueue :Object = new Object();
	public var id:String;
	
	public function Queue($id:String):void
	{
		id = $id;
	}
	
	public static function getSingleton ( $id:String ):Queue
	{
		var queue:Queue;
		
		// Loop through the lis of queues and see if there
		// is an existing queue of this id
		var len:uint = _queues.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if(_queues[i] != null){
				queue = _queues[i];
				if( queue.id == $id )
					return queue;
			}
		}
		
		// If the code doesn't find a queu bu this id, create one
		queue = new Queue($id);
		//trace( _queueOrdering[$id] );
		if( _queueOrdering[$id] == null )
			_queues[_queues.length] = queue;
		else
			_queues[ _queueOrdering[$id] ] = queue;
		return queue;
	}
	
	// Get the current Queue (the queue at the front of the array that's not empty)
	public static function get currentQueue (  ):Queue
	{
		var len:uint = _queues.length;
		if( len != 0 ) {
			// Loop through each of the queues
			for ( var i:uint=0; i<len; i++ ) 
			{
				if( _queues[i] != null ){
					for( var j:String in _queues[i].loadQueue )
					{
						// If any alements in the queue remain, return that queue
						return _queues[i] as Queue;
					}
				}
			}
			
			// If they're all empty, return an empty queue
			return _queues[0] as Queue;
		}
		
		return null;
	}
	
	public static function swapQueueOrder (  ):void
	{
		
	}
	
	public static function queueById ( $id:String ):Queue
	{
		var len:uint = _queues.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( _queues[i].id == $id )
				return _queues[i];
		}
			
		return null;
	}
	
	public static function setQueueIndex ( $queueId:String, $index:Number=0 ):void
	{
		getSingleton($queueId);
		_queueOrdering[$queueId] = $index
	}

}

}