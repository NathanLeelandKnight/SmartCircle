/********************************************************
* Creator: Nathan Knight
* Date: 2/24/2020
*
* Usage:
* This script is meant to autoredact pdf docs
* for Camila in Canada. The script is ran via a .bat
* file created with the AutoBatch plugin for Acrobat.
* The .bat file will use the Action Wizard in Acrobat
* finally run the Action "AutoRedactJS" which runs
* this script. Refer to Camila, the Action, or the
* following website for more details.
* https://acrobatusers.com/tutorials/auto_redaction_with_javascript/
********************************************************/

//This function will run throught each page applying each annotation
//This should not be changed
function AddMyRedacts(quadList) {
	for(var pg = 0; pg < this.numPages; pg++) {
		for(var index = 0; index < quadList.length; index++) {
			this.addAnnot({
				type:"Redact", page:pg,
				quads:quadList[index],
				alignment: 1,
				repeat:true 
           		});
		}
	}
}

/*******************************************************************
* This is where you can identify the locations you want redacted.
* First create and specify where you would like an annot. Then,
* use the code in this comment block to do so.

var rct = getAnnots(this.pageNum)[0].rect;
var left = rct[0];
var right = rct[2];
var top = rct[3];
var bot = rct[1];
qd = [ [left, top, right, top, left, bot, right, bot] ];
qd.toSource();

* Change the index in getAnnots(this.pageNum)[X].rect for multiple
* annots. This will print the locations of the annot quads. You
* can then assign them to variables. Add each quad to the function
* as arguments.
*******************************************************************/
var qdAddress1 = [[336, 660, 595, 660, 336, 611, 595, 611]];
var qdAddress2 = [[103, 86, 308, 86, 103, 21, 308, 21]];
var qdMarital = [[153, 686, 303, 686, 153, 668, 303, 668]];
var qdSocialSec = [[163, 639, 259, 639, 163, 622, 259, 622]];

AddMyRedacts([qdAddress1, qdAddress2, qdMarital, qdSocialSec]);

//Apply the redactions
//This should not be changed
this.applyRedactions({bKeepMarks: false, bShowConfirmation: false});