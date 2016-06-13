tsconfig.json		->	definizione di compilazione dei files typescript per la generazione dei corrispondenti file js nella cartella ./App
requireModules.js	->  gestisce il meccanismo di caricamento dei moduli di libreria all'interno del browser
						Questo js risolvere il caricamento dei modulos attraverso define () in cui ogni modulo (compilato con AMD) può 
						importare le sue dipendenze senza che il modulo successivo conosca le dipendenze del precedente, tutte le 
						callback vengono vengono chiamate in ordine inverso (dopo il caricamento), questo consente la corretta 
						instanziazione del codice (in modo piramidale dal modulo più in basso).
						(vedi requireModules.js per ulteriori dettagli)
ooLib/				->  libreria OO che gestisce tutti i componenti 
typings/			->  definizioni per l'utilizzo delle librerie TS (i relativi moduli js effettivi sono in bower_components\ gestiti da VS mediante i moduli di bower)
Pages/				->  sorgenti TS utilizzati dalle pagine /Pages (che referenziano i js compilati in App/)

requirejs/			->  https://github.com/DefinitelyTyped/DefinitelyTyped/tree/master/requirejs
						Es.: <reference path="../typings/requirejs/require.d.ts" />


Alcuni articoli utili:
http://www.cantierecreativo.net/blog/2015/01/14/amd-requirejs-commonjs-browserify/
Typescript: http://Cms.changeyourweb.com/
Typescript with AMD requirejs: https://github.com/requirejs/requirejs/wiki/Differences-between-the-simplified-CommonJS-wrapper-and-standard-AMD-define#magic
Typescript handbook: http://www.typescriptlang.org/Handbook
					 https://github.com/Microsoft/TypeScript/blob/master/doc/spec.md
Typescript module import/export: http://www.typescriptlang.org/docs/handbook/modules.html
Typescript gulp: http://www.typescriptlang.org/docs/handbook/gulp.html
Typescript exceptions: 

AngularJS Binding with Typescript: https://docs.angularjs.org/api
								   http://www.html.it/pag/52588/angularjs-e-un-framework-non-una-libreria/
								   http://docs.telerik.com/kendo-ui/AngularJS/introduction

---------------------------------------------------------------
Documentazione tsconfig
	http://www.typescriptlang.org/docs/handbook/tsconfig-json.html

ASP.NET Core: Getting Started with AngularJS 2
	http://www.codeproject.com/Articles/1105223/ASP-NET-Core-Getting-Started-with-AngularJS

Visual Studio Tools for Apache Cordova 
	Per l'introduzione al modello vuoto, vedere la seguente documentazione:
	http://go.microsoft.com/fwlink/?LinkID=397705
	Per eseguire il debug del codice al caricamento della pagina in Ripple o in dispositivi/emulatori Android: avviare l'app, impostare i punti di interruzione, 
	quindi eseguire "window.location.reload()" nella console JavaScript.

VEDERE ANCHE:
X Progetto di tipo Asp.Net Core (web)
- Aggiungere il supporto a typescript:
	https://github.com/Microsoft/TypeScript-Handbook/blob/master/pages/tutorials/ASP.NET%20Core.md
	http://www.typescriptlang.org/docs/handbook/tsconfig-json.html

X Per progetti con Asp.Net 4 o succ.
- Aggiungere il supporto .Net x typescript:
	Installare dai pacchetti nuget: 
			TypeScript.NET.Library (https://github.com/electricessence/TypeScript.NET)
			jquery.TypeScript.DefinitelyTyped
			angularjs.TypeScript.DefinitelyTyped
			bootstrap.TypeScript.DefinitelyTyped
