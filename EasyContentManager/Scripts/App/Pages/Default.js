/**
* Main entry module for application
*/
define(["require", "exports", 'ooLib/Bindings/Binding', "js/jquery/jquery"], function (require, exports, Binding_1) {
    "use strict";
    // http://notebookheavy.com/2013/05/22/angularjs-and-typescript/
    //static $inject = ['$scope', 'fullNameService', '$location'];  
    /**
     * EasyData main module
     */
    var EasyData;
    (function (EasyData) {
        "use strict";
        //requireModules(reqModules, () => {
        //require(reqModules, () => {
        var Application;
        (function (Application) {
            //declare module Application {
            function initialize() {
                //document.addEventListener('deviceready', onDeviceReady, false);
                //requireModules(reqModules, () => {
                //var bind = new ooLib.Bindings.DataBinding("app");
                var bind = new Binding_1.Bindings.DataBinding("#app", "app");
                var name = "daniele";
                bind.addBind("#bindName", name);
                //});
            }
            Application.initialize = initialize;
        })(Application = EasyData.Application || (EasyData.Application = {}));
        //window.onload = function () {
        Application.initialize();
    })(EasyData || (EasyData = {}));
});
///// <reference path="../typings/jquery/jquery.d.ts" />
//import
//class Test {
//    private _id: string;
//    constructor(id: string) {
//        this._id = id;
//    }
//}
//let tst = new Test(name);
//# sourceMappingURL=Default.js.map