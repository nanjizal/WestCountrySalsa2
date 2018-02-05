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
    public var sundayTxt:       SimpleText;
    public var thursdayTxt:     SimpleText;
    public var salsaClassesTxt: SimpleText;
    public var titleTxt:        SimpleText;
    public var contactTxt:      SimpleText;
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
        var contact_ = contactTxt;
        var thursday = thursdayTxt;
        var sunday = sundayTxt;
        if( scale == 1. ){
            TweenX.to( this,{ imgAlpha: 1. } ).delay( 0.5 ).time( 0.8 ).ease( EaseX.quadIn );
            TweenX.to( this,{ val: 1. } ).delay( 0.72 ).time( 0.65 ).ease( EaseX.quadIn ).onUpdate( function(){
                thursday.tweenParam = val;
                sunday.tweenParam = val;
                thursday.fontStyle.alpha = val;
                sunday.fontStyle.alpha = val;
                contact_.fontStyle.alpha = val;
            } ).onFinish( function(){
                thursday.tweenParam = 1.;
                sunday.tweenParam = 1.;
                contact_.fontStyle.alpha = 1.;
                tweening = false;
                dirty();
            });
        } else {
            contactTxt.tweenParam = 1.;
            thursdayTxt.tweenParam = 1.;
            sundayTxt.tweenParam = 1.;
        }
        dirty();
    }
    var dh: Float;
    var imgX: Float;
    var imgY: Float;
    var img: Image;
    var scale: Float = 1.;
    var isLeft: Bool = false;
    function layout(){
        var mainHi = Main.hi;
        var mainWid = Main.wid;
        sundayTxt.fontStyle.hAlign = RIGHT;
        sundayTxt.fontStyle.size = 20;
        thursdayTxt.fontStyle.hAlign = LEFT;
        thursdayTxt.fontStyle.size = 20;
        contactTxt.fontStyle.size = 18;
        salsaClassesTxt.fontStyle.size = 20;
        sundayTxt.calculateDimensions();
        thursdayTxt.calculateDimensions();
        salsaClassesTxt.calculateDimensions();
        contactTxt.calculateDimensions();
        var dw = ( mainWid - thursdayTxt.width - sundayTxt.width)/3;
        if( dw > 20 ) dw /= 4;
        if( dw < 10 || mainHi < thursdayTxt.height + 30 ) {
            sundayTxt.fontStyle.size = 15;
            thursdayTxt.fontStyle.size = 15;
            sundayTxt.calculateDimensions();
            thursdayTxt.calculateDimensions();
            sundayTxt.x =  10;
            thursdayTxt.x = mainWid - 10 - thursdayTxt.width;
            sundayTxt.fontStyle.hAlign = LEFT;
            thursdayTxt.fontStyle.hAlign = RIGHT;
        } else {
            sundayTxt.fontStyle.size = 20;
            thursdayTxt.fontStyle.size = 20;
            sundayTxt.x = mainWid/2 - sundayTxt.width - dw;
            thursdayTxt.x =  mainWid/2 + dw;
        }
        isLeft = false;
        if( mainWid < salsaClassesTxt.width || mainHi <  salsaClassesTxt.height + 30 ){
            salsaClassesTxt.fontStyle.size = 12;
            salsaClassesTxt.x   = 10;
            salsaClassesTxt.fontStyle.dAdvanceY = 0.;
            salsaClassesTxt.fontStyle.hAlign = LEFT;
            titleTxt.x = 10;
            titleTxt.fontStyle.hAlign = LEFT;
            contactTxt.fontStyle.hAlign = LEFT;
            isLeft = true;
        } else {
            salsaClassesTxt.fontStyle.size = 20;
            salsaClassesTxt.x   = mainWid/2 - salsaClassesTxt.width/2;
            salsaClassesTxt.fontStyle.dAdvanceY = -4.;
            salsaClassesTxt.fontStyle.hAlign = CENTRE;
            titleTxt.fontStyle.hAlign = CENTRE;
            contactTxt.fontStyle.hAlign = CENTRE;
        }
        if( mainWid < sundayTxt.width + thursdayTxt.width){
            sundayTxt.fontStyle.alpha = 0.;
            thursdayTxt.fontStyle.alpha = 0.;
            salsaClassesTxt.fontStyle.alpha = 1.;
        } else {
            if( tweening == false ){
                sundayTxt.fontStyle.alpha = 1.;
                thursdayTxt.fontStyle.alpha = 1.;
            }
            salsaClassesTxt.fontStyle.alpha = 0.;
        }
        img = Assets.images.westCountrySalsa2icon2;
        var h2 =img.height + sundayTxt.height;
        dh = ( mainHi - h2 ) / 3;
        if( dh < 5 ){
            scale = -( 10*3 - mainHi + sundayTxt.height )/ img.height;
            h2 =img.height*scale + sundayTxt.height;
            dh = ( mainHi - h2 ) / 3;
        } else {
            scale = 1.;
        }
        if( scale*img.width+40 > mainWid ) scale = mainWid/(img.width+40 );
        imgX = Std.int( mainWid/2 - scale*img.width/2 );
        var dy = dh*2 + img.height*scale;
        if( scale < 0.2 ){
            dy = titleTxt.height + 15;
            contactTxt.y = titleTxt.height + titleTxt.y - contactTxt.height*0.3;
        } else if( img.height*scale < contactTxt.width + 50 ){
            contactTxt.fontStyle.size = 16;
            contactTxt.calculateDimensions();
            contactTxt.y = scale*img.height + dh;
            dy += 8;
        } else {
            contactTxt.y = scale*img.height + dh - contactTxt.height - 5;
        }
        if( !isLeft ) {
            contactTxt.x = mainWid/2 - contactTxt.width/2;
        } else {
            contactTxt.x = 10;
            titleTxt.fontStyle.hAlign = LEFT;
            titleTxt.x = 10;
        }
        salsaClassesTxt.y   = dy;
        thursdayTxt.y       = dy;
        sundayTxt.y         = dy;
        localWid = mainWid;
        localHi = mainHi;
        dirty();
    }
    var tweening: Bool = true;
    var val: Float = 0.8;
    var imgAlpha: Float = 0.;
    function createText(){
        var latinoSundays = new LatinoSundays();
        sundayTxt = latinoSundays.txt;
        sundayTxt.fontStyle.alpha = -0.7;
        var sunday = sundayTxt;
        sundayTxt.fy = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            return py + 50* Math.sin( 2*( px + charWid/2 ) * Math.PI/180 ) + sunday.height*2;
        }
        sundayTxt.fx = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            return sunday.x;
        }
        sundayTxt.tweenParam = 0.;
        allTxt.push( sundayTxt );
        var salsaThursdays = new SalsaThursdays();
        thursdayTxt = salsaThursdays.txt;
        var thursday = thursdayTxt;
        thursdayTxt.fy = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            return py + 50* Math.sin( 2*( px + charWid/2 ) * Math.PI/180 ) + thursday.height*2;
        }
        thursdayTxt.fx = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            return thursday.x + thursday.width;
        }
        thursdayTxt.tweenParam = 0.;
        thursdayTxt.fontStyle.alpha = -0.7;
        allTxt.push( thursdayTxt );
        var salsaClasses = new SalsaClasses();
        salsaClassesTxt = salsaClasses.txt;
        allTxt.push( salsaClassesTxt );
        var title = new Title();
        titleTxt = title.txt;
        var contact = new Contact();
        contactTxt = contact.txt;
        contactTxt.fontStyle.alpha = 0.;
        allTxt.push( contactTxt );
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
        if( scale > 0.2 ){
            g2.opacity = imgAlpha;
            g2.drawScaledImage( img, imgX, dh + ( imgAlpha - 1 )*10, Std.int( img.width * scale ), Std.int( img.height * scale ) );
            g2.opacity = 1.;
        } else {
            if( localWid < 520 ){
                titleTxt.wrapWidth = 200;
                titleTxt.calculateDimensions();
            } else {
                titleTxt.wrapWidth = 520;
                titleTxt.calculateDimensions();
            }
            if( !isLeft ) titleTxt.x = localWid/2 - titleTxt.width/2;
            titleTxt.render( g2 );
        }
        var count: Int = 0;
        for( t in allTxt ) {
            if( t.fontStyle.alpha != 0 ) t.render( g2 );
        }
        g2.end();
    }
}