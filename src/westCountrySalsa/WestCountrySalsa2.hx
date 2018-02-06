package westCountrySalsa;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Image;
import kha.Assets;
import kha.System;
import kha.FastFloat;
import tweenx909.TweenX;
import tweenx909.EaseX;
import simpleText.SimpleText;
import westCountrySalsa.LatinoSundays;
import westCountrySalsa.MouseAndKey;
import westCountrySalsa.SalsaThursdays;
import westCountrySalsa.SalsaClasses;
import westCountrySalsa.Title;
import westCountrySalsa.Contact;
class WestCountrySalsa2 {
    var img: Image;
    public var scalableImage:   ScalableImage;
    public var sundayTxt:       SimpleText;
    public var thursdayTxt:     SimpleText;
    public var salsaClassesTxt: SimpleText;
    public var titleTxt:        SimpleText;
    public var contactTxt:      SimpleText;
    public var sundayScalable:  ScalableText;
    public var thursdayScalable:ScalableText;
    public var contactScalable: ScalableText;
    public var allTxt: Array<SimpleText> = [];

    public function new() {
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        setup();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
    }
    
    public function setup(){
        createText();
        layout();
        var mouseAndKey = new MouseAndKey();
        mouseAndKey.change = checkTextHit;
        dirty();
    }

    function layout(){
        var mainHi = Main.hi;
        var mainWid = Main.wid;
        var size = ( mainHi > mainWid )? mainWid: mainHi;
        var scale = size/768;
        var spacing = 30*scale;
        var midW = mainWid/2;
        scalableImage.scale = scale;
        sundayScalable.scale = scale;
        thursdayScalable.scale = scale;
        contactScalable.scale = scale;
        var dh = ( mainHi - scalableImage.height - thursdayScalable.height - spacing )/2;
        var dwc = ( mainWid - scalableImage.width )/2;
        scalableImage.x = dwc;
        scalableImage.y = dh*0.66666;
        sundayTxt.x = mainWid/2 - spacing - sundayScalable.width;
        sundayTxt.y = dh*0.66666 + scalableImage.height + spacing*0.66666;
        thursdayTxt.x = midW + spacing;
        thursdayTxt.y = sundayTxt.y;
        contactTxt.x = midW - contactScalable.width/2;
        contactTxt.y = scalableImage.y + scalableImage.height - contactScalable.height;
        localWid = mainWid;
        localHi = mainHi;
        dirty();
    }

    function createText(){
        var latinoSundays = new LatinoSundays();
        sundayTxt = latinoSundays.txt;
        allTxt.push( sundayTxt );
        var salsaThursdays = new SalsaThursdays();
        thursdayTxt = salsaThursdays.txt;
        allTxt.push( thursdayTxt );
        /*
        var salsaClasses = new SalsaClasses();
        salsaClassesTxt = salsaClasses.txt;
        allTxt.push( salsaClassesTxt );
        var title = new Title();
        titleTxt = title.txt;
        */
        var contact = new Contact();
        contactTxt = contact.txt;
        allTxt.push( contactTxt );
        img = Assets.images.westCountrySalsa2icon2;
        scalableImage       = new ScalableImage( img );
        sundayScalable      = new ScalableText( sundayTxt );
        thursdayScalable    = new ScalableText( thursdayTxt );
        contactScalable     = new ScalableText( contactTxt );
    }
    function dirty(){
        for( t in allTxt ) t.dirty = true;
    }
    var selection: Selection = LINE;
    var accurate: Hit = WITHIN;
    function checkTextHit( x: Int, y: Int ){
        var highlight = true;
        var hit       = accurate;
        var str = sundayTxt.hitString( x, y, selection, hit, highlight );
        if( str != '' ) { 
            trace( 'hit '+ selection + ' = '  + str );
            dirty();
        }
    }
    function update(): Void {
    }
    var localWid: Int = 0;//1024;
    var localHi: Int  = 0;//768;
    function render( framebuffer: Framebuffer ):Void {
        //if( !sundayTxt.dirty ) return;
        if( Main.hi != localHi || Main.wid != localWid ){
            layout();
        }
        var g2 = framebuffer.g2;
        g2.begin();
        g2.clear( Color.fromValue( 0xff9B7031 ) );
        g2.color = Color.White;
        g2.opacity = 1.;
        scalableImage.render( g2 );
        var count: Int = 0;
        for( t in allTxt ) {
            if( t.fontStyle.alpha != 0 ) t.render( g2 );
        }
        g2.end();
    }
}