PastieService - A Mac OS X Service to quickly paste on pastie.org
=================================================================

PastieService is a service provider for Mac OS X (10.6 only) written by Samuel
Mendes in Objective-C 2.0 and released under BSD 3-clauses license.

This service provides a quick way to paste any selected text in Mac OS X to
[pastie.org](http://pastie.org). Once pasted the paste's URL is automatically
placed in the system's clipboard.

Installation
------------

Once build place PastieService.app either in /Applications or
~/Library/Services. Then run:

  sudo /System/Library/CoreServices/pbs

This will update the cache of service providers.
Finally open up System Preferences go into Keyboard and choose the Keyboard
Shortcuts tab. On the left side are the categories, choose Services. On the
right is a list of all the services you can activate. Find "Make New Pastie" in
it (it's probably at the end in the Development section) and activate it.

You can assign it a keyboard shortcut by right clicking on right side of the
list.

LICENSE
=======

Copyright (c) 2010, Samuel Mendes

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

* Neither the name of ᐱ nor the names of its
contributors may be used to endorse or promote products derived
from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Samuel Mendes <samuel.mendes@gmail.com>
