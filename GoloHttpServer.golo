module moby.GoloHttpServer

import java.io
import java.net.InetAddress
import java.net.URLDecoder
import java.net
import java.util
import java.lang.Integer
import java.lang

function sendFile = |fin, out| {
		let bytesRead = fin:read()
		while (bytesRead != -1 ) {
			out:write(bytesRead)
			bytesRead = fin:read()
	    }
	    fin:close()
}

function run = |connectedClient, serverState| {		

	let inFromClient = BufferedReader( InputStreamReader (connectedClient:getInputStream()))
	let outToClient = DataOutputStream(connectedClient:getOutputStream())

	let requestString = inFromClient:readLine()
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
			if (queryString=="/") {
				# The default home page
				sendResponse(200, responseBuffer:toString(), false, outToClient)
			} else {							
				# This is interpreted as a file name
				var fileName = queryString:replaceFirst("/", "")
				fileName = URLDecoder.decode(fileName)
				if ( File(fileName):isFile()){								
			  		sendResponse(200, fileName, true, outToClient)
				} else {
			  		sendResponse(404, "<b>The Requested resource not found ...." + "Usage: http://127.0.0.1:5000 or http://127.0.0.1:5000/<fileName></b>", false, outToClient)
				}
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

	let statusLine = ""
	let serverdetails = "Server: Java HTTPServer"
	let contentLengthLine = ""
	let fileName = ""
	let contentTypeLine = "Content-Type: text/html" + "\r\n"
	
	if (statusCode == 200) {
		statusLine = "HTTP/1.1 200 OK" + "\r\n"
	} else {
		statusLine = "HTTP/1.1 404 Not Found" + "\r\n"
	}
		
	let fileInStream = null

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
	let Server = ServerSocket (5000, 10, addr)
	println ("TCPServer Waiting for client on port 5000")

	var serverState = "running"
	while(serverState == "running") {
		let clientSocket = Server: accept()
		let process = java.lang.Thread({run(serverState, clientSocket)}: to(Runnable.class))
		process: start()
	}
}