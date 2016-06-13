"use strict";
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
});
/**
 *  Wrapper functon for module loading encapsulation
 * @param modules
 * @param ready
 */
function requireModules(modules, ready) {
    //// Normalize
    //for (var i = 0; i < modules.length; i++)
    //    modules[i] = appURL + modules[i];
    return require(modules, ready);
}
exports.requireModules = requireModules;
;
//# sourceMappingURL=config.js.map