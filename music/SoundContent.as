package music
{
	import flash.media.SoundChannel;

	internal class SoundContent
	{
		public var soundName : String;
		
		public var soundChannel : SoundChannel;
		
		public var url : String;
		
		public function SoundContent()
		{
		}
		
		public function clone() : SoundContent
		{
			var soundContent : SoundContent = new SoundContent();
			soundContent.soundName = soundName;
			soundContent.url = url;
			
			return soundContent;
		}
	}
}