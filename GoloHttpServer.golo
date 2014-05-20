module GoloHttpServer

import java.io
import java.net.InetAddress
import java.net.URLDecoder
import java.net
import java.util
import java.lang.Integer
import java.lang

# Golo modules
import parameters

function sendFile = |fin, out| {
		var bytesRead = fin:read()
		while (bytesRead != -1 ) {
			out:write(bytesRead)
			bytesRead = fin:read()
	    }
	    fin:close()
}

function run = |serverState, connectedClient| {		

	let inFromClient = BufferedReader( InputStreamReader (connectedClient:getInputStream()))
	let outToClient = DataOutputStream(connectedClient:getOutputStream())

	var requestString = inFromClient:readLine()
	let headerLine = requestString

	let tokenizer = StringTokenizer(headerLine)
	let httpMethod = tokenizer:nextToken()
	let httpQueryString = tokenizer:nextToken()
	let responseBuffer = StringBuffer()
	responseBuffer:append("<b> This is the HTTP Server Home Page.... </b><BR>")
    responseBuffer:append("The HTTP Client request is ....<BR>")

    while (inFromClient:ready()) {
        # Read the HTTP complete HTTP Query
        responseBuffer:append(requestString + "<BR>")
		requestString = inFromClient:readLine()
	}

	httpMethodHandle(httpMethod, httpQueryString, responseBuffer, outToClient)
}

function httpMethodHandle = |methodName, queryString, responseBuffer, outToClient| {
	case {
		when methodName == "GET" {
			var fileName = queryString:replaceFirst("/", "")
			if (queryString=="/") {
				# The default home page
				fileName = Parameters(): HOME()	
			}
			fileName = URLDecoder.decode(fileName)
			if ( File(fileName):isFile()){								
		  		sendResponse(200, fileName, true, outToClient)
			} else {
		  		sendResponse(404, "<b>The Requested resource not found ...." + "Usage: http://127.0.0.1:5000 or http://127.0.0.1:5000/<fileName></b>", false, outToClient)
			}	
		}
		otherwise {
			sendResponse(404, "<b>The Requested resource not found ...." + "Usage: http://127.0.0.1:5000 or http://127.0.0.1:5000/<fileName></b>", false, outToClient)
			}
		}
}

function sendResponse = |statusCode, pResponseString, isFile, outToClient| {
	requireNotNull(statusCode)
	requireNotNull(pResponseString)
	requireNotNull(isFile)
	requireNotNull(outToClient)
	var responseString = pResponseString

	let HTML_START = "<html><title>HTTP Server in java</title><body>"
	let HTML_END = "</body></html>"

	var statusLine = ""
	let serverdetails = "Server: Java HTTPServer"
	var contentLengthLine = ""
	var fileName = ""
	var contentTypeLine = "Content-Type: text/html" + "\r\n"
	
	if (statusCode == 200) {
		statusLine = "HTTP/1.1 200 OK" + "\r\n"
	} else {
		statusLine = "HTTP/1.1 404 Not Found" + "\r\n"
	}
		
	var fileInStream = null

	if (isFile) {
		fileName = responseString		
		fileInStream = FileInputStream(fileName)
		contentLengthLine = "Content-Length: " + Integer.toString(fileInStream:available()) + "\r\n"
		if (not(fileName:endsWith(".htm")) and not(fileName:endsWith(".html")) ) {
			contentTypeLine = "Content-Type: \r\n"
		}
	} else {
		responseString = HTML_START + responseString + HTML_END
		contentLengthLine = "Content-Length: " + responseString:length() + "\r\n"
	}			
	 
	outToClient:writeBytes(statusLine)
	outToClient:writeBytes(serverdetails)
	outToClient:writeBytes(contentTypeLine)
	outToClient:writeBytes(contentLengthLine)
	outToClient:writeBytes("Connection: close\r\n")
	outToClient:writeBytes("\r\n")

	if (isFile) {
		sendFile(fileInStream, outToClient)
	} else {
		outToClient:writeBytes(responseString)
	}

	outToClient:close()
}

function main = |args| {
	let addr = InetAddress.getByName("127.0.0.1")
	let Server = ServerSocket (Parameters(): HTTPPORT(), 10, addr)
	println ("TCPServer Waiting for client on port "+Parameters(): HTTPPORT())

	var serverState = "running"
	while(serverState == "running") {
		let clientSocket = Server: accept()
		let process = java.lang.Thread({run(serverState, clientSocket)}: to(Runnable.class))
		process: start()
	}
}
