/**
 * Main entry module for application
*/



// Intellisense and import (pair/s) for required modules:
/// <amd-dependency path="js/jquery/jquery"/>
//declare let $: JQuery;
///
/// <reference path="../ooLib/Bindings/Binding.ts"/>
import {Bindings} from 'ooLib/Bindings/Binding'

// http://notebookheavy.com/2013/05/22/angularjs-and-typescript/
//static $inject = ['$scope', 'fullNameService', '$location'];  

/**
 * EasyData main module
 */
module EasyData {
    "use strict";

    //requireModules(reqModules, () => {
    //require(reqModules, () => {
        export module Application {
        //declare module Application {
            export function initialize() {

                //document.addEventListener('deviceready', onDeviceReady, false);
                //requireModules(reqModules, () => {

                //var bind = new ooLib.Bindings.DataBinding("app");
                var bind = new Bindings.DataBinding("#app", "app");
                var name = "daniele";
                bind.addBind("#bindName", name);

                //});
            }

            //function onDeviceReady() {
            //    // Gestire gli eventi di sospensione e ripresa di Cordova
            //    document.addEventListener('pause', onPause, false);
            //    document.addEventListener('resume', onResume, false);

            //    // TODO: Cordova è stato caricato. Eseguire qui eventuali operazioni di inizializzazione richieste da Cordova.
            //}

            //function onPause() {
            //    // TODO: questa applicazione è stata sospesa. Salvarne lo stato qui.
            //}

            //function onResume() {
            //    // TODO: questa applicazione è stata riattivata. Ripristinarne lo stato qui.
            //}

        }
        

        //window.onload = function () {
            Application.initialize();
        //}
    //}); 

}

///// <reference path="../typings/jquery/jquery.d.ts" />

//import
//class Test {
//    private _id: string;
//    constructor(id: string) {
//        this._id = id;

//    }
//}

//let tst = new Test(name);

