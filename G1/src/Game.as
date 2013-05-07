package
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.ui.Keyboard;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.media.Video;
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Game extends Sprite
	{
		public static var keyArray:Array = [Keyboard.D, Keyboard.A, Keyboard.S, Keyboard.W, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.DOWN, Keyboard.UP];
		public static var typeArr:Array = ["●", "■", "✖", "▲", "→", "←", "↓", "↑"]; //↑　→　↓　←　×　Ⅹ　〇　✖　□ ■　▲　●　○　∆　⇦　♦ ▲ ► ▼ ◄   ●■✖▲
		public static var colorArr:Array = [0xFF0000, 0xFF00FF, 0x00FF00, 0x0000FF, 0xFF0000, 0xFF00FF, 0x00FF00, 0x0000FF];
		public static var colorArrBkg:Array = [0xFFCCCC, 0xFFCCFF, 0xCCFFCC, 0xCCCCFF, 0xFFCCCC, 0xFFCCFF, 0xCCFFCC, 0xCCCCFF];
		public static var colorArrSdw:Array = [0x330000, 0x330033, 0x003300, 0x000033, 0x330000, 0x330033, 0x003300, 0x000033];
		
		//public var notePath:String = "http://files.artzilla.name/game/test/test.anf";
		public static var notePath:String = "http://files.artzilla.name/game/song/don't_say_lazy/Don't say lazy.anf?unchanged=123";
		
		private const FILE_HEADER_SIZE:int = 16;
		
		private var pause:Boolean = false;
		private var note_array:Array;
		private var noteLoader:URLLoader;
		
		private var block_count:int;
		private var block_array:Array = new Array();
		private var block_active:Array = new Array();
		private var block_last:Array = new Array();
		
		private var block_pre_display_time:Number = 1500;
		private var block_destroy_time:Number = 320;
		
		public var score:Score = new Score();
		
		private var track:Sound;
		private var track_channel:SoundChannel;
		private var track_current_time:Number = 0;
		
		private var video:Video = new Video(1280, 720);
		
		private var track_duration:TrackDuration = new TrackDuration();
		
		public function getTime():Number
		{
			if (track_channel)
				return track_channel.position;
			else
				return 0;
		}
		
		public function getDuration():Number
		{
			if (track)
				return track.length;
			else
				return -1;
		}
		
		private function IOError(e:IOErrorEvent):void
		{
			var test:int;
		}
		
		public function Game()
		{
			super();
			score.Init();
			
			noteLoader = new URLLoader();
			
			addEventListener(Event.ADDED_TO_STAGE, initGame);
		}
		
		private function initGame(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initGame);
			
			noteLoader.addEventListener(Event.COMPLETE, onNoteLoaded);
			noteLoader.load(new URLRequest(notePath));
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
		
		}
		
		private function onNoteLoaded(e:Event):void
		{
			noteLoader.removeEventListener(Event.COMPLETE, onNoteLoaded);
			note_array = e.target.data.replace("\r", "").split(/\n/);
			
			
			
			var song_name:TextField = new TextField();
			song_name.text = note_array[0];
			addChild(song_name);
			
			var array_size:int = note_array.length;
			block_count = note_array.length - FILE_HEADER_SIZE;
			
			for (var i:int = FILE_HEADER_SIZE; i < array_size; i++)
			{
				block_array.push(new Block().Set(note_array[i]));
				block_array[block_array.length - 1].event_duration = block_pre_display_time;
			}
			
			track = new Sound();
			track.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			track_channel = new SoundChannel();
			
			track.load(new URLRequest(note_array[1].replace("\r", "")));
			track_channel = track.play();
			
			var bkg:Loader = new Loader();
			
			bkg.addEventListener(IOErrorEvent.IO_ERROR, IOError);
			bkg.load(new URLRequest(note_array[2].replace("\r", "")));
			addChild(bkg);
			
			/*var connection:NetConnection = new NetConnection();
			   connection.connect(null);
			   var stream:NetStream = new NetStream(connection);
			   //stream.client = new CustomClient();
			   video.attachNetStream(stream);
			   stream.play("video.avi");
			 addChild(video);*/
			
			track_duration.Init();
			addChild(track_duration);
			
			addChild(score);
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (keyArray.indexOf(e.keyCode) >= 0)
			{
				if (block_active.length)
				{
					var tmp:Block = block_active[0];
					block_active[0].visible = false; //TODO: START DIE ANIMATION
					block_active[0].state = 0;
					block_last.push(block_active.shift());
					score.Change((e.keyCode == tmp.keyID), (tmp.time - track_channel.position) / tmp.event_duration);
					return;
				}
			}
		}
		
		private function keyUp(e:KeyboardEvent):void
		{
			return;
		}
		
		public function enterFrame(e:Event):void
		{
			score.Update();
			
			if ((!pause) && (track) && (track.length))
			{
				if (track_channel)
				{
					track_current_time = track_channel.position;
					track_duration.Update(track_current_time, track.length);
					
					if (track_current_time >= track.length - 1000)
					{
						dispatchEvent(new CustomEvents("game_end"));
					}
				}
				
				//checking NOT ADDED blocks (invisible)
				if (block_array.length)
				{
					//add block to screen
					while (track_current_time > block_array[0].time - block_pre_display_time)
					{
						block_active.push(block_array.shift()); //move to "active" array
						addChild(block_active[block_active.length - 1]);
						if (!block_array.length)
							break;
					}
				}
				
				//checking ACTIVE blocks (on screen, alive)
				if (block_active.length)
				{
					for (var i:int = block_active.length - 1; i >= 0; i--)
					{
						if ((track_current_time > block_active[i].time) && (block_active[i].active))
						{
							block_active[i].active = false;
							block_active[i].event_duration = block_destroy_time;
						}
					}
					
					while (track_current_time > block_active[0].time + block_destroy_time)
					{
						block_last.push(block_active.shift()); //move to die animation 
						score.Change(false, 1);
						if (!block_active.length)
							break;
					}
					
					for each (var bl:Block in block_active)
					{
						bl.DrawUpdate((track_current_time - bl.time) / bl.event_duration); //update all blocks
					}
				}
				
				//checking OLD blocks (on screen, die animation)
				if (block_last.length)
				{
					if (track_current_time > block_last[0].time + block_destroy_time)
					{
						removeChild(block_last[0]);
						block_last.shift();
					}
					
					for (var j:int = block_last.length - 1; j >= 0; j--)
					{
						block_last[j].DrawUpdate((track_current_time - block_last[j].time) / block_last[j].event_duration);
					}
				}
			}
		}
	}
}