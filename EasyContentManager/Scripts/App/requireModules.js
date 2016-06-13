﻿// Replacements for default typescript module loading with import
//
// NOTE: this js resolve the module loading through define() where each module (typescript with AMD compile) can
//       import its dependencies without the subsequent module knows what needs to load the previous, all Callbacks 
//       are called in reverse order (after loading) allowing the correct instantiation of the code (like a pyramid).
//       for example the first module Globals.ts is called by BaseObjects.ts, see follows:
//              - Content of source file Globals.ts
//                  ...
//                  export namespace Global { export class Types {...} }
//                  ...
//              - Content of source file BaseObjects.ts
//                  ...
//                  import {Global} from '.../Globals'
//                  export namespace BaseObjects {...}
//                  ...
//
//              Compiled by AMD module (see tsconfig.json for configuration):
//              - Content of compiled file Globals.js
//                   ...
//                   define(["require", "exports"], function (require, exports) {
//                      ...
//                   })(Types = exports.Types || (exports.Types = {}));
//                   ...
//
//              - Content of compiled file BaseObjects.ts
//                  ...
//                  define(["require", "exports", 'ooLib/Globals'], function (require, exports, Globals_1) {
//                      (function (Types) {
//                          ...
//                      }(Globals_1.Types));
//                   ...
//                  })(BaseObjects = exports.BaseObjects || (exports.BaseObjects = {}));
//         When the application access to objects of BaseObjects.ts start automatic loading of 'ooLib/Globals'
//         through requirejs (see follow define() remapped), after loading of all modules the callbacks are called 
//         in the reverse order compared to sequence of requests (ie before Globals and then BaseObjects) to avoid 
//         errors uninitialized objects, in fact, if they were called up in the loading sequence (ie before BaseObjects) 
//         is cause an error for lack of dependence (Globals)
//
// Add script tags in the page in the follow manner:
//  <script type="text/javascript" src="../Scripts/require.js"></script>
//  <script type="text/javascript" src="../Scripts/requireModules.js"></script>
// 
// NOTE: After typescript compilation the scripts (js) are exported in Scripts/App 
//       folder with the same structure of the typescript sources 
//       (see also tsconfig.json)
//       For others support scripts and libraries see also:
//              - gulpfile.js
//              - bower_components/
//
var appScriptsRoot = "/Scripts/App";
//var exports = {};
// Set default modules root folder (for the original require)
require.config({
    baseUrl: appScriptsRoot,
    //shim: {
    //    'requireModules': {
    //        exports: 'require.exports'      // [*] Force export required for typescript module loading (export angular if required)
    //    }
    //},
    //map: {
    //    'requireModules': {
    //    }
    //}
});

//// Redefine the function for async dynamic loading
var exports = {};
var originalDefine = define;
var reqDefs, callbcks;
define = function (modules, callback) {

    // Add .js extension if missing
    for (var m in modules) {
        var module = modules[m];
        if (module != "require" && module != "exports") {
            if (module.indexOf(".js") == -1)
                module += ".js";
            module = appScriptsRoot + "/" + module;
            modules[m] = module;
        }
    }

    // Initialize the request objects for recursive define() call in the modules
    if (!reqDefs) {
        // Initialize the deferred objects for require queue
        reqDefs = new Array();
        callbcks = [];
    }
    var reqDef = {modules:modules,callback:callback,completed:false};
    reqDefs.push(reqDef);

    // Call require(9 for the define() modules to load
    // (for usage of module Name see: http://requirejs.org/docs/api.html#modulename)
    require(modules, function () {
        console.log("* MODULE/S LOADED " + JSON.stringify(modules) + " *");

        // Resolve require and push the callback in the queue for final notify
        var objThis = this, objArgs = [require, exports];   // Initialize args with require and exports, needed for typescript amd module loading (se define() in compiled modules js)
        // Append requirejs callback args
        callbcks.push(function () {
            for (var a = 2; a < modules.length; a++)
                // Append remaining parameters with exports because the module code search the required object in the param
                //  For exampre, if the module is ooLib/Globals.js the param compiled (amd) in define(..., Global_1) but the
                //  compile code search Global (fortunately) in the manner Global_1.Gloab, this method semplify
                //  the parameter rules because can be specify alway the exports declaration (wich contains all module definitions)
                objArgs.push(exports);
            callback.apply(objThis, objArgs);
        });
        reqDef.completed = true;
        
        // Identify if all requires are loaded (completed)
        var completed = true;
        for (var d in reqDefs) {
            if (!reqDef.completed)
                completed = false;
        }
        if (completed)
            doneCallbacks();
    });

};

// Notify complete loading
doneCallbacks = function () {
    console.log("* ALL MODULES LOADED *");

    // Call all callback queue (invert order for right priority sequence)
    for (var c = callbcks.length-1;c>=0; c--)
        callbcks[c]();
    reqDefs = undefined;
    callbcks = undefined;
};