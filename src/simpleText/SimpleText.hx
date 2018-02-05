package simpleText;
import kha.Font;
import kha.Color;
import kha.Image;
import kha.graphics4.DepthStencilFormat;  
import kha.graphics4.TextureFormat;
import kha.graphics2.Graphics;
// abstracted from TextAttribute for consideration of allowing multiple text styles.
typedef FontStyle = {
    var font:        Font;
    var size:        Int;
    var color:       Color;
    var alpha:       Float;
    // not currently used but if multi styles is implemented this would be important
    var range:       AbstractRange;
    // spacing of letters and lines
    var dAdvanceX:   Float; // spacing
    var dAdvanceY:   Float; // lineGap
    // Sets the alignment of the text horizontally
    var hAlign:      HAlign;
    // character height + dAdvanceY this is the total height between tops of lines.
    @:optional public var lineHeight:       Float;
    // character height
    @:optional public var charHi:           Float;
}
// Text Horizontal alignment
enum HAlign {
    LEFT;
    RIGHT;
    CENTRE;
    JUSTIFY;
}
// This is used to define the type of mouse selection 
enum Selection {
    CHARACTER;
    WORD;
    LINE;
    //SENTENCE; // not implemented
    //ARBITARY;  // perhaps needed for selecting arbitary text
}
// This defines if the mouse has to above or close for selection
enum Hit {
    WITHIN;
    CLOSE;
}
// The main SimpleText attributes, also see FontAttributes
typedef TextAttributes = {
    // set to dirty when text needs to be re-rendered.
    @:optional public var dirty:            Bool;
    // used to show '_' where space is, mostly a debugging feature, perhaps change to complier switch?
    @:optional var showSpace:               Bool;
    // location on the screen
    @:optional var x:                       Float;
    @:optional var y:                       Float;
    // Consider changing to Array<AbstractFontStyle>
    var fontStyle:                          AbstractFontStyle;
    // Text content of the Simple Text
    var content:                            String;
    // If set it will wrap lines of text that exceed this width
    @:optional var wrapWidth:               Float;
    // TODO: add description
    /**/ @:optional var scrollBreaks:            Array<Int>;
    // the width of each line of the SimpleText 
    /**/ @:optional public var linesWidth:       Array<Float>;
    // TODO: add description
    /**/ @:optional var spaces:                  Array<Int>;
    // Actual calculated width of Textfield can be less than wrapWidth
    /**/ @:optional var width:                   Float;
    // Actual calculated height of Textfield needed to fit text
    /**/ @:optional var height:                  Float;
    // Array of all the letters with postional and character information
    /**/ @:optional public var pos:              Array<AbstractLetter>;
    // Highlight parameters consider refactor to FontStyle ?
    // must set highLight to true for highlight to be allowed 
    @:optional public var highLight:        Bool;
    @:optional var highLightColor:          Color;
    @:optional var highLightAlpha:          Float;
    @:optional var bgHighLightColor:        Color;
    @:optional var bgHighLightAlpha:        Float;
    // By setting a begin and end 'pos' for the highlight has a range to highlight, without nothing is highlighted
    @:optional public var highLightRange:   AbstractRange;
    // Background Color and Alpha behind the text - only hitTest area of width and height
    // likely a wider background is required for anything but testing?   
    @:optional public var bgColor:          Color;
    @:optional public var bgAlpha:          Float;
    // Default background color of each line, not really needed?
    @:optional public var lineColor:        Color;
    @:optional public var lineAlpha:        Color;
    // With _tweenParam, fx, fy it's possible to add special animations.
    @:optional var _tweenParam:       Float; // 0 to 1
    // function ( px: Float, py: Float ) return value
    @:optional public var fx:        Float->Float->Float->Float->Float;
    @:optional public var fy:        Float->Float->Float->Float->Float;
}
// Dimensions
typedef Dimensions = { width: Float, height: Float };
// this defines the start and end of a range of characters to style ( highlight )
typedef Range = { begin: Int, end: Int };
// Stores details of a letter after render and calculation
// consider removing charCode, as str was added for simplicity.
// currently j and i denote two different index of the position of the character, would be ideal to have only one number
// mainly this is used for selection highlighting
typedef Letter = { charCode: Int, i: Int, j: Int, word_i: Int, x: Float, y: Float, width: Float, height: Float, str: String };
// range was not always enough information as it could not hold i and j perhaps lighter selection approach could be used
typedef LetterRange = { begin: AbstractLetter, end: AbstractLetter };
// abstract around FontStyle automatically calculating line height stats.
@:forward
abstract AbstractFontStyle( FontStyle ) to FontStyle from FontStyle {
    public inline 
    function new( s: FontStyle ){
        this = s;
        hi();
    }
    public inline
    function hi(): Float {
        var s = this;
        var hi = s.font.height( s.size );
        s.charHi = hi;
        s.lineHeight = hi + s.dAdvanceY;
        return hi;
    }
}
// Abstract around the Letter ( hitTest ) element, to help with selection
@:forward
abstract AbstractLetter( Letter ) to Letter from Letter {
    public inline 
    function new( l: Letter ){
        this = l;
    }
    public inline
    function withinXY( px: Float, py: Float ){
        return ( withinY( py ) )? withinX( px ): false;
    }
    public inline 
    function withinX( px: Float ): Bool {
        return ( px > this.x && px < this.x + this.width );
    }
    public inline 
    function withinY( py: Float ): Bool {
        return ( py > this.y && py < this.y + this.height );
    }
    public inline 
    function closeY( py: Float, dy: Float ): Bool {
        var uy = py + dy;
        var ly = py - dy;
        var upper = ( uy > this.y && uy < this.y + this.height );
        var lower = ( ly > this.y && ly < this.y + this.height );
        return upper || lower;
    }
    public inline
    function char(){
        return String.fromCharCode( this.charCode );
    }
}
// Abstract around range to detect if a position is within the range, 
// also provides a range iter but not sure if that needs modifying..
@:forward
abstract AbstractRange( Range ) to Range from Range {
    public inline 
    function new( r: Range ){
        this = r;
    }
    public inline 
    function within( pos ):Bool {
        return ( pos >= this.begin && pos <= this.end );
    }
    public inline 
    function iter() {
        return ( this.begin...this.end );
    }
}
// Main SimpleText class
@:forward
abstract SimpleText( TextAttributes ) to TextAttributes from TextAttributes {
    public inline
    function new ( f: TextAttributes ){
        this = f;
        this.dirty = true;
        this._tweenParam = 1.;
    }
    inline function animateX( px: Float, py: Float, charWid: Float, charHi: Float ){
        var tp = this._tweenParam;
        return ( 1 - tp )*this.fx( px, py, charWid, charHi ) + px*tp;
    }
    inline function animateY( px: Float, py: Float, charWid: Float, charHi: Float ){
        var tp = this._tweenParam;
        return ( 1 - tp )*this.fy( px, py, charWid, charHi ) + py*tp;
    }
    // to allow tweening of _tweenParam
    public var tweenParam(get, set) : Float;
    function get_tweenParam() return this._tweenParam;
    function set_tweenParam( val : Float) { 
        this._tweenParam = val;
        this.dirty = true;
        return val; 
    }
    // first pass through the content string to calculate dimensions
    public inline
    function calculateDimensions(): Dimensions {
        var f = this;
        var s = f.fontStyle;

        var content = f.content;

        // style setting
        var font    = s.font;
        var size    = s.size;
        // color
        // alpha
        // range
        var spacing = s.dAdvanceX;
        var lineGap = s.dAdvanceY;
        // align
        var hi = font.height( size );
        s.charHi = hi;
        s.lineHeight = hi + lineGap;

        var len = content.length;
        var pos = 0;
        var maxW = 0.;
        var dW = 0.;
        var dy = 0.;
        var c: Int;
        var letter: String = '';
        var letterW: Float = 0.;
        var desend: Bool = false;
        f.linesWidth = [];
        f.spaces = [];
        f.scrollBreaks = [];
        var noSpaces = 0;
        var wordLen = 0;
        // debug var word = '';
        var dSpace = 0.;  // distance since last space
        while( pos < len ){
            c = StringTools.fastCodeAt( content, pos++ );
            switch( c ){
                case '\n'.code | '\r'.code:
                    if( letter == ' ' ) dW -= letterW + spacing;
                    if( pos != len ) dy += lineGap + hi;
                    if( dW != 0. ) dW -= spacing - 1;
                    if( dW > maxW ) maxW = dW;
                    f.linesWidth.push( dW );
                    dW = 0.;
                    letterW = 0.;
                    if( pos != len - 1 ) desend = false;
                    f.spaces.push( noSpaces );
                    noSpaces = 0;
                    wordLen = 0;
                    dSpace = 0.;
                    // word = ''; debug
                case 'g'.code | 'j'.code | 'y'.code | 'p'.code | 'q'.code:
                    var noStop = true;
                    if( f.wrapWidth != null ) { if( dW > f.wrapWidth ) {
                        if( pos != len ) dy += lineGap + hi;
                        maxW = f.wrapWidth;
                        f.linesWidth.push( dW - dSpace - spacing );
                        dSpace = 0.;
                        dW = 0.;
                        letterW = 0.;
                        if( pos != len - 1 ) desend = false;
                        if( noSpaces > 0 ) noSpaces --;
                        f.spaces.push( noSpaces );
                        noSpaces = 0;
                        pos -= wordLen - 1;
                        f.scrollBreaks.push( pos );
                        pos -= 1;
                        dW += spacing/2;
                        wordLen = 0;
                        noStop = false;
                        // word = ''; debug
                    }}
                    if( noStop ){
                    letter = String.fromCharCode( c );
                    // word += letter; debug
                    letterW = font.width( size, letter );
                    dW += letterW;
                    dW += spacing;
                    dSpace += letterW + spacing;
                    desend = true;
                    wordLen++;
                    }
                default:
                    var noStop = true;
                    if( f.wrapWidth != null ){ if( dW > f.wrapWidth ) {
                        if( pos != len ) dy += lineGap + hi;
                        maxW = f.wrapWidth;
                        f.linesWidth.push( dW - dSpace - spacing );
                        dSpace = 0.;
                        dW = 0.;
                        letterW = 0.;
                        if( pos != len - 1 ) desend = false;
                        if( noSpaces > 0 ) noSpaces --;
                        f.spaces.push( noSpaces );
                        noSpaces = 0;
                        pos -= wordLen - 1;
                        f.scrollBreaks.push( pos );
                        pos -= 1;
                        dW += spacing/2;
                        wordLen = 0;
                        noStop = true;
                        // word = ''; debug
                    }}
                    if( noStop ){
                    letter = String.fromCharCode( c );
                    if( letter == ' ' ) {
                        dSpace = 0.;
                        wordLen = 0;
                        noSpaces++;
                        // word = ''; debug
                    } else { 
                        wordLen++;
                    }
                    // word += letter; debug
                    letterW = font.width( size, letter );
                    dW += letterW;
                    dW += spacing;
                    dSpace += letterW + spacing;
                    }
            }
        }
        if( letter == ' ' ) noSpaces--;
        f.spaces.push( noSpaces );
        dy += hi;
        if( desend ) dy += hi/6;
        if( dW != 0. ) dW -= spacing - 1;
        if( dW > maxW ) maxW = dW;
        f.linesWidth.push( dW );
        f.width = maxW;
        f.height = dy;
        return { width: maxW, height: dy };
    }
    public inline
    function hi(): Float {
        var f = this;
        var s = this.fontStyle;
        var hi = s.font.height( s.size );
        s.charHi = hi;
        s.lineHeight = hi + s.dAdvanceY;
        return hi;
    }
    // second pass through the content string when rendering 
    // it actually generates the Letter hitTest data and draws to screen
    public //inline
    function render( g2: Graphics, ?begin: Bool = false  ): String{
        var f = this;
        var s = f.fontStyle;

        // style setting
        var font    = s.font;
        var size    = s.size;
        var color   = s.color;
        var alpha   = s.alpha;
        // range
        var spacing = s.dAdvanceX;
        var lineGap = s.dAdvanceY;
        // align
        var hi = font.height( size );
        s.charHi = hi;
        s.lineHeight = hi + lineGap;

        var dx = f.x;
        var dy = f.y;
        if( begin ) {
            g2.begin();
            g2.clear( Color.Transparent );
        }
        if( f.dirty ) calculateDimensions();
        var bgAlpha = f.bgAlpha != null;
        var bgColor = f.bgColor != null;

        if( bgColor || bgAlpha ){
            if( bgAlpha ) g2.opacity = f.bgAlpha;
            if( bgColor ) g2.color = f.bgColor;
            g2.fillRect( dx, dy, f.width, f.height );
        }
        var lineAlpha = f.lineAlpha != null;
        var lineColor = f.lineColor != null;
        
        if( lineColor || lineAlpha ){
            if( lineAlpha ) g2.opacity = f.lineAlpha;
            if( lineColor ) g2.color = f.lineColor;
            var dy2 = dy; 
            var hi_ = f.fontStyle.hi();
            for( dw in f.linesWidth ) {
                switch( f.fontStyle.hAlign ){
                    case LEFT:
                        g2.fillRect( dx, dy2, dw, hi_ );
                    case RIGHT: 
                        var dw2 =  f.width - dw;
                        g2.fillRect( dx + dw2, dy2, f.width - dw2, hi_ );
                    case CENTRE:
                        var dw2 = (f.width - dw )/2;
                        g2.fillRect( dx + dw2, dy2, f.width - dw2*2, hi_ );
                    case JUSTIFY:
                        g2.fillRect( dx, dy2, f.width, hi_ );
                }
                dy2 += f.fontStyle.lineHeight;
            }
        }

        // set style
        g2.font     = font;
        g2.fontSize = size;
        g2.opacity  = alpha;
        g2.color    = color;
        
        
        f.pos = [];

        var letter: String;
        var letterW: Float = 0.;
        var dW = 0.;
        var content = f.content;
        
        var c: Int;
        var len = content.length;
        var pos = 0;
        var wid = f.width;
        var count = 0;
        var lineWid = f.linesWidth[ 0 ];
        count++;
        var breaks = 0;
        var spaceNo = 0;
        var word_i = 0;
        var px: Float;
        var py: Float;
        var pw: Float;
        var ph: Float;
        var hlx: Float = 0;
        var hlw: Float = 0;
        var fW: Float;
        while( pos < len ){

            if( f.scrollBreaks[ breaks ] - 1 == pos + 2 ) pos++;
            if( f.scrollBreaks[ breaks ] - 1 == pos + 1) {
                dy += hi + lineGap;
                dW = 0.;
                word_i = 0;
                letterW = 0.;
                lineWid = f.linesWidth[ count ];
                spaceNo = 0;
                count++;
                breaks++;
            }

            c = StringTools.fastCodeAt( content, pos++ );
            switch( c ){
                case '\n'.code | '\r'.code:
                    dy += hi + lineGap;
                    dW = 0.;
                    word_i = 0;
                    letterW = 0.;
                    lineWid = f.linesWidth[ count ];
                    spaceNo = 0;
                    count++;
                default:
                    if( spaceNo > f.spaces[ count - 1 ] ){
                        dy += hi + lineGap;
                        dW = 0.;
                        letterW = 0.;
                        lineWid = f.linesWidth[ count ];
                        spaceNo = 0;
                        if( f.dirty ) f.pos.pop();
                            count++;
                            pos--;
                        } else {
                        dW += letterW;
                        letter = String.fromCharCode( c );
                        if( f.showSpace ) if( letter == ' ' ) letter = '_';  // replace space with char we can see debug
                        var noSpaces = f.spaces[ count - 1 ];
                        px = alignmentX( dx + dW, wid, lineWid, noSpaces );
                        py = dy;
                        if( letter == '_' || letter == ' ' || letter == '.' || letter == ',' || letter == ';' || letter == ';' ){
                            word_i = 0;
                        } else {
                            word_i++;
                        }
                        fW = font.width( size, letter );
                        if( this.fx != null ){
                            px = animateX( px, py, hi, fW );
                        }
                        if( this.fy != null ){
                            py = animateY( px, py, hi, fW );
                        } 
                        //letter = word_i + '';
                        if( f.highLight ){
                            if( f.highLightRange != null ){
                                var doHighLight = f.highLightRange.within( pos );
                                if( doHighLight ){
                                    if( f.highLightRange.begin == pos ){
                                        if( f.bgHighLightAlpha != null ) g2.opacity = f.bgHighLightAlpha;
                                        if( f.bgHighLightColor != null ) g2.color = f.bgHighLightColor;
                                        g2.fillRect( px, py, fW, hi );
                                        hlx = px + fW;
                                    } else {
                                        if( f.bgHighLightAlpha != null ) g2.opacity = f.bgHighLightAlpha;
                                        if( f.bgHighLightColor != null ) g2.color = f.bgHighLightColor;
                                        hlw = px - hlx + fW;
                                        g2.fillRect( hlx, py, hlw, hi );
                                        hlx = px + fW;
                                    }
                                    g2.opacity = f.highLightAlpha;
                                    g2.color = f.highLightColor;
                                    g2.drawString( letter, px, py );
                                } else {
                                    g2.opacity = s.alpha;
                                    g2.color = s.color;
                                    g2.drawString( letter, px, py );
                                }
                            } else {
                                g2.drawString( letter, px, py );
                            }
                        } else {
                            g2.drawString( letter, px, py );
                        }
                        if( f.showSpace ) if( letter == '_' ) {
                            letter = ' '; //replace space with char we can see debug
                        }
                        //pw = font.width( size, letter );
                        ph = hi;
                        var temp = word_i + 47;// c
                        if( f.dirty )f.pos.push( { x:     px, y:      py
                                                    , width: fW, height: ph, i: pos, j: f.pos.length, charCode: temp, word_i: word_i, str: letter } );
                        letterW = fW + spacing;
                        if( letter == ' ' ){
                            if( s.hAlign == JUSTIFY ) letterW += ( wid - lineWid )/(f.spaces[count-1]);
                            spaceNo++;
                        }
                }
            }
        }
        if( f.highLightRange != null ){
         g2.opacity = s.alpha;
         g2.color = s.color;
        }
        if( begin ) g2.end();
        f.dirty = false;
        return '';
    }
    // logic to align text horizontally
    private inline
    function alignmentX( dxdW: Float, wid: Float, lineWid: Float, noSpaces: Int ):Float{
        return switch( this.fontStyle.hAlign ) {
            case RIGHT:
                dxdW + wid - lineWid;
            case CENTRE:
                dxdW + ( wid - lineWid )/2;
            case JUSTIFY:
                if( noSpaces == 0 ){ 
                    dxdW + ( wid - lineWid )/2;
                } else {
                    dxdW;
                }
            case LEFT: 
                dxdW;
            }
    }
    // used for selection of Characters, Words or Lines, Within or Close to the mouse, 
    // Highlighting and/or returning the letters.
    public // inline
    function hitString( px: Float, py: Float, selection: Selection, hit: Hit, highlight: Bool ): String {
        return switch( selection ){
            case CHARACTER:
                var letter: AbstractLetter;
                switch( hit ){
                    case CLOSE:
                        letter = hitLetterNear( px, py );
                        if( letter != null ){
                            if( highlight ) {
                                this.highLightRange = new AbstractRange( { begin: letter.i, end: letter.i } );       
                            }
                            letter.str;
                        } else {
                            if( highlight ){
                                this.highLightRange = null;
                            }
                            '';
                        }
                    case WITHIN:
                        letter = hitLetterWithin( px, py );
                        if( letter != null ){
                            if( highlight ) {
                                this.highLightRange = new AbstractRange( { begin: letter.i, end: letter.i } );       
                            }
                            letter.char();
                        } else {
                            if( highlight ){
                                this.highLightRange = null;
                            }
                            '';
                        }
                }
            case WORD:
                var r: LetterRange;
                switch( hit ){
                    case CLOSE:
                        r = hitWordNear( px, py );
                        if( highlight ) {
                            if( r == null || r.begin == null || r.end == null ){
                                this.highLightRange = null;
                            } else {
                                this.highLightRange = new AbstractRange({ begin: r.begin.i, end: r.end.i });
                            }
                        }
                        stringFromRange( r );
                        '';
                    case WITHIN:
                       //highliteWord( px, py );
                    
                        r = hitWordWithin( px, py );
                        if( highlight ) {
                            if( r == null || r.begin == null || r.end == null ){
                                this.highLightRange = null;
                            } else {
                                this.highLightRange = new AbstractRange({ begin: r.begin.i, end: r.end.i });
                            }
                        }
                        stringFromRange( r );
                        //'';
                        
                }
            case LINE:
                var r: LetterRange;
                //var stable = ( nearLine( px, py ) != null );
                switch( hit ){
                    case CLOSE:
                        r = hitLineNear( px, py );
                        if( highlight ){//&& stable ) {
                            if( r == null || r.begin == null || r.end == null ){
                                this.highLightRange = null;
                            } else {
                                this.highLightRange = new AbstractRange({ begin: r.begin.i, end: r.end.i });
                            }
                        }
                        stringFromRange( r );
                    case WITHIN:
                        r = hitLineWithin( px, py );
                        if( highlight ){//&& stable ) {
                            if( r == null || r.begin == null || r.end == null ){
                                this.highLightRange = null;
                            } else {
                                this.highLightRange = new AbstractRange({ begin: r.begin.i, end: r.end.i });
                            }
                        }
                        stringFromRange( r );
                }
        }
    }
    // if a point is within the SimpleText bounds
    public inline
    function within( px: Float, py: Float ){
        return ( px > this.x && px < this.x + this.width && py > this.y && py < this.y + this.height );
    }
    // if mouse is near a letter
    private inline
    function hitLetterNear( px: Float, py: Float ): AbstractLetter {
        return if( within( px, py ) ){
            var r = hitLineNear( px, py );
            var range = ( r == null || r.begin == null || r.end == null )? null: new AbstractRange( { begin: r.begin.j, end: r.end.j } );
            var minDistance = 100000000.;
            var cx: Float;
            var dx: Float;
            var selected: Int = -1;
            var letter: AbstractLetter;
            var pos = this.pos;
            if( range != null ){
                // Find horizontal nearest letter
                for( i in range.begin...range.end+1 ){
                    letter = pos[ i ];
                    cx = letter.x + letter.width/2;
                    dx = Math.abs( cx - px );
                    if( dx < minDistance ) {
                        minDistance = dx;
                        selected = i;
                    }
                }
                pos[ selected ];
            } else {
                null;
            }
        } else {
            null;
        }
    }
    // if mouse is above a letter
    private inline
    function hitLetterWithin( px: Float, py: Float ): AbstractLetter {
        var f = this;
        var letter: Letter = null;
        for( p in f.pos ){ 
            if( p.withinXY( px, py ) ){
            letter = p;
            break;
        }}
        return letter;
    }
    // if mouse is near a word
    private inline
    function hitWordNear( px: Float, py: Float ): LetterRange {
        var letter = hitLetterNear( px, py );
        return if( letter != null ){
            var f = this;
            var start = letter.j;
            var end = start;
            var begin = start - letter.word_i + 1;
            var l = this.pos.length;
            var y_ = letter.y;
            var p;
            for( i in start...l ){
                p = f.pos[ i ];
                if( p.word_i != 0 && p.y == y_ ){} else {
                    end = i - 1;
                    break;
                }
            }
            { begin: this.pos[begin], end: this.pos[end] };
            //{ begin: letter, end: letter };
        } else {
            null;
        }
    }
    // if mouse is above a word
    private inline
    function hitWordWithin( px: Float, py: Float ): LetterRange {
        var r = hitWordNear( px, py );
        var l = hitLineWithin( px, py );
        return if( l != null && r != null ){
            r;
        } else{
            null;
        }
    }
    // if mouse is near a line of text
    public inline
    function hitLineNear( px: Float, py: Float ): LetterRange {
        var f = this;
        var s = f.fontStyle;
        var l: Int = f.pos.length;
        return if( within( px, py ) ){ 
        var begin: AbstractLetter = null;
        var end: AbstractLetter = null;
        var pos_ = f.pos;
        var p: AbstractLetter = pos_[0];
        var j: Int = l;
        var deltaY = ( s.charHi + s.dAdvanceX )/2 - 2;
        for( i in 0...l ){
            p = pos_[ i ];
            if( j != l ){
                if( p.closeY( py, deltaY ) ){ 
                    end = p;
                } else {
                    break;
                }
            } else if( p.closeY( py, deltaY ) ){
                begin = p;
                j = i;
            }
        }
        ( j == l )? null: { begin: begin, end: end };
        } else {
            null;
        }
    }
    // if mouse is above a line of text
    public inline
    function hitLineWithin( px: Float, py: Float ): LetterRange {
        var f = this;
        var l: Int = f.pos.length;
        return if( within( px, py ) ){ 
        var begin: AbstractLetter = null;
        var end: AbstractLetter = null;
        var pos_ = f.pos;
        var p: AbstractLetter = pos_[0];
        var j: Int = l;
        for( i in 0...l ){
            p = pos_[ i ];
            if( j != l ){
                if( p.withinY( py ) ){ 
                    end = p;
                } else {
                    break;
                }
            } else if( p.withinY( py ) ){
                begin = p;
                j = i;
            }
        }
        ( j == l )? null: { begin: begin, end: end };
        } else {
            null;
        }
    }
    // converts the letters between begin letter and end letter into the String of Letter within the range.
    private inline
    function stringFromRange( lr: LetterRange ): String {
        var pos_ = this.pos;
        return if( lr != null ){
            if( lr.begin == null || lr.end == null ){
                '';
            } else {
                var r = new AbstractRange({begin: lr.begin.j, end: lr.end.j });
                var str = '';
                for( i in r.begin...( r.end + 1 ) ) str += pos_[ i ].str; // .char();
                str;
            }
        } else {
            '';
        }
    }
    // I think this is no longer used can remove?
    public inline
    function nearLine( px: Float, py: Float ): AbstractRange {
        var f = this;
        var s = f.fontStyle;
        var l: Int = f.pos.length;
        return if( within( px, py ) ){ 
        var r = new AbstractRange( { begin: l, end: l-1 } );
        var pos_ = f.pos;
        var p: AbstractLetter = pos_[0];
        var j: Int = l;
        var deltaY = ( s.charHi + s.dAdvanceX )/2 + 2;
        for( i in 0...l ){
            p = pos_[ i ];
            if( j != l ){
                if( p.closeY( py, deltaY ) ){ 
                    r.end = p.j;
                } else {
                    break;
                }
            } else if( p.closeY( py, deltaY ) ){
                r.begin = p.j;
                j = i;
            }
        }
        ( j == l )? null: r;
        } else {
            null;
        }
    }
    // to help with conversion of text to an image if you want to move around without regen
    // note for use with KodeGarden TextureFormat and DeptheStencilFormat should be set to null below.
    @:to
    public function toImage() {
        var img: Image;
        if( this.width == 0 || this.width == null ) {
            var dim = calculateDimensions();
            img = Image.createRenderTarget( Math.ceil( dim.width ), Math.ceil( dim.height ), TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
        } else { //TextureFormat.RGBA32DepthStencilFormat.DepthOnly
            img = Image.createRenderTarget( Math.ceil( this.width ), Math.ceil( this.height ), TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
        }
        render( img.g2, true );
        return img;
    }
}