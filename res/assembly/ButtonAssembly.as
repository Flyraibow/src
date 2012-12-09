package res.assembly
{
	import fl.controls.Button;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * 按钮组建 
	 * @author acer
	 * 
	 */	
	public class ButtonAssembly
	{
		public var name : String;
		private var _scale9Grid : Rectangle;
		private var _upSkin : BitmapData;
		private var _overSkin : BitmapData;
		private var _downSkin : BitmapData;
		private var _disabledSkin : BitmapData;
		
		public function ButtonAssembly(byteArray : ByteArray, applicationDomain : ApplicationDomain)
		{
			var nameLen : int = byteArray.readByte();
			name = byteArray.readUTFBytes(nameLen);
			var resizable : Boolean = byteArray.readBoolean();
			if(resizable)
			{
				var x : int = byteArray.readShort();
				var y : int = byteArray.readShort();
				var width : int = byteArray.readShort();
				var height : int = byteArray.readShort();
				_scale9Grid = new Rectangle(x,y,width,height); 
			}
			else
			{
				_scale9Grid = null;
			}
			var upSkinLen : int = byteArray.readByte();
			var upSkinName : String = byteArray.readUTFBytes(upSkinLen);
			var upSkinClass : Class = applicationDomain.getDefinition(upSkinName) as Class;
			_upSkin = new upSkinClass();
			
			var overSkinLen : int = byteArray.readByte();
			var overSkinName : String = byteArray.readUTFBytes(overSkinLen);
			var overSkinClass : Class = applicationDomain.getDefinition(overSkinName) as Class;
			_overSkin = new overSkinClass();
			
			var downSkinLen : int = byteArray.readByte();
			var downSkinName : String = byteArray.readUTFBytes(downSkinLen);
			var downSkinClass : Class = applicationDomain.getDefinition(downSkinName) as Class;
			_downSkin = new downSkinClass();
			
			var disabledSkinLen : int = byteArray.readByte();
			var disabledSkinName : String = byteArray.readUTFBytes(disabledSkinLen);
			var disabledSkinClass : Class = applicationDomain.getDefinition(disabledSkinName) as Class;
			_disabledSkin = new disabledSkinClass();
		}
		
		public function getButton():Button
		{
			var button : Button = new Button();
			var upSkinScaleBitmap : ScaleBitmap = new ScaleBitmap(_upSkin.clone());
			var overSkinScaleBitmap : ScaleBitmap = new ScaleBitmap(_overSkin.clone());
			var downSkinScaleBitmap : ScaleBitmap = new ScaleBitmap(_downSkin.clone());
			var disabledSkinScaleBitmap : ScaleBitmap = new ScaleBitmap(_disabledSkin.clone());
			upSkinScaleBitmap.scale9Grid = _scale9Grid;
			overSkinScaleBitmap.scale9Grid = _scale9Grid;
			downSkinScaleBitmap.scale9Grid = _scale9Grid;
			disabledSkinScaleBitmap.scale9Grid = _scale9Grid;
			button.setStyle("upSkin", upSkinScaleBitmap);
			button.setStyle("overSkin", overSkinScaleBitmap);
			button.setStyle("downSkin", downSkinScaleBitmap);
			button.setStyle("disabledSkin", disabledSkinScaleBitmap);
			button.setStyle("emphasizedSkin", null);
			return button;
		}
		
	}
}