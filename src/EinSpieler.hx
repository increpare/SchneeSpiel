import haxegon.*;
import Globals.*;
class EinSpieler {	

	public static function floatToStringPrecision3(n:Float)
	{		
		if(n==0)
			return "0.000";

		var minusSign:Bool = (n<0.0);
		n = Math.abs(n);
		var intPart:Int = Math.floor(n);
		var p:Float = 1000.0; //pow(10, 3)
		var fracPart = Math.round( p*(n - intPart) );
		var buf:StringBuf = new StringBuf();

		if(minusSign)
			buf.addChar("-".code);
		buf.add(Std.string(intPart));
		if(fracPart==0)
			buf.add(".000");
		else 
		{
			if(fracPart<10)
				buf.add(".00");  
			else if(fracPart<100)
				buf.add(".0"); 
			else
				buf.add("."); 
			buf.add(fracPart);
		}
		return buf.toString();
	}

	var zeit:Float;
	public static var score:Int=0;

	var todo = "";
	var done=false;
	function push(){
		if (Random.bool()){
			todo += "0";
		} else {
			todo += "1";
		}
	}

	function pop(){
		todo = todo.substring(1);
	}

	var particlesx : Array<Int>;
	var particlesy : Array<Int>;
	var particlesl : Array<Int>;

	var snowLife : Int = 30*3;
	
	var particleCount:Int=20;

	function init(){
		sublimed=false;
		moverightcount=0;

		particlesx = new Array<Int>();
		particlesy = new Array<Int>();
		particlesl = new Array<Int>();

		for (i in 0...particleCount){
			particlesx.push(Random.int(51,50+57));
			particlesy.push(Random.int(10,9+57));
			particlesl.push(Random.int(1,snowLife));
		}
		
		px=2;
		py=3;
		pstate=0;
		erstesZug=true;
		moverightcount=0;

		trace("called");
		todo="";
		score = 0;
		for (i in 0...20){
			push();
		}

		zeit=13;
		//Truetype fonts look a LOT better when we don't scale the canvas!
		// Gfx.resizescreen(0, 0);
		Text.font = GUI.font;

		//initial all globals here

		state.sprache = Save.loadvalue("language");
		if (state.sprache==0){
			state.sprache=0;//ok does't do much			
		}
	}	

	var pstate=0;
	var f:Int=0;
	var px:Int=0;
	var py:Int=0;
	var pd:String = "d";

	var snowtimer=0;


	//player state things
	var moverightcount=0;
	var sublimed:Bool;
	var erstesZug:Bool;

	function moveTo(tx,ty):Bool{
		if (sublimed){
			return false;
		}
		if (tx==0 && ty==1){
			//mach nichts
			return false;
		}
		if (tx==0 && ty==3){
			//mach nichts
			return false;
		}
		if (tx==2 && ty==2){
			//mach nichts
			return false;
		}
		if (tx<0 || tx>3 || ty<0 || ty>3){
			return false;
		}
		px=tx;
		py=ty;
		Sound.play("blip3");
		return true;
	}

