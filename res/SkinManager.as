package res
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.formats.TextAlign;
	
	import res.assembly.ButtonAssembly;
	import res.assembly.CheckBoxAssembly;
	import res.assembly.UIPanelAssembly;

	public class SkinManager
	{
		private var _byteArray : ByteArray;
		private var _completeFunction : Function;
		private var _applicationDomain : ApplicationDomain;
		
		public var textFormatDic : Object;
		public var buttonDic : Object;
		public var uipanelDic : Object;
		public var checkBoxDic : Object;
		
		public function SkinManager()
		{
		}
		
		/**
		 * 读取资源 
		 * @param byteArray				资源的二进制文件
		 * @param completeFunction		读取成功的回调函数
		 * 
		 */		
		public function loadRes(byteArray : ByteArray,completeFunction : Function):void
		{
			_byteArray = byteArray;
			_completeFunction = completeFunction;
						
			_applicationDomain = ApplicationDomain.currentDomain;
			
			// 读取config部分
			textFormatDic = new Object();
			var count : int = _byteArray.readShort();
			// 加载字体
			for(var i : int = 0; i < count; ++i)
			{
				var nameLen : int = _byteArray.readByte();
				var name : String = _byteArray.readUTFBytes(nameLen);
				var textFormat : TextFormat = new TextFormat();
				var fontLen : int = _byteArray.readByte();
				var font : String = _byteArray.readUTFBytes(fontLen);
				textFormat.font = font;
				textFormat.size = _byteArray.readByte();
				textFormat.color = _byteArray.readUnsignedInt();
				textFormat.bold = _byteArray.readBoolean();
				textFormat.italic = _byteArray.readBoolean();
				var align : int = _byteArray.readByte();
				if(align == 1)
				{
					textFormat.align = TextAlign.CENTER;
				}
				else if(align == 2)
				{
					textFormat.align = TextAlign.RIGHT;
				}
				textFormatDic[name] = textFormat;
			}
			// 加载按钮
			buttonDic = new Object();
			count = _byteArray.readByte();
			for(i = 0; i < count; ++i)
			{
				var buttonAssembly : ButtonAssembly = new ButtonAssembly(_byteArray, _applicationDomain);
				buttonDic[buttonAssembly.name] = buttonAssembly;
			}
			// 加载uipanel
			uipanelDic = new Object();
			count = _byteArray.readByte();
			for(i = 0; i < count; ++i)
			{
				var uipanelAssembly : UIPanelAssembly = new UIPanelAssembly(_byteArray, _applicationDomain);
				uipanelDic[uipanelAssembly.name] = uipanelAssembly;
			}
			// 加载checkBox
			checkBoxDic = new Object();
			count = _byteArray.readByte();
			for(i = 0; i < count; ++i)
			{
				var checkBoxAssembly : CheckBoxAssembly = new CheckBoxAssembly(_byteArray, _applicationDomain);
				checkBoxDic[checkBoxAssembly.name] = checkBoxAssembly;
			}
			
			//回调
			_completeFunction();
			
			// 清空回调函数
			_completeFunction = null;
		}
		
		public function getSkin(skinName : String):Class
		{
			return _applicationDomain.getDefinition(skinName) as Class;
		}
	}
}