;;This snippet creates an html file containing all files and subdirectories in the directory you ;;input. the html file uses javascript to display all of the files and subdirectories in a ;;treeview-like fashion. 


;-------------- - ---- -   -       -
; MPTree by praetorian
; praetorian@mircscripts.org
; http://detox.xs3.com or http://praetorian7.hypermart.net
;---------------- -   -       -
; this snippet creates an html file containing all files and subdirectories
; in the directory you input.  the html file uses javascript to display all
; of the files and subdirectories in a treeview-like fashion.
;
; feel free to use this snippet as you like. you can download the folder and file
; images from (right click on them and choose "Save as.."):
;   http://praetorian.mircscripts.org/mirc/mptree/mptree_folder.png
;   http://praetorian.mircscripts.org/mirc/mptree/mptree_file.png
;
; usage: /mptree <output.html> <directory>
;---- -   -

alias mptree {

  ; clear/create the output file and write the javascript code and the
  ; style sheet used to create the treeview effect

  write -c $1
  write $1 <script language="JavaScript">
  write $1 function showhide(idarg) $chr(123)
  write $1   var status = document.getElementById(idarg).style.display
  write $1   var workdammit = idarg + "_";
  write $1   if (status == 'block') $chr(123)
  write $1     document.getElementById(idarg).style.display = 'none';
  write $1     document.getElementById(workdammit).style.display = 'none';
  write $1   $chr(125)
  write $1   else $chr(123)
  write $1     document.getElementById(idarg).style.display = 'block';
  write $1     document.getElementById(workdammit).style.display = 'block';
  write $1   $chr(125)
  write $1 $chr(125)
  write $1 </script><style type="text/css">
  write $1 <!--
  write $1 .root $chr(123) font-family: tahoma; font-size: 8pt; list-style-image: url('mptree_folder.png'); cursor: hand; $chr(125)
  write $1 .folder $chr(123) list-style-image: url('mptree_folder.png'); display:none; cursor: hand; $chr(125)
  write $1 .file $chr(123) list-style-image: url('mptree_file.png'); display: none; cursor: default; $chr(125)
  write $1 -->
  write $1 </style><ul class="root">

  ; set variables for the output file and the number of forward slashes
  ; (used for directory searching)

  var %f = $1,%sd = $calc($count($2-,\) + 1)

  ; search for directories within the input folder and send a signal to
  ; recurse through all of the subdirectories of the subdirectories of
  ; the subdirectories, ect.

  !.echo -q $finddir($2-,*,*,1,.signal -n mptree %f %sd $1-)
}
on 1:signal:mptree:{

  ; set variables for filename, forward slash count, current directory path
  ; and a "clean" javascript id name (not foolproof, some chars might break it)

  var %f = $1,%sn = $2
  var %d = $gettok($3-,$+($2,-),92)
  var %sd = $replace(%d,$chr(32),_,\,-,',-)
  write $1 <li> <a onclick="showhide(' $+ %sd $+ ')" > $+ $nopath(%d) $+ </a>

  ; write subdirs, calling the signal recursively so that all subdirectories
  ; (and their subdirectories) are listed before the current node is closed.
  ; this is probably the most functional use for the /signal command, recursion
  ; makes things alot easier.

  write $1 <ul class="folder" id=" $+ %sd $+ ">
  !.echo -q $finddir($+(",$3-,"),*,*,1,.signal -n mptree %f %sn $1-)
  write $1 </ul>

  ; write files using $findfile and close the tags.

  write $1 <ul class="file" id=" $+ %sd $+ _">
  !.echo -q $findfile($+(",$3-,"),*.*,*,1,write %f <li> $nopath($1-) </li>)

  write $1 </ul></li>
}

