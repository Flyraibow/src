package res.assembly
{
	import fl.controls.CheckBox;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	public class CheckBoxAssembly
	{
		public var name : String;
		
		private var _upIcon : BitmapData;
		private var _overIcon : BitmapData;
		private var _downIcon : BitmapData;
		private var _disabledIcon : BitmapData;
		
		private var _selectedUpIcon : BitmapData;
		private var _selectedOverIcon : BitmapData;
		private var _selectedDownIcon : BitmapData;
		private var _selectedDisabledIcon : BitmapData;
		
		public function CheckBoxAssembly(byteArray : ByteArray, applicationDomain : ApplicationDomain)
		{
			var nameLen : int = byteArray.readByte();
			name = byteArray.readUTFBytes(nameLen);
			
			var upIconLen : int = byteArray.readByte();
			var upIconName : String = byteArray.readUTFBytes(upIconLen);
			var upIconClass : Class = applicationDomain.getDefinition(upIconName) as Class;
			_upIcon = new upIconClass();
			
			var overIconLen : int = byteArray.readByte();
			var overIconName : String = byteArray.readUTFBytes(overIconLen);
			var overIconClass : Class = applicationDomain.getDefinition(overIconName) as Class;
			_overIcon = new overIconClass();
			
			var downIconLen : int = byteArray.readByte();
			var downIconName : String = byteArray.readUTFBytes(downIconLen);
			var downIconClass : Class = applicationDomain.getDefinition(downIconName) as Class;
			_downIcon = new downIconClass();
			
			var disabledIconLen : int = byteArray.readByte();
			var disabledIconName : String = byteArray.readUTFBytes(disabledIconLen);
			var disabledIconClass : Class = applicationDomain.getDefinition(disabledIconName) as Class;
			_disabledIcon = new disabledIconClass();

			var selectedUpIconLen : int = byteArray.readByte();
			var selectedUpIconName : String = byteArray.readUTFBytes(selectedUpIconLen);
			var selectedUpIconClass : Class = applicationDomain.getDefinition(selectedUpIconName) as Class;
			_selectedUpIcon = new selectedUpIconClass();
			
			var selectedOverIconLen : int = byteArray.readByte();
			var selectedOverIconName : String = byteArray.readUTFBytes(selectedOverIconLen);
			var selectedOverIconClass : Class = applicationDomain.getDefinition(selectedOverIconName) as Class;
			_selectedOverIcon = new selectedOverIconClass();
			
			var selectedDownIconLen : int = byteArray.readByte();
			var selectedDownIconName : String = byteArray.readUTFBytes(selectedDownIconLen);
			var selectedDownIconClass : Class = applicationDomain.getDefinition(selectedDownIconName) as Class;
			_selectedDownIcon = new selectedDownIconClass();
			
			var selectedDisabledIconLen : int = byteArray.readByte();
			var selectedDisabledIconName : String = byteArray.readUTFBytes(selectedDisabledIconLen);
			var selectedDisabledIconClass : Class = applicationDomain.getDefinition(selectedDisabledIconName) as Class;
			_selectedDisabledIcon = new selectedDisabledIconClass();
		}
		
		public function getCheckBox():CheckBox
		{
			var checkBox : CheckBox = new CheckBox();
			checkBox.setStyle("upIcon", new Bitmap(_upIcon.clone()));
			checkBox.setStyle("overIcon", new Bitmap(_overIcon.clone()));
			checkBox.setStyle("downIcon", new Bitmap(_downIcon.clone()));
			checkBox.setStyle("disabledIcon", new Bitmap(_disabledIcon.clone()));
			checkBox.setStyle("selectedUpIcon", new Bitmap(_selectedUpIcon.clone()));
			checkBox.setStyle("selectedOverIcon", new Bitmap(_selectedOverIcon.clone()));
			checkBox.setStyle("selectedDownIcon", new Bitmap(_selectedDownIcon.clone()));
			checkBox.setStyle("selectedDisabledIcon", new Bitmap(_selectedDisabledIcon.clone()));
			return checkBox;
		}
	}
}