fl.outputPanel.clear()
// clean the library
for( var i in fl.getDocumentDOM().library.items){
	fl.getDocumentDOM().library.editItem(fl.getDocumentDOM().library.items[i].name);
	cleanTimeline(fl.getDocumentDOM().getTimeline(),"");
}
// clean time line of the movieclip
cleanTimeline(fl.getDocumentDOM().getTimeline(),"");
// look through every layer
function cleanTimeline(tl){
	for (var i=0;i<tl.layers.length;i++){
		cleanLayer(tl.layers[i]);
	}
}
// look through every frame
function cleanLayer(ly){
	for(var i=0;i<ly.frames.length;i++){
		cleanFrame(ly.frames[i],i);
	}
}
// look through every element
function cleanFrame(fr,fn){
	for(var i=0;i<fr.elements.length;i++){
		cleanElement(fr.elements[i]);
	}
}
// adjust element x,y positions on the stage.
function cleanElement(el){
	var px=el.x;
	var py=el.y;
	el.x=Math.ceil(px);
	el.y=Math.ceil(py);
	if(!(px==el.x||py==el.y)){
		fl.trace("->Stage Element: "+el.name);
		fl.trace("->Before: x=" +px+", y="+py);
		fl.trace("->After: x=" +el.x+", y="+el.y);
	}
}
