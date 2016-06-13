// Reference for Intellisense and Import/s for dynamic module loading (see also requireModules.js)
//
// Intellisense and import (pair/s) for required modules:
/// <reference path="../../typings/jquery/jquery.d.ts" />
/// <amd-dependency path="js/jquery/jquery"/>
// NOTE: the jquery module is loaded globally by compiled define() (with amd-dependency) and the '$' is always available
//declare let $: JQuery;
//
// AngularJS Binding with Typescript
//  https://docs.angularjs.org/api
//  http://www.html.it/pag/52588/angularjs-e-un-framework-non-una-libreria/
//  http://docs.telerik.com/kendo-ui/AngularJS/introduction
/// <reference path="../../typings/angularjs/angular.d.ts"/>
/// <amd-dependency path="js/angular/angular"/>
// NOTE: the angular module is loaded globally compiled define() (with amd-dependency) and the 'angular' is always available
var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
define(["require", "exports", 'ooLib/BaseObjects', "js/jquery/jquery", "js/angular/angular"], function (require, exports, BaseObjects_1) {
    "use strict";
    /**
     * Binding module
    */
    var Bindings;
    (function (Bindings) {
        // Define shortcut alias and imports
        //import _objs = ooLib.BaseObjects;
        // Constants
        //const _bindRoot = "_Bind";
        /**
         * Data binding class for bidirectional link/s on the view
         */
        var DataBinding = (function (_super) {
            __extends(DataBinding, _super);
            //
            /**
                * DataBinding constructor
                * @param {any} ctrlID identify the container of the view (see jquery selector) or id of DOM element
                *   - Specify id with the classic jquery '#' prefix or other selector for identify the control ID (DOM element)
                *   - Specify DOM element (object)
                * @param {string} viewID identify the view container of the controls to be bind (for AngularJS is the ng-app attribute)
                * @param {string[]} modules can specify the optional modules (for AngularJS see 2nd parameter of angular.module, http://www.html.it/pag/53891/i-moduli-angularjs/)
                * @param {Function} configFn can specify optional function for configuration (for AngularJS see 3th parameter of angular.module)
                * @param {Document} doc can specify the optional document or element root if different from the current
                */
            function DataBinding(ctrlID, viewID, description, modules, configFn, doc) {
                _super.call(this, (description ? description : "DataBinding:" + viewID));
                // Counter of generic bind (without specific ng-model) added to the view
                this._genBind = 0;
                this._viewID = viewID;
                // Verify parameters and identify the view control
                var ctrl = this.identifyControl(ctrlID);
                if (!ctrl)
                    throw new Error("DataBinding.constructor(): invalid 'ctrlID' parameter for view container, must be valid jquery id, data model name (ng-model) or DOM element");
                // Verify for valid model name in the element object
                var m = ctrl.attr("ng-controller");
                if (m != viewID) {
                    // Store the ng-app and ng-controller in the object tag
                    // NOTE: for the controller use the same name of the app
                    //ctrl.attr("ng-app", viewID);
                    ctrl.attr("ng-controller", viewID);
                }
                // Initialize the module and bootstrap
                if (!doc)
                    doc = document;
                this._ngModule = angular.module(viewID, modules || [], configFn);
                angular.bootstrap(doc, [viewID]); // angular bootstrap for view and model initialization
            }
            ;
            /**
            * @description Add new data binding connection for view control (by id) and data model (or object path)
            * @param {any} ctrlID identify the control in the view (see jquery selector) or id of DOM element
            *   - Specify id with the classic jquery '#' prefix or other selector for identify the control ID (DOM element)
            *   - Specify DOM element (object)
            * @param {string} model variable name or data path of object stored in the scope
            * @param {any} data data variable initialization or data object to bind in the scope (for AngularJS is the ng-model attribute)
            *                   NOTE: For multi-level path must be set base object in the 'data'
            *                         If base object is already defined in the scope will be combined with the old values (see also $.extend)
            *                           for example, see the follow 2 bind (for inputs element in the view):
            *                               addBind("inputName","subject.name",{name:'Daniele', surname:'',company:'LogiCode',site:'www.logicode.it'});
            *                               addBind("inputSurname","subject.surname",{surname:'magliacani'});
            *                           the resultant 'subject' object content in the scope after the bindings is:
            *                               {name:'Daniele', surname:'Magliacani',company:'LogiCode',site:'www.logicode.it'}
            * @returns {string} the model name (ng-model) used for this binding (see ctrlID for details)
            */
            //  * @param {string } forceNativeIDForEvent optional DOM event for custom binding (see jquery .on()), in this case ctrlID must be the id of DOM element
            DataBinding.prototype.addBind = function (ctrlID, model, data //,
                ) {
                // Verify parameters and identify the control
                if (!model || model == "")
                    throw new Error("DataBinding.addBind(): missing or invalid data 'model' parameter, required for valid bind");
                var ctrl = this.identifyControl(ctrlID);
                if (!ctrl)
                    throw new Error("DataBinding.addBind(): invalid 'ctrlID' parameter, must be valid jquery id, data model name (ng-model) or DOM element");
                // Activate the angular controller for the data
                // NOTE: use the same name of the module
                //this._ngModule.controller(ctrlID).run(function (scope?: ng.IScope) {       // can implement also the filter parameter and others, see http://www.html.it/pag/53418/filtri-nel-controller/ and http://www.html.it/pag/54118/configurazione-del-routing/
                this._ngModule.controller(this._ngModule.name, function (scope) {
                    // Initialize the data scope (two-way binding by angular managed event and internal digest loop)
                    // http://www.html.it/pag/54317/watch-e-digest-loop/
                    var sgm = model.split("."); // Identify data model segments (if complex)
                    var s, obj = scope; // Inizialize the base object with scope
                    //if (!obj[_bindRoot])
                    //    // Initialize the root of bindigs values/objects in the scope
                    //    obj[_bindRoot] = {};
                    //obj = obj[_bindRoot];
                    for (s in sgm) {
                        // Identify the current value / object in the scope (model)
                        if (s == sgm.length - 1) {
                            // Base value or last model segment
                            if (data)
                                obj[sgm[s]] = data;
                        }
                        else if (s == 0) {
                            if (data)
                                // Extend previous object if already defined
                                obj[sgm[s]] = $.extend({}, obj[sgm[s]], data);
                            else if (!obj[sgm[s]])
                                // Initialize object for next data model
                                obj[sgm[s]] = {};
                        }
                    }
                    //// Activate optional behavior for native DOM event or data object
                    //if (forceNativeIDForEvent) {
                    //    // Set native event with DOM element id
                    //    // http://www.html.it/pag/54402/apply-e-il-contesto-angular/
                    //    var ctrl: JQuery = $("#" + ctrlID);
                    //    ctrl.on(forceNativeIDForEvent, function (evt: JQueryEventObject, ...args: any[]) {
                    //        //document.getElementById(ctrlID).addEventListener(forceNativeIDForEvent, function () {
                    //        scope.$apply(function (scope: ng.IScope) {
                    //            scope[_bindPrefix + ctrlID] = (model ? data[model] : data);
                    //        });
                    //    });
                    //}
                    //
                    //if (ctrl) {
                    // Verify for valid model name in the element object
                    var m = ctrl.attr("ng-model");
                    if (m != model) {
                        // Store the model name in the object tag
                        ctrl.attr("ng-model", model);
                        // Bind for changes with a watch
                        // http://www.html.it/pag/54404/creare-un-watch-in-angularjs/
                        //scope.$watch(_bindRoot, function (newValue: string, oldValue: string, scope: ng.IScope) {
                        scope.$watch(model, function (newValue, oldValue) {
                            if (newValue != oldValue)
                                alert("Il nuovo valore è " + newValue);
                            //}, true);
                        });
                    }
                    //}
                    // Memorize last scope
                    this._lastBindScope = scope;
                });
                // Return the ng-model
                return model;
            };
            /**
             * Identify the real ctrl (jquery)
             * @param {any} ctrlID can be id of DOM element (with jquery prefix '#') or DOM object
             * @return {JQuery} return the jquery object for the control element (if identified or undefined)
             */
            DataBinding.prototype.identifyControl = function (ctrlID) {
                // Identify the model name (ng-model)
                var name, ctrl, id;
                if ($.type(ctrlID) == "string") {
                    // Identify the ng-model in the tag element
                    id = ctrlID;
                    if (ctrlID.charAt(0) == '#')
                        // Set object to verify
                        ctrl = $(id);
                }
                else
                    ctrl = ctrlID;
                //
                return ctrl;
            };
            /**
             * Refresh the view with the data model values
             * @param scope is the scope of data-model to refresh, if missing use scope of last added bind
             */
            DataBinding.prototype.refreshView = function (scope) {
                // http://www.html.it/pag/54402/apply-e-il-contesto-angular/
                (scope || this._lastBindScope).$apply(function () {
                    // Refresh ALL data models in the scope for view contents update
                });
            };
            /**
             * Refresh the control by the data model value
             * @param {any} ctrlID can be id of DOM element (with jquery prefix '#') or DOM object
             * @param {any} data data variable initialization or data object to bind in the scope (see addBind for details)
             * @param scope is the scope of data-model to refresh, if missing use scope of last added bind (see angular for details)
             * @returns {string} the model name (ng-model) used for this binding (see addBind for details)
             *          NOTE: if the control not have a bind added return empty model name.
             */
            DataBinding.prototype.refreshCtrl = function (ctrlID, data, scope) {
                var model = this.identifyControl(ctrlID).attr("ng-model");
                if (model)
                    this.refreshValue(model, data, scope);
                return model;
            };
            /**
             * Refresh the control/s by the data model value
             * @param {any} ctrlID can be id of DOM element (with jquery prefix '#') or DOM object
             * @param {any} data data variable initialization or data object to bind in the scope (see addBind for details)
             * @param scope is the scope of data-model to refresh, if missing use scope of last added bind (see angular for details)
             * @returns {string} the model name (ng-model) used for this binding (see addBind for details)
             */
            DataBinding.prototype.refreshValue = function (model, data, scope) {
                // http://www.html.it/pag/54402/apply-e-il-contesto-angular/
                if (!scope)
                    scope = this._lastBindScope;
                scope.$apply(function () {
                    // Refresh data model in the scope for control content update
                    scope[model] = (data || scope[model]);
                });
            };
            return DataBinding;
        }(BaseObjects_1.BaseObjects.Binding));
        Bindings.DataBinding = DataBinding;
    })(Bindings = exports.Bindings || (exports.Bindings = {}));
});
//# sourceMappingURL=Binding.js.map