	function update() {	

		if (Input.justpressed(Key.ESCAPE)){
			haxegon.Scene.change(Main);
			init();
		}

		if (Input.justpressed(Key.LEFT) &&!sublimed){
			erstesZug=false;
			moverightcount=0;
			switch(pd){
				case "u": {
					pd = "l";
				}
				case "d": {
					pd = "r";
					moverightcount=1;
				}
				case "l": {
					pd = "d";
				}
				case "r": {
					pd = "u";
				}
			}
		}

		if (Input.justpressed(Key.RIGHT) &&!sublimed){
			erstesZug=false;
			moverightcount=0;
			switch(pd){
				case "u": {
					pd = "r";
					moverightcount=1;
				}
				case "d": {
					pd = "l";
				}
				case "l": {
					pd = "u";
				}
				case "r": {
					pd = "d";
				}
			}
		}

		if (Input.justpressed(Key.UP)){
			erstesZug=false;
			switch(pd){
				case "u": {
					moveTo(px,py-1);
					moverightcount=0;
				}
				case "d": {
					moveTo(px,py+1);
					moverightcount=0;
				}
				case "l": {
					moveTo(px-1,py);
					moverightcount=0;
				}
				case "r": {
					if (moveTo(px+1,py)){
						moverightcount++;
						trace(moverightcount);
						if (moverightcount==4){
							sublimed=true;
							particlesx[0]=51+49;
							particlesy[0]=10+7;
						}
					}
				}
			}
		}
		
		// Draw a white background		
		Gfx.clearscreen(PAL.bg);

		f++;
		if (f>60){
			f=0;
		}
		if (f>30){
			Gfx.drawimage(51, 10,"bg1");
		}
		else {
			Gfx.drawimage(51, 10,"bg2");
		}

		var cs = 14;
		var rpx:Int=51+2 + cs*px;
		var rpy:Int=10+1 + cs*py;

		var tx = Text.CENTER;
		var ty = 10+57+5;
		
		var toDisplayText=S("Der Schnee ist wunderschoen.","The snow is beautiful.");

		var fx = px;
		var fy = py;
		switch (pd){
			case "u": fy--;
			case "d": fy++;
			case "l": fx--;
			case "r": fx++;
		}

		if (pd=="l"){
			toDisplayText=S("Der Schnee blendet mich.","I'm blinded by the snow.");
		}

		if (fx<0 || fx>3 || fy<0 || fy>3){
			if (!erstesZug){
				toDisplayText=S("Es gibt keine Grenze zwischen Boden und Himmel.","There's no border between earth and sky.");
			}
		}

		if (fx==0 && fy == 1){
			toDisplayText=S("Ein einsamer Baum.","A lonely tree.");
		}

		if (fx==0 && fy == 3){
			toDisplayText=S("Das Meer wird nie einfrieren.","The ocean will never freeze.");
		}

		if (fx==2 && fy == 2){
			toDisplayText=S("Meine Schutzhuette gegen Kaelte","My home. My refuge from cold.");
		}
		
		if (moverightcount==1){
			toDisplayText=S("Mit dem Schnee zu wandern,","Walking along with the snow,");
		} else if (moverightcount==2) {
			toDisplayText=S("sich zur Stroemung seiner gesellen,","drifting along with it,");
		}  else if (moverightcount==3) {
			toDisplayText=S("es ist einfach sich vorzustellen,","it is easy to imagine as if...");
		}  else if (sublimed) {
			toDisplayText=S("das man selbst eine Schneeflocke sein koennte.","...as if you yourself are a snowflake.");
		} 

		Text.display(tx,ty,toDisplayText, PAL.titelFarbe);
		
		if (!sublimed){
			Gfx.drawimage(rpx,rpy,pd);
		}


				//tick particles 

		snowtimer++;
		/*
		if (snowtimer>10){
			snowtimer=0;
			for (i in 0...particleCount){
				particlesx[i]++;
				particlesy[i]+=Random.int(-1,1);
				if (particlesx[i]>50+57){
					particlesx[i]=50;
				}
				if (particlesy[i]<9){
					particlesy[i]=9+57;
				}
				if (particlesy[i]>9+57){
					particlesy[i]=9;
				}
			}
		}*/
		for (i in 0...5){
			var pi = (i+snowtimer*5)%particleCount;
			particlesx[pi]++;
			particlesy[pi]+=Random.int(-1,1);
			if (particlesx[pi]>50+57){
				particlesx[pi]=51;
			}
			if (particlesy[pi]<10){
				particlesy[pi]=9+57;
			}
			if (particlesy[pi]>9+57){
				particlesy[pi]=10;
			}
		}

		for (i in 0...particleCount){
			var px = particlesx[i];
			var py = particlesy[i];
			Gfx.setpixel(px,py,Col.WHITE);
		}

	}
}
