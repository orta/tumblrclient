var myrules = {
  '#HTMLorText': function(element) {
    element.onclick = function(event) { toggleViewMode(); }
    
  }, '#editableContent': function(element) {
    element.onkeydown = function(event) { inputKeyDown(event); }
    
  }
  
};

Behaviour.register(myrules);

function toggleViewMode(  ) {
  element = document.getElementById("editableContent");
  buttonText = document.getElementById("HTMLorText"); 
  
  if(isShowingInHTMLMode){
    element.className = "";
    // remove webkit br's
    var newHTML = element.innerHTML.replace(/<br>/g,'');
    
    //remove syntax highlighting
    newHTML = newHTML.replace(/<span class="string">/g,'');
    newHTML = newHTML.replace(/<span class="comment">/g,'');
    newHTML = newHTML.replace(/<span class="keyword">/g,'');
    newHTML = newHTML.replace(/<!--syntax--><\/span>/g,'');
    
    newHTML = newHTML.replace(/&gt;/g,'>');
    newHTML = newHTML.replace(/&lt;/g,'<');
    var oldHTML = newHTML;
    
    lastHTML = newHTML;
    element.innerHTML = newHTML;
    document.getElementById("errors").style.display = "none"; 
    
    if(lastHTML != element.innerHTML){
            //syntax error,usually bad closing div
            //switch back to showing code
            // syntax highlighting currently breaks this
            element.innerHTML = oldHTML;
            isShowingInHTMLMode = false;
            error = document.getElementById("errors");
            error.style.display = "block"; 
            error.innerHTML = "Warning: <small>unclosed div in HTML- <i> <small>Press Designer mode again to igore</i></small> </small> "
            toggleViewMode();
            return;
          }
    toggleNav();
    buttonText.innerHTML = "HTML Mode";
    isShowingInHTMLMode = false;
  }else{
    toggleNav();
    element.className = "htmlmode";
     element.innerHTML = element.innerHTML.replace(/</g,'&lt;');
     element.innerHTML = element.innerHTML.replace(/>/g,'&gt;');
   // element.innerHTML = syntaxHighlight(element.innerHTML);
    
    isShowingInHTMLMode = true;
    buttonText.innerHTML = "Designer Mode"
  
  }
}
function inputKeyDown(event){
  if (event.keyCode == 188) {
   // add a > 
	selection = window.getSelection();
	window.selection.setContent('<hr />');
	
    
  }
  if (event.keyCode == 222) {
   // add a "
  }
  
}
function toggleNav() {
  var nav = document.getElementById("navigation");
  var navlist = nav.getElementsByTagName("li");
  var dmode = "none";
  if(isShowingInHTMLMode) dmode = "inline";
  for (var i = 0; i < navlist.length; i++) {
      navlist[i].style.display = dmode;
  }
}

function applyTagAroundSelection (){
  
}

function reapplySyntaxHighlight(){
  element = document.getElementById("editableContent");
  var newHTML = element.innerHTML.replace(/<br>/g,'');
  newHTML = newHTML.replace(/<span class="string">/g,'');
  newHTML = newHTML.replace(/<span class="comment">/g,'');
  newHTML = newHTML.replace(/<span class="keyword">/g,'');
  newHTML = newHTML.replace(/<!--syntax--><\/span>/g,'');
  element.innerHTML = syntaxHighlight(element.innerHTML);
  
}

//var _timer = setInterval(function() {
//                         reapplySyntaxHighlight();
//                         }, 5000);


function syntaxHighlight(code)

