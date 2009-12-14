package app.model.vo
{

public class StockConfigVo
{
	public var defaultStockCategories:Vector.<StockDefaultCategoryVo> = new Vector.<StockDefaultCategoryVo>();
	
	public function StockConfigVo( $json:Object ):void
	{
		// Init All the default categories
		var len:uint = $json.default_stock_categories.length;
		for ( var i:uint=0; i<len; i++ ) {
			defaultStockCategories[i] = new StockDefaultCategoryVo( $json.default_stock_categories[i] );
		}
	}
}

}