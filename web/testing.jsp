<%-- 
    Document   : testing
    Created on : Jan 16, 2017, 10:38:07 PM
    Author     : Mike Ho
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
            <!-- Bootstrap core CSS -->
    <link href="./assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="./assets/css/style.css" rel="stylesheet">
    <link href="./assets/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.5.4/bootstrap-select.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="./Dashboard_files/ie10-viewport-bug-workaround.css" rel="stylesheet">
    
    <!--custom CSS by author-->
    <link href="./assets/css/custom.css" rel="stylesheet">
        <style>
/*        #myProgress {
    position: relative;
    width: 100%;
    height: 30px;
}
#myBar {
    position: absolute;
    width: 0%;
    height: 100%;
    
    #label {
    text-align: center;  If you want to center it 
    line-height: 30px;  Set the line-height to the same as the height of the progress bar container, to center it vertically 
    color: white;
}
}*/
</style>
    </head>
    <body>
        <h1>Hello World!</h1>

        <button onclick="move()">test</button>
        <div id="myProgress" class="progress">
  <div id="myBar" class="progress-bar">
    <div id="label">0%</div>
  </div>
</div>
    </body>
    <script type="text/javascript">
        function move() {
            var elem = document.getElementById("myBar"); 
            var width = 0;
            var id = setInterval(frame, 100);
            var status = 50;
            function frame() {
                if (width >= status) {
                    clearInterval(id);
                } else {
                    width++; 
                    elem.style.width = width + '%'; 
                    document.getElementById("label").innerHTML = width * 1 + '%';
                }
            }
        }
    </script>
</html>
