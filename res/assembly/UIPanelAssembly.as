package res.assembly
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import res.component.UIPanel;

	public class UIPanelAssembly
	{
		public var name : String;
		private var _scale9Grid : Rectangle;
		private var _Skin : BitmapData;
		
		public function UIPanelAssembly(byteArray : ByteArray, applicationDomain : ApplicationDomain)
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
			var skinClass : Class = applicationDomain.getDefinition(name) as Class;
			_Skin = new skinClass();
		}
		
		public function getUIPanel():UIPanel
		{
			var uipanel : UIPanel = new UIPanel();
			var scaleBitmap : ScaleBitmap = new ScaleBitmap(_Skin.clone());
			scaleBitmap.scale9Grid = _scale9Grid;
			uipanel.setStyle("skin",scaleBitmap);
			return uipanel;
		}
	}
}