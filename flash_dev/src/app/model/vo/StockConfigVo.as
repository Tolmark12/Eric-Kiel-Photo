package app.model.vo
{

public class StockConfigVo
{
	public var defaultStockCategories:Vector.<StockDefaultCategoryVo> = new Vector.<StockDefaultCategoryVo>();
	public var formDefinitions:Vector.<FormVO> = new Vector.<FormVO>();
	
	public function StockConfigVo( $json:Object ):void
	{
		// Init All the default categories
		var len:uint = $json.default_stock_categories.length;
		for ( var i:uint=0; i<len; i++ ) {
			defaultStockCategories[i] = new StockDefaultCategoryVo( $json.default_stock_categories[i] );
		}
		
		var len2:uint = $json.form_definitions.length;
		for ( var j:uint=0; j<len2; j++ ) {
			formDefinitions[j] = new FormVO( $json.form_definitions[j] );
		}
	}
	
	public function getFormById ( $id ):FormVO
	{
		var len:uint = formDefinitions.length;
		for ( var i:uint=0; i<len; i++ ) 
		{
			if( formDefinitions[i].id == $id )
				return formDefinitions[i];
		}
		return null;
	}
}

}