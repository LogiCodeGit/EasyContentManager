/// <binding AfterBuild='all' />
/// <reference path="bower_components/angular/angular.js" />
// Gulpfile per automatizzare la pubblicazione dei sorgenti nella cartella di release (es. Scripts o wwwroot) prelevandoli 
// dai pacchetti git/bower (es. da bower_components/) scaricati/aggiornati nel progetto mediante gli strumenti integrati di VS2015 o succ.
// - per attivare gli strumenti integrati di gestione tasks di gulp cliccare tasto destro sopra gulpfile.js
// - per attivare gli strumenti integrati di gestione dei pacchetti NuGet e Bower cliccare tasto destro sopra al progetto web
// See https://www.exceptionnotfound.net/using-gulp-js-and-the-task-runner-explorer-in-asp-net-5/

/// <binding Clean='clean' />
"use strict";

// Define dependencies
var gulp = require("gulp"),
    rimraf = require("rimraf"),
    concat = require("gulp-concat"),
    cssmin = require("gulp-cssmin"),
    uglify = require("gulp-uglify"),
    rename = require("gulp-rename");

// Define path and folders
var paths = {
    webroot: "./Scripts/App/",                  // Project Scripts base path
    bower: "./bower_components/"                // Bower repository base path
};
paths.outJS = paths.webroot + "js/";          // Project published js base path
paths.outCSS = paths.webroot + "css/";        // Project published css base path
//
paths.js = paths.outJS + "**/*.js";
paths.minJs = paths.outJS + "**/*.min.js";
paths.css = paths.outCSS + "**/*.css";
paths.minCss = paths.outCSS + "**/*.min.css";
//paths.concatJsDest = paths.outJS + "site.min.js";
//paths.concatCssDest = paths.outCSS + "site.min.css";
//
// Define minify only for ooLib, the publication is made by typescript amd compiler (see Script/tsconfig.json)
paths.outOOLib = paths.webroot + "ooLib/";    // Project published ooLib base path 
paths.jsOOLib = paths.outOOLib + "**/*.js";
paths.minJsOOLib = paths.outOOLib + "**/*.min.js";

//// Clean old cancat sources
//gulp.task("clean:js", function (cb) {
//    rimraf(paths.concatJsDest, cb);
//});

//gulp.task("clean:css", function (cb) {
//    rimraf(paths.concatCssDest, cb);
//});
//gulp.task("clean", ["clean:js", "clean:css"]);

// Publish angular sources
// (from bower_components/angular)
gulp.task('src:angular', function () {
    return gulp.src(paths.bower + 'angular/angular.js')
      .pipe(gulp.dest(paths.outJS+'angular'));
});
// Publish jquery sources
// (from bower_components/jquery)
gulp.task('src:jquery', function () {
    return gulp.src(paths.bower + 'jquery/dist/jquery.js')
      .pipe(gulp.dest(paths.outJS + 'jquery'));
});

// Publish all sources
gulp.task("src", ["src:angular","src:jquery"]);

// Minimize sources
gulp.task("min:js", function () {
    return gulp.src([paths.js, paths.jsOOLib, "!" + paths.minJs, "!" + paths.minJsOOLib], { base: "." })
        //.pipe(concat(paths.concatJsDest))
        .pipe(uglify())
        //.pipe(gulp.dest("."));
        .pipe(rename({ suffix: ".min" }))
        .pipe(gulp.dest("."));
});

//gulp.task("min:css", function () {
//    return gulp.src([paths.css, "!" + paths.minCss])
//        //.pipe(concat(paths.concatCssDest))
//        .pipe(cssmin())
//        .pipe(gulp.dest(paths.minJs));
//});

//gulp.task("min", ["min:js", "min:css"]);
gulp.task("min", ["min:js"]);

// Execute all tasks
gulp.task("all", ['src', 'min']);
