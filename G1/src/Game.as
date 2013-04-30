package
{
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
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
	
	/**
	 * ...
	 * @author ArtZilla
	 */
	public class Game extends Sprite
	{
		public static var keyArray:Array = [Keyboard.D, Keyboard.A, Keyboard.S, Keyboard.W, Keyboard.RIGHT, Keyboard.LEFT, Keyboard.DOWN, Keyboard.UP];
		public static var typeArr:Array = ["●", "■", "✖", "▲", "→", "←", "↓", "↑"]; //↑　→　↓　←　×　Ⅹ　〇　✖　□ ■　▲　●　○　∆　⇦　♦ ▲ ► ▼ ◄
		public static var colorArr:Array = [0xFF0000, 0xFF00FF, 0x00FF00, 0x0000FF, 0xFF0000, 0xFF00FF, 0x00FF00, 0x0000FF];
		public static var colorArrBkg:Array = [0xFFCCCC, 0xFFCCFF, 0xCCFFCC, 0xCCCCFF, 0xFFCCCC, 0xFFCCFF, 0xCCFFCC, 0xCCCCFF];
		public static var colorArrSdw:Array = [0x330000, 0x330033, 0x003300, 0x000033, 0x330000, 0x330033, 0x003300, 0x000033];
		
		public var notePath:String = "http://files.artzilla.name/game/test/test.anf";
		
		private const FILE_HEADER_SIZE:int = 16;
		
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
		
		public function Game()
		{
			super();
			score.Init();
			
			noteLoader = new URLLoader();
			noteLoader.addEventListener(Event.COMPLETE, onNoteLoaded);
			noteLoader.load(new URLRequest(notePath));
			
			addEventListener(Event.ADDED_TO_STAGE, initGame);
		}
		
		private function initGame(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initGame);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
			addEventListener(Event.ENTER_FRAME, enterFrame, false, 0, true);
		
		}
		
		private function onNoteLoaded(e:Event):void
		{
			noteLoader.removeEventListener(Event.COMPLETE, onNoteLoaded);
			note_array = e.target.data.split(/\n/);
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
			track_channel = new SoundChannel();
			
			track.load(new URLRequest(note_array[1]));
			track_channel = track.play();
			
			var bkg:Loader = new Loader();
			bkg.load(new URLRequest(note_array[2]));
			addChild(bkg);
			
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
					var tmp:Block = block_active[0]; //
					block_active[0].visible = false; //TODO: START DIE ANIMATION
					block_active[0].state = 0; //
					block_last.push(block_active.shift()); //
					score.Change((e.keyCode == tmp.keyID), (tmp.time - track_channel.position) / tmp.event_duration); //change scores
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
			score.Update(); //redraw scores
			
			//if music playing
			if (track_channel)
			{
				track_current_time = track_channel.position; //save current time position
				track_duration.Update(track_current_time, track.length); //update track duration "timeline"
			}
			
			//checking NOT ADDED blocks (invisible)
			if (block_array.length)
			{
				//add block to screen
				while (track_current_time > block_array[0].time - block_pre_display_time)
				{
					block_active.push(block_array.shift()); //move to "active" array
					addChild(block_active[block_active.length - 1]); //add to screen
					if (!block_array.length)
						break; //break if end of array
				}
			}
			
			//checking ACTIVE blocks (on screen, alive)
			if (block_active.length)
			{
				for (var i:int = block_active.length - 1; i >= 0; i--)
				{
					if ((track_current_time > block_active[i].time) && (block_active.active))
					{
						block_active[i].active = false; //deactivate block
						block_active[i].event_duration = block_destroy_time; //change event duration
					}
				}
				
				while (track_current_time > block_active[0].time + block_destroy_time)
				{
					block_last.push(block_active.shift()); //move to die animation 
					score.Change(false, 1); //change player scores
					if (!block_last.length)
						break; //if no more elements then out from "while"
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
					break;
				}
				
				for (var i:int = block_last.length - 1; i >= 0; i--)
				{					
					block_last[i].DrawUpdate((track_current_time - block_last[i].time) / block_last[i].event_duration);
				}
			}
		}
	}
}