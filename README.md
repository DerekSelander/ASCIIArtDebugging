ASCIIArtDebugging
=================


ASCIIArtDebugging is a fun yet useful way to debug UIImage & UIImageViews in order to see what gets passed around for
the image at runtime.  Instead of just looking at the memory address or properties while debugging, ASCIIArtDebugging
takes the image and creates an ASCIIArt image in your console. 

ASCIIArtDebugging can accomidate different Xcode window console sizes as well as different types of image sizes and data types. 

You can adjust the <em>kMaxWidth</em> and <em>kMaxHeight</em> values to accomodate your appropriate screen size.

ASCIIArtDebugging In Action
===========================

In the lldb console:<br>
<code>(lldb) po image</code>  
or<br> 
<code>(lldb) po imageview</code>


![Alt text](/ScreenShot.png?raw=true "ASCIIArt In Action")


Install
=======
Simply place the category methods in your PCH file and compile your project. Feel free to adjust adjust free screen size in 
the .m files. You can also toggle to print out ascii art in debug mode only. i.e. Debug Only will display ascii art when 
typing "po imageInstance" but would not display ascii art in NSLog("here is an image %@", imageInstance);

Licensing
=========

The MIT License (MIT)

Copyright (c) 2013 Selander

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
