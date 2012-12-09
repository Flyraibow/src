package res
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import res.assembly.ButtonAssembly;
	import res.assembly.CheckBoxAssembly;
	import res.assembly.UIPanelAssembly;
	import res.component.UIPanel;

	public class UIManager
	{
		public var skinManager : SkinManager;
		
		private var _uiDic : Object;
		
		public function UIManager()
		{
		}
		
		public function readUI(byteArray : ByteArray):void
		{
			_uiDic = byteArray.readObject();
		}
		
		public function getComponentContainer(uiName : String, componentDic : Object):DisplayObjectContainer
		{
			var xml : XML = XML(_uiDic[uiName]);
			if(xml != null)
			{
				return loadXml(xml, componentDic);
			}
			else
			{
				return null;
			}
		}
		
		private function loadXml(xml : XML, componentDic : Object):DisplayObjectContainer
		{
			var name : String = xml.name();
			var displayObjectContainer : DisplayObjectContainer;
			var id : String = xml.@id.toString();
			switch(name)
			{
				case "Button":
					var skin : String = xml.@skin.toString();
					var button : Button;
					if(skin.length > 0)
					{
						var buttonAssembly : ButtonAssembly = skinManager.buttonDic[skin];
						button = buttonAssembly.getButton();
					}
					else
					{
						button = new Button();
					}
					button.focusEnabled = false;
					button.emphasized = false;
					button.width = Number(xml.@width);
					button.height = Number(xml.@height);
					button.x = Number(xml.@x);
					button.y = Number(xml.@y);
					button.label = xml.@label.toString();
					var textFormat : TextFormat = skinManager.textFormatDic[xml.@textFormat];
					if(textFormat != null)
					{
						button.setStyle("textFormat",textFormat);
					}
					var disabledTextFormat : TextFormat = skinManager.textFormatDic[xml.@disabledTextFormat];
					if(disabledTextFormat != null)
					{
						button.setStyle("disabledTextFormat",disabledTextFormat);
					}
					displayObjectContainer = button;
					break;
				case "UIPanel":
					var uipanel : UIPanel;
					skin = xml.@skin.toString();
					if(skin.length > 0)
					{
						var uipanelAsembly : UIPanelAssembly = skinManager.uipanelDic[skin];
						uipanel = uipanelAsembly.getUIPanel();
					}
					else
					{
						uipanel = new UIPanel();
					}
					uipanel.setSize(Number(xml.@width), Number(xml.@height));
					uipanel.x = Number(xml.@x);
					uipanel.y = Number(xml.@y);
					displayObjectContainer = uipanel;
					break;
				case "CheckBox":
					var checkBox : CheckBox;
					skin = xml.@skin.toString();
					if(skin.length > 0)
					{
						var checkBoxAssembly : CheckBoxAssembly = skinManager.checkBoxDic[skin];
						checkBox = checkBoxAssembly.getCheckBox();
					}
					else
					{
						checkBox = new CheckBox();
					}
					checkBox.width = Number(xml.@width);
					checkBox.height = Number(xml.@height);
					checkBox.x = Number(xml.@x);
					checkBox.y = Number(xml.@y);
					checkBox.label = xml.@label.toString();
					textFormat = skinManager.textFormatDic[xml.@textFormat];
					if(textFormat != null)
					{
						checkBox.setStyle("textFormat",textFormat);
					}
					disabledTextFormat = skinManager.textFormatDic[xml.@disabledTextFormat];
					if(disabledTextFormat != null)
					{
						checkBox.setStyle("disabledTextFormat",disabledTextFormat);
					}
					displayObjectContainer = checkBox;
					break;
				case "Label":
					var label : Label = new Label();
					label.width = Number(xml.@width);
					label.height = Number(xml.@height);
					label.x = Number(xml.@x);
					label.y = Number(xml.@y);
					label.htmlText = xml.@label.toString();
					textFormat = skinManager.textFormatDic[xml.@textFormat];
					if(textFormat != null)
					{
						label.setStyle("textFormat",textFormat);
					}
					disabledTextFormat = skinManager.textFormatDic[xml.@disabledTextFormat];
					if(disabledTextFormat != null)
					{
						label.setStyle("disabledTextFormat",disabledTextFormat);
					}
					displayObjectContainer = label;
					break;
			}
			componentDic[id] = displayObjectContainer;
			
			for each(var itemXml : XML in xml.elements())
			{
				var childContainer : DisplayObjectContainer = loadXml(itemXml,componentDic);
				displayObjectContainer.addChild(childContainer);
			}
			
			return displayObjectContainer;
		}
	}
}