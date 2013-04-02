#GoloHttpServer

To learn Golo language, I decided to write a simple Http server.
It can be used to serve static HTML pages

###How to launch the server

No script for the moment as it's still as simple as:

	`gologolo parameters.golo GoloHttpServer.golo`

###Parameters

The file parameters.golo contains the configuration informations.
You can edit and set:

- HTTPPORT: defines the port the server will be listening to. *(default value is 5000)*
- HOME: defines the file that will be used as dafault homepage. *(default value is index.html)*

##What can you do?

- Html pages must be in the same folder as GoloHttpServer.golo
- you can use subfolders (if not, it's a bug ;) )

##Contribute

Any contribution is welcome, fork and pull a request, add issues, suggestions...

like K33g_org says:
*have fun.*