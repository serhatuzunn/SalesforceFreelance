/* eslint-disable no-unused-vars */
/* eslint-disable vars-on-top */
import { LightningElement, track } from 'lwc';
import HallPlanSource from '@salesforce/resourceUrl/RC_HallPlanSources';
import testStyle from '@salesforce/resourceUrl/testStyle';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';



export default class Rc_HallPlan extends LightningElement {

    //testImage = HallPlanSource + '/src/img/available.png';
    IMG_LOGO = HallPlanSource + '/src/img/logo.png';
    IMG_PARCEL = HallPlanSource + '/src/img/parcel.PNG';
    IMG_SAVE512 = HallPlanSource + '/src/img/Save-512.png';
    IMG_SELL = HallPlanSource + '/src/img/sell.png';
    IMG_SELL2 = HallPlanSource + '/src/img/sellable2.png';
    IMG_AVAILABLE = HallPlanSource + '/src/img/available.png';
    IMG_NOTAVAILABLE = HallPlanSource + '/src/img/not-available.png';
    IMG_SAVE2 = HallPlanSource + '/src/img/save2.png';
    IMG_HALLBackground = "background-image: url('" + HallPlanSource + "/src/img/HALL8.png')";
    IMG_HALLBackgroundLeftSide = HallPlanSource + '/src/img/HALL5-info.png';

    get backgroundStyle() {
        //return "background-image:url('"+ HallPlanSource + '/src/img/HALL8.png' + """")";
        var retVal = "background-image:url('";
        retVal += retVal + HallPlanSource + "/src/img/HALL8.png')";
        return retVal;
    }
    connectedCallback() {
        window.console.log("connected callback");
        Promise.all([
            //loadStyle(this, HallPlanSource + '/src/style/style.css')
            loadStyle(this, testStyle)
        ]).then(() => {
            window.console.log("ERROR callback");

        });
    }
    renderedCallback() {
        window.console.log("rendered callback");
        Promise.all([
            loadScript(this, HallPlanSource + '/src/js/jquery-1.12.4.js').then(() => {
                window.console.log('File loaded.');
            }).catch(error => {
                window.console.log("Error 2: Error Occured");
                window.console.log("Error 2: " + error);
                window.console.log("Error 2: " + HallPlanSource + '/src/js/jquery-1.12.4.js');
            }),
        ])
            .then(() => {
                window.console.log('Files loaded.');
            })
            .catch(error => {
                window.console.log("Error : Error Occured");
                window.console.log("Error : " + error);
            });

        const test = this.template.querySelectorAll(".floorplan");

        var hallx = 75;
        var hally = 160;

        /*var hallx =40;
        var hally = 40;*/
        var len = 11.8;
        var text = "";
        var i;
        var j;
        for (j = 0; j < hally + 1; j++) {
            for (i = 0; i < hallx + 1; i++) {

                text += "<div id='";
                text += i + "-" + j;
                text += "' class='room'  style=' top: ";
                text += j * len;
                text += "px;	left: ";
                text += i * len;
                text += "px;'>";
                if (j === 0)
                    text += i;
                if (i === 0)
                    text += j;
                text += "</div>";
            }
        }
        // eslint-disable-next-line @lwc/lwc/no-inner-html
        test[0].innerHTML = text;


    }
}