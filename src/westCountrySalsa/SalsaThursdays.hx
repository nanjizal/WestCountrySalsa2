package westCountrySalsa;
import simpleText.SimpleText;
import kha.Assets;
import kha.Color;
class SalsaThursdays {
	public static var fontColor: Int = 0xFF694201;
	public static var size:      Int = 20;
    public var content:          String = 
"SALSA THURSDAYS 
@ The Rose & Crown,
Hinton Charterhouse

from 15th February

£5 entry
7.30pm Salsa lesson
with Justin

Social from 8pm";
	public var txt: SimpleText;
	public function new(){	
		var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Bold
                                    ,   size:       size
                                    ,   color:      fontColor
                                    ,   alpha:      1.
                                    ,   range:      new AbstractRange( { begin: 0, end: content.length } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  -4.
                                    ,   hAlign:     LEFT
                                    };
        txt =  new SimpleText({ x: 0., y: 0.
                            , fontStyle: fontStyle
                            , content: content
                            , wrapWidth: 520
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , highLight: true });
	}
}