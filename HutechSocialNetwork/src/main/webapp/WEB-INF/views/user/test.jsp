<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator"
	prefix="decorator"%>
<%@include file="/WEB-INF/views/layouts/user/taglib.jsp"%>
<c:url var="userURL1" value="/user/test" />
<c:url var="userURL" value="/" />
<c:url var="newAPI" value="/api/user"/>

<html>
<head>
    <title>Chat WebSocket</title>
    <script type="text/javascript">
            var stompClient = null;
            function setConnected(connected) {
                document.getElementById('connect').disabled = connected;
                document.getElementById('disconnect').disabled = !connected;
                document.getElementById('conversationDiv').style.visibility
                  = connected ? 'visible' : 'hidden';
                document.getElementById('response').innerHTML = '';
            }
            
            function connect() {
                var socket = new SockJS('/HutechSocialNetwork/gs-guide-websocket');
                stompClient = Stomp.over(socket);
                stompClient.connect({}, function(frame) {
                    setConnected(true);
                    console.log('Connected: ' + frame);
                    stompClient.subscribe('/topic/messages', function(messageOutput) {
                      var x = JSON.parse(messageOutput.body);
                      var y =1;
                      if(y == ${User_Infor.id}){
                    	  $('#response').append(x.from + ": "
                                  + x.text + " (" + x.time + ")");
                      }
                       
                    });
                });
            }
            function disconnect() {
                if(stompClient != null) {
                    stompClient.disconnect();
                }
                setConnected(false);
                console.log("Disconnected");
            }
            function sendMessage() {
                var from = document.getElementById('from').value;
                var text = document.getElementById('text').value;
                stompClient.send("/app/chat", {},
                  JSON.stringify({'from':from, 'text':text}));
            }
            function myFunction() {
            	alert("Trang đã được tải");
            	}
        </script>
</head>

<div>
    <div>
        <input type="text" id="from" placeholder="Choose a nickname"/>
    </div>
    <br />
    <div>
        <button id="connect" onclick="connect();">Connect</button>
        <button id="disconnect" disabled="disabled" onclick="disconnect();">
            Disconnect
        </button>
    </div>
    <br />
    <div id="conversationDiv">
        <input type="text" id="text" placeholder="Write a message..."/>
        <button id="sendMessage" onclick="sendMessage();">Send</button>
        <p id="response"></p>
    </div>
</div>

</html>
