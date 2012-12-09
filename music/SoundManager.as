package music
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class SoundManager
	{
		private var _bgmEnabled : Boolean;
		private var _effectEnabled : Boolean;
		private var _effectBufferEnabled : Boolean;
		private var _bgmContent : SoundContent;
		private var _bgmBuffer : SoundBuffer;
		private var _effectGroup : Dictionary;
		private var _effectBuffer : Object;
		
		private var _bgmVolume : Number;
		private var _effectVolume : Number;
		
		public function SoundManager()
		{
			var sharedObject : SharedObject = SharedObject.getLocal("pixelGame");
			if(sharedObject.data["music"] == null)
			{
				_effectEnabled = true;
			}
			else
			{
				_effectEnabled = sharedObject.data["music"];
			}
			_bgmEnabled = true;
			_effectBufferEnabled = true;
			_effectGroup = new Dictionary();
			_effectBuffer = new Object();
			
			_bgmVolume = 0.6;
			_effectVolume = 0.2;
		}
		
		public function setBgmEnabled(enable : Boolean):void
		{
			_bgmEnabled = enable;
			if(_bgmEnabled)
			{
				if(_bgmContent != null)
				{
					playBgm(_bgmContent.soundName);
				}
			}
			else
			{
				stopBGM();
			}
		}
		
		public function getBgmEnabled():Boolean
		{
			return _bgmEnabled;
		}
		
		public function setEffectEnabled(enable : Boolean):void
		{
			_effectEnabled = enable;
			if(!_effectEnabled)
			{
				stopAllEffect();
			}
			var sharedObject : SharedObject = SharedObject.getLocal("pixelGame");
			var object : Object = sharedObject.data;
			object["music"] = enable;
			
			sharedObject.flush();
		}
		
		public function getEffectEnabled():Boolean
		{
			return _effectEnabled;
		}
		
		public function set bgmVolume(volume : Number):void
		{
			_bgmVolume = volume;
			if(_bgmContent != null && _bgmContent.soundChannel != null)
			{
				var transForm : SoundTransform = new SoundTransform(_bgmVolume);
				_bgmContent.soundChannel.soundTransform = transForm;
			}
		}
		
		public function get bgmVolume():Number
		{
			return _bgmVolume;
		}
		
		public function set effectVolume(volume : Number):void
		{
			_effectVolume = volume;
			var transForm : SoundTransform = new SoundTransform(volume);
			for each(var effectContent : SoundContent in  _effectGroup)
			{
				if(effectContent.soundChannel != null)
				{
					effectContent.soundChannel.soundTransform = transForm;
				}
			}
		}
		
		public function get effectVolume():Number
		{
			return _effectVolume;
		}
		
		public function playBgm(soundName : String):void
		{
			if(soundName != null && soundName.length > 0)
			{
				var url : String = "res1/sound/" + soundName + ".mp3";
				if(_bgmContent == null || _bgmContent.soundChannel == null || _bgmContent.soundName != soundName)
				{
					_bgmContent = new SoundContent();
					_bgmContent.soundName = soundName;
					_bgmContent.url = url;
					
					if(_bgmEnabled)
					{
						_bgmBuffer = new SoundBuffer();
						var urlRequest : URLRequest = new URLRequest(url);
						_bgmBuffer.sound = new Sound(urlRequest);
						_bgmBuffer.count = 1;
						_bgmBuffer.sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadBgmError);
						_bgmContent.soundChannel = _bgmBuffer.sound.play(0,int.MAX_VALUE);
						_bgmContent.soundChannel.soundTransform = new SoundTransform(_bgmVolume);
					}
				}
			}
		}
		
		public function stopBGM():void
		{
			if(_bgmContent != null)
			{
				if(_bgmContent.soundChannel != null)
				{
					_bgmContent.soundChannel.stop();
				}
				_bgmContent.soundChannel = null;
			}
			
			if(_bgmBuffer != null)
			{
				_bgmBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadBgmError);
				try
				{
					_bgmBuffer.sound.close();
				} 
				catch(error:Error){};
				_bgmBuffer.sound = null;
				_bgmBuffer.count = 0;
				_bgmBuffer == null;
			}
		}
		
		private function onLoadBgmError(event : Event):void
		{
			stopBGM();
		}
		
		public function openEffectBuffer():void
		{
			_effectBufferEnabled = true;
		}
		
		public function closeEffectBuffer():void
		{
			_effectBufferEnabled = false;
			for (var effectName : String in _effectBuffer)
			{
				var effectBuffer : SoundBuffer = _effectBuffer[effectName];
				if(effectBuffer.count <= 0)
				{
					delete effectBuffer[effectName];
					effectBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
					try
					{
						effectBuffer.sound.close();
					} 
					catch(error:Error) {};
					effectBuffer.sound = null;
				}
			}
		}
		
		public function playEffect(soundName : String):void
		{
			if(_effectEnabled && soundName != null && soundName.length > 0)
			{
				var url : String = "res1/sound/" + soundName + ".mp3";
				
				var effectContent : SoundContent = new SoundContent();
				effectContent.soundName = soundName;
				effectContent.url = url;
				
				var needAddBuffer : Boolean = false;
				var effectBuffer : SoundBuffer = _effectBuffer[effectContent.soundName];
				if(effectBuffer == null)
				{
					effectBuffer = new SoundBuffer();
					effectBuffer.sound = new Sound(new URLRequest(url));
					effectBuffer.sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
					effectBuffer.count = 0;
					needAddBuffer = true;
				}
				effectContent.soundChannel = effectBuffer.sound.play(0,1);
				
				if(effectContent.soundChannel != null)
				{
					effectContent.soundChannel.addEventListener(Event.SOUND_COMPLETE, onPlayEffectComplete);
					effectContent.soundChannel.soundTransform = new SoundTransform(_effectVolume);
					_effectGroup[effectContent.soundChannel] = effectContent;
					
					if(needAddBuffer)
					{
						_effectBuffer[effectContent.soundName] = effectBuffer;
					}
					++effectBuffer.count;
				}
				else if(needAddBuffer)
				{
					effectBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
					try
					{
						effectBuffer.sound.close();
					} 
					catch(error:Error) {};
					effectBuffer.sound = null;
				}
			}
		}
		
		public function stopAllEffect():void
		{
			for each(var effectContent : SoundContent in _effectGroup)
			{
				delete _effectGroup[effectContent.soundChannel];
				effectContent.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onPlayEffectComplete);
				effectContent.soundChannel.stop();
				var effectBuffer : SoundBuffer = _effectBuffer[effectContent.soundName];
				if(effectBuffer != null)
				{
					--effectBuffer.count;
					if(!_effectBufferEnabled && effectBuffer.count <= 0)
					{
						effectBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
						try
						{
							effectBuffer.sound.close();
						} 
						catch(error:Error) {}
					}
				}
				effectContent.soundChannel = null;
				effectContent.soundName = null;
				effectContent.url = null;
				effectContent = null;
			}
		}
		
		private function onLoadEffectError(event : Event):void
		{
			var sound : Sound = event.currentTarget as Sound;
			for (var soundName : String in _effectBuffer)
			{
				var effectBuffer : SoundBuffer = _effectBuffer[soundName];
				if(effectBuffer.sound === sound)
				{
					delete _effectBuffer[soundName];
					effectBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
					try
					{
						effectBuffer.sound.close();
					} 
					catch(error:Error) {}
					effectBuffer.sound = null;
					for each(var effectContent : SoundContent in _effectGroup)
					{
						delete _effectGroup[effectContent.soundChannel];
						effectContent.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onPlayEffectComplete);
						effectContent.soundChannel.stop();
						effectContent.soundChannel = null;
						effectContent.soundName = null;
						effectContent.url = null;
						effectContent = null;
					}
				}
			}
		}
		
		private function onPlayEffectComplete(event : Event):void
		{
			var effectContent : SoundContent = _effectGroup[event.currentTarget];
			delete _effectGroup[effectContent.soundChannel];
			effectContent.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onPlayEffectComplete);
			effectContent.soundChannel.stop();
			var effectBuffer : SoundBuffer = _effectBuffer[effectContent.soundName];
			if(effectBuffer != null)
			{
				--effectBuffer.count;
				if(!_effectBufferEnabled && effectBuffer.count <= 0)
				{
					effectBuffer.sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadEffectError);
					try
					{
						effectBuffer.sound.close();
					} 
					catch(error:Error) {}
					effectBuffer.sound = null;
				}
			}
			effectContent.soundChannel = null;
			effectContent.soundName = null;
			effectContent.url = null;
			effectContent = null;
		}
		
		public function destroy():void
		{
			stopBGM();
			stopAllEffect();
			
			_bgmEnabled = false;
			_effectEnabled = false;
			_effectBufferEnabled = false;
			
			_effectGroup = null;
			_effectBuffer = null;
			
			_bgmVolume = 0;
			_effectVolume = 0;
		}
	}
}