package;
import haxegon.*;

#if js
import js.Browser;
#end


class Globals
{
    public static function mPlayNote(seed:Int,frequency:Float,length:Float,volume:Float){
        #if js
        untyped playNote(seed,frequency,length,volume/2);
        #end
    }



  public static var PAL = {
      fg : Col.BLACK,   
      bg : 0xD7D7D7,

      buttonTextCol : Col.BLACK,
      buttonBorderCol : Col.BLACK,
      buttonCol : 0xD7D7D7,
      buttonHighlightCol : 0x444444,
      buttonHighlightCol2 : 0xaaaaaa,
      titelFarbe: Col.BLACK,
  };

  public static var GUI = {
      smalltextsize:1,
      textsize:1,
      buttonTextSize:1,
      buttonPaddingX : 10,
      buttonPaddingY : 1,
      linethickness : 1,
      titleTextSize:1,
      subTitleTextSize:1,
      vpadding:5,
      healthbarheight:10,
      subSubTitleTextSize:1,
      
      screenPaddingTop:15,
      
      font:"dos",
  };

  public static var state = {
      sprache:0,
      auserwaehlte:0,
      ort:0,
  };

  public static function S(de:String,en:String):String{
      if (state.sprache==0){
          return de;
      } else {
        return en;
      }
  }
}