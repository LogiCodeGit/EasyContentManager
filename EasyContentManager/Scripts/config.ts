// Default file config.ts for requirejs
// See also: https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/requirejs
//
// References for IntelliSense
/// <reference path="typings/requirejs/require.d.ts"/>
//
// Add script include in the page, example:
//      <script data-main="config.ts" type="text/javascript" src="../require.js"></script>
//let appURL: string = "App";     //"/Scripts/App/";
//
require.config({
    baseUrl: "App",

    //paths: {
    //    'jquery': 'App/jquery',
    //    'bootstrap': 'App/bootstrap',
    //    'backbone': 'App/backbone',
    //},

    //shim: {
    //    jquery: {
    //        exports: '$'
    //    },
    //    underscore: {
    //        exports: '_'
    //    },

    //    backbone: {
    //        deps: ['underscore', 'jquery'],
    //        exports: 'Backbone'
    //    }
    //}
});

/**
 *  Wrapper functon for module loading encapsulation
 * @param modules
 * @param ready
 */
export function requireModules(modules: string[], ready?: Function): any {
    //// Normalize
    //for (var i = 0; i < modules.length; i++)
    //    modules[i] = appURL + modules[i];
    return require(modules, ready);
};