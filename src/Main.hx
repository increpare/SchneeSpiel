import haxegon.*;
import utils.*;
import Globals.*;


class Main {	

	function init(){
		Gfx.resizescreen(160, 120, true);
		//Truetype fonts look a LOT better when we don't scale the canvas!
		//Gfx.resizescreen(0, 0);
		Text.font = GUI.font;

		//initial all globals here

		if (!Save.exists("language")){
			Save.savevalue("language",1);
		}
		state.sprache = Save.loadvalue("language");
		if (state.sprache==0){
			state.sprache=0;//ok does't do much			
		}
	}	

	function update() {	
		//88045 swap
		//35423 submit
		//34195 submit 2
		//99487 bad
		if (Input.justpressed(Key.E)){
			var r = Random.int(0,100000);
			trace(r);
			mPlayNote(r,30.0,0.3,1.0);
		}
		// Draw a white background
		Gfx.clearscreen(PAL.bg);
		var h = Gfx.screenheight;
		var w = Gfx.screenwidth;
		Text.wordwrap=w;


		Text.size=GUI.titleTextSize;
		Text.display(Text.CENTER,10,S("Spiel des Schnees","Snow Game"), PAL.titelFarbe);
		
		if (IMGUI.button( 
				Text.CENTER,
				Math.round(30),
				S("SPIEL","PLAY")
			)) {			
			Sound.play("blip3");
			Scene.change(EinSpieler);
		//	Scene.change(szene.CharakterAuswahl);
		}

		if (IMGUI.schalter( 
			Text.CENTER,
			Math.round(50),
		S("DE","DE"),
		S("EN","EN"),
		1-state.sprache)){
			state.sprache=1-state.sprache;
			Save.savevalue("language",state.sprache);
			Sound.play("blip3");
		}
		
		Text.display(Text.CENTER,70,S("Steurung:\noben, links, rechts","Controls:\nUp, Left, Right"), PAL.titelFarbe);

		Text.size=1;
		
	}
}