//code below modified is from drosera
/*
 * Copyright (C) 2006 Apple Computer, Inc.  All rights reserved.
 * Copyright (C) 2006 David Smith (catfish.man@gmail.com)
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1.  Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer. 
 * 2.  Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution. 
 * 3.  Neither the name of Apple Computer, Inc. ("Apple") nor the names of
 *     its contributors may be used to endorse or promote products derived
 *     from this software without specific prior written permission. 
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE AND ITS CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL APPLE OR ITS CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

{
 // var keywords = { '<br>': 1, '<hr/>': 1, 'h1': 1, 'h2': 1, 'h3': 1, 'h4': 1, 'img': 1, 'i': 1, '<b>': 1 };
  var keywords = { 'abstract': 1, 'Lorem': 1, '<h1>': 1, 'h2': 1, 'catch': 1, 'char': 1, 'class': 1, 'const': 1, 'continue': 1, 'debugger': 1, 'default': 1, 'delete': 1, 'do': 1, 'double': 1, 'else': 1, 'enum': 1, 'export': 1, 'extends': 1, 'false': 1, 'final': 1, 'finally': 1, 'float': 1, 'for': 1, 'function': 1, 'goto': 1, 'if': 1, 'implements': 1, 'import': 1, 'in': 1, 'instanceof': 1, 'int': 1, 'interface': 1, 'long': 1, 'native': 1, 'new': 1, 'null': 1, 'package': 1, 'private': 1, 'protected': 1, 'public': 1, 'return': 1, 'short': 1, 'static': 1, 'super': 1, 'switch': 1, 'synchronized': 1, 'this': 1, 'throw': 1, 'throws': 1, 'transient': 1, 'true': 1, 'try': 1, 'typeof': 1, 'var': 1, 'void': 1, 'volatile': 1, 'while': 1, 'with': 1 };

  function echoChar(c) {
    if (c == '<')
    result += '&lt;';
    else if (c == '>')
    result += '&gt;';
    else if (c == '&')
    result += '&amp;';
    else if (c == '\t')
    result += '    ';
    else
    result += c;
  }

  function isDigit(number) {
    var string = "1234567890";
    if (string.indexOf(number) != -1)
    return true;
    return false;
  }

  function isHex(hex) {
    var string = "1234567890abcdefABCDEF";
    if (string.indexOf(hex) != -1)
    return true;
    return false;
  }

  function isLetter(letter) {
    var string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (string.indexOf(letter) != -1)
    return true;
    return false;
  }

  var result = "";
  var cPrev = "";
  var c = "";
  var cNext = "";
  for (var i = 0; i < code.length; i++) {
    cPrev = c;
    c = code.charAt(i);
    cNext = code.charAt(i + 1);

    if (c == "<" && cNext == "!") {
      result += "<span class=\"comment\">";
      echoChar(c);
      echoChar(cNext);
      for (i += 2; i < code.length; i++) {
        c = code.charAt(i);
        if (c == "\n")
        result += "<!--syntax--></span>";
        echoChar(c);
        if (c == "\n")
        result += "<span class=\"comment\">";
        if (cPrev == "-" && c == ">")
        break;
        cPrev = c;
      }
      result += "<!--syntax--></span>";
      continue;
    } else if (c == "/" && cNext == "/") {
      result += "<span class=\"comment\">";
      echoChar(c);
      echoChar(cNext);
      for (i += 2; i < code.length; i++) {
        c = code.charAt(i);
        if (c == "\n")
        break;
        echoChar(c);
      }
      result += "<!--syntax--></span>";
      echoChar(c);
      continue;
    } else if (c == "\"" || c == "'") {
      var instringtype = c;
      var stringstart = i;
      result += "<span class=\"string\">";
      echoChar(c);
      for (i += 1; i < code.length; i++) {
        c = code.charAt(i);
        if (stringstart < (i - 1) && cPrev == instringtype && code.charAt(i - 2) != "\\")
        break;
        echoChar(c);
        cPrev = c;
      }
      result += "<!--syntax--></span>";
      echoChar(c);
      continue;
    } else if (c == "0" && cNext == "x" && (i == 0 || (!isLetter(cPrev) && !isDigit(cPrev)))) {
      result += "<span class=\"number\">";
      echoChar(c);
      echoChar(cNext);
      for (i += 2; i < code.length; i++) {
        c = code.charAt(i);
        if (!isHex(c))
        break;
        echoChar(c);
      }
      result += "<!--syntax--></span>";
      echoChar(c);
      continue;
    } else if ((isDigit(c) || ((c == "-" || c == ".") && isDigit(cNext))) && (i == 0 || (!isLetter(cPrev) && !isDigit(cPrev)))) {
      result += "<span class=\"number\">";
      echoChar(c);
      for (i += 1; i < code.length; i++) {
        c = code.charAt(i);
        if (!isDigit(c) && c != ".")
        break;
        echoChar(c);
      }
      result += "<!--syntax--></span>";
      echoChar(c);
      continue;
     } else if (isLetter(c) && (i == 0 || !isLetter(cPrev))) {
          var keyword = c;
          var cj = "";
          for (var j = i + 1; j < i + 12 && j < code.length; j++) {
              cj = code.charAt(j);
              if (!isLetter(cj))
                  break;
              keyword += cj;
          }

          if (keywords[keyword]) {
              var functionName = "";
              var functionIsAnonymous = false;
              if (keyword == "function") {
                  var functionKeywordOffset = 8;
                  for (var j = i + functionKeywordOffset; j < code.length; j++) {
                      cj = code.charAt(j);
                      if (cj == " ")
                          continue;
                      if (cj == "(")
                          break;
                      functionName += cj;
                  }

                  if (!functionName.length) {
                      functionIsAnonymous = true;
                      var functionAssignmentFound = false;
                      var functionNameStart = -1;
                      var functionNameEnd = -1;

                      for (var j = i - 1; j >= 0; j--) {
                          cj = code.charAt(j);
                          if (cj == ":" || cj == "=") {
                              functionAssignmentFound = true;
                              continue;
                          }

                          var curCharIsSpace = (cj == " " || cj == "\t" || cj == "\n");
                          if (functionAssignmentFound && functionNameEnd == -1 && !curCharIsSpace) {
                              functionNameEnd = j + 1;
                          } else if (!functionAssignmentFound && !curCharIsSpace) {
                              break;
                          } else if (functionNameEnd != -1 && curCharIsSpace) {
                              functionNameStart = j;
                              break;
                          }
                      }

                      if (functionNameStart != -1 && functionNameEnd != -1)
                          functionName = code.substring(functionNameStart, functionNameEnd);
                  }

                  if (!functionName.length)
                      functionName = "function";

                  file.functionNames.push(functionName);
              }

              var fileIndex = 1;

              if (keyword == "function" && !functionIsAnonymous)
              alert(keyword)
                  result += "<span class=\"keyword\">" + keyword + "<!--syntax--></span>";
              if (functionName.length && !functionIsAnonymous) {
                  result += " <a name=\"function-" + fileIndex + "-" + file.functionNames.length + "\" id=\"" + fileIndex + "-" + file.functionNames.length + "\">" + functionName + "</a>";
                  i += keyword.length + functionName.length;
              } else
                  i += keyword.length - 1;

              continue;
          }
      }

      echoChar(c);
  }
      
  return result;
}



var isShowingInHTMLMode = false;
var lastHTML = "";
toggleViewMode();

