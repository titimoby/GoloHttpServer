#GoloHttpServer

To learn Golo language, I decided to write a simple Http server.
It can be used to serve static HTML pages

##How to launch the server

No script for the moment as it's still as simple as:

	golo golo --files parameters.golo GoloHttpServer.golo

##Parameters

The file parameters.golo contains the configuration informations.
You can edit and set:

- HTTPPORT: defines the port the server will be listening to. *(default value is 5000)*
- HOME: defines the file that will be used as dafault homepage. *(default value is index.html)*

##What can you do?

- Html pages must be in the same folder as GoloHttpServer.golo
- you can use subfolders (if not, it's a bug ;) )

## License

    Copyright 2013-2014 Thierry Chantier

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

##Contribute

Any contribution is welcome, fork and pull a request, add issues, suggestions...

And like K33g_org says:
*have fun.*
