/*
* 
* Usage ClickOverState
* 
* 
* 
* 	var _root:Object;
* 	var _state:ClickOverState = new ClickOverState(_root, click_mc, expand_mc, main_mc.containerText.text_mc, false);
* 	_state.adsId = "<banner id>";
* 	_state.addEventListener("EXPANDED_BUTTON", handleExpandedBtn);
* 	_state.addEventListener("CLICKED_BUTTON", handleClickedBtn);
* 	
*	function handleExpandedBtn(e:Event):void {
*		try {
*			_root.dispatchEvent ("expanded");
*			_root.open();
*		} catch (e:Error) {
*			trace ("Error! _root não encontrado");
*		}
* 	}
	
*	function handleClickedBtn(e:Event):void {
*		try {
*			_root.dispatchEvent ("click");
*			_root.dispatchEvent ("expanded");
*			_root.open();
*		} catch (e:Error) {
*			trace ("Error! _root não encontrado");
*		}
*	}
* 
*/

package br.com.casi.state {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.display.MovieClip;
	import flash.net.SharedObject;
	import flash.events.Event;

	/**
	 * @author cardevisi
	 */
	 
	public class ClickOverState extends Sprite {

		private var shared:SharedObject;
		private var ___root:Object;
		public var _clickBtn:MovieClip;
		public var _expandBtn:MovieClip;
		public var _containerText:MovieClip;
		public var _shared:String;
		private var _adsId:String;

		public function ClickOverState (obj:Object, clickBtn:MovieClip, expandBtn:MovieClip, containerText:MovieClip, debug:Boolean) {
			
			___root = obj;

			_clickBtn = clickBtn;
			_clickBtn.buttonMode = true;
			_clickBtn.visible = false;
			_clickBtn.addEventListener (MouseEvent.CLICK, onClickHanlder, false, 0, true);
			
			_expandBtn = expandBtn;
			_expandBtn.visible = true;
			_expandBtn.buttonMode = true;
			_expandBtn.addEventListener(MouseEvent.MOUSE_OVER, onPassOverHandler, false, 0, true);
			_expandBtn.addEventListener(MouseEvent.CLICK, onPassClickHandler, false, 0, true);
			
			_containerText = containerText;
			
			shared = SharedObject.getLocal("reloaded");
			
			if(debug) {
				shared.clear();
			}

			if (shared.data.visits != undefined){
				_expandBtn.visible = false;
				_clickBtn.visible = true;
				_containerText.gotoAndStop(2);
			}
		}

		private function onClickHanlder (e:MouseEvent):void {
			if (ExternalInterface.available) {
				ExternalInterface.call (adsId+".customClientTracker", "mouse_click");
			}
			dispatchEvent(new Event("CLICKED_BUTTON", true));
		}

		function onPassClickHandler (e:MouseEvent):void {
			if (ExternalInterface.available) {
				ExternalInterface.call (adsId+".customClientTracker", "mouse_click");
			}
			dispatchEvent(new Event("CLICKED_BUTTON", true));
		}

		private function onPassOverHandler (e:MouseEvent):void {
			shared = SharedObject.getLocal("reloaded");
			if (shared.data.visits == undefined) {
				dispatchEvent(new Event("EXPANDED_BUTTON", true));
				shared.data.visits = 1;
			} else {
				shared.data.visits++;
				_expandBtn.visible = false;
				_clickBtn.visible = true;
				_containerText.gotoAndStop(1);
			}
			shared.close ();
			if (ExternalInterface.available) {
				ExternalInterface.call (adsId+".customClientTracker", "mouse_over");
			}
		}
		
		public function set adsId(value:String):void {
			_adsId = value;
		} 
		
		public function get adsId():String {
			return _adsId;
		}
		
	}
}
