<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="EasyContentManager._Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<!--<body ng-app="app">-->
<body ng-app="app">

    <div id="app">
        <p>Inserisci il tuo nome: <input type="text" ng-model="name"/>
        </p>
        <p>Inserisci il tuo nome (bind): <input type="text" id="bindName"/>
        </p>
        <p>L'applicazione è pronta.{{name}};{{daniele}}</p>
    </div>
    <!--<script type="text/javascript" src="../Scripts/jquery.min.js"></script>-->
    <!--<script data-main="../Scripts/config.ts" type="text/javascript" src="../Scripts/require.js"></script>-->
    <script type="text/javascript" src="../Scripts/require.js"></script>
    <script type="text/javascript" src="../Scripts/requireModules.js"></script>
    <script>
        // Activate source debug (unminified), see requiredModules.js
        appDebug = true;
    </script>
    <!--<script type="text/javascript" src="../Scripts/config.ts"></script>-->
    <script src="../Scripts/App/Pages/Default.js"></script>
</body>
</html>
