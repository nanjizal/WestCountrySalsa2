package westCountrySalsa;

import simpleText.SimpleText;
import kha.Assets;
import kha.Color;
class Title {
	public static var fontColor: Int = 0xFFFF5210;
	public static var size:      Int = 22;
    public var content:          String = 
"West Country Salsa";
	public var txt: SimpleText;
	public function new(){	
		var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Bold
                                    ,   size:       size
                                    ,   color:      fontColor
                                    ,   alpha:      1.
                                    ,   range:      new AbstractRange( { begin: 0, end: content.length } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  -4.
                                    ,   hAlign:     CENTRE
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