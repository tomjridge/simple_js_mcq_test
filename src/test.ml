(** Example tyxml; output requires tjr_lib *)

open Tjr_lib_core
open Tyxml
open Tyxml.Html

let default_font = 
  {|font-family: 'Times New Roman', Times, serif; |}

let bg_light_grey = "background-color:rgb(250,250,255)"

let a_style_ xs = a_style (String_.concat "; " xs)

let h1_style = a_style_ [
    "margin:0"; "padding:.5em 0"; 
    "font-family: Arial, Helvetica, sans-serif"; 
    "font-size:30pt;"
  ]

let h2_style = a_style "margin:0; padding:.5em 0; font-family: Arial, Helvetica, sans-serif; font-size:20pt;" 

let nl = txt"\n"

let doc = 
  html
    (head 
       (title (txt "hello")) 
       [
         Unsafe.data {|
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script type="text/javascript" src="test.bc.js"></script>

<style>
.row * {
  box-sizing: border-box;
}

/* Create two unequal columns that floats next to each other */
.column {
  float: left;
  padding: 10px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}

#sidebar { display:none; }
#mainbar { width:100%; }

@media only screen and (min-width: 600px) {
#sidebar { display:block; width:25%; }
#mainbar { width:75%; }
}


</style>
|}          
       ])
    (body ~a:[a_style_ [default_font;
                        bg_light_grey; 
                        "margin:0; padding:0;"]] 
       [
         div ~a:[a_style_ [
                   "margin:0 auto; max-width:800px";
                   "background-color:white";
                   "border: 1px solid";
                   "padding:10px 10px 200px 10px;" ]]
           [
             div ~a:[a_class ["row"]]
               [
                 div ~a:[a_class ["column left"]; a_id "sidebar"]
                   [txt "this is a sidebar"];
                 div ~a:[a_class ["column right"]; a_id "mainbar"]
                   [
                     h1 ~a:[h1_style][txt "This is the title"];nl;
                     p [
                       txt "This is the main text";nl;
                       txt "And some more main text.";nl;
                       txt "And some more main text.";nl;
                       txt "And some more main text.";nl;
                       txt "And some more main text.";nl;
                     ];
                     h2 ~a:[h2_style][txt "Another heading"];nl;
                     div ~a:[] 
                       [
                       ];
                   ]
               ]
           ]
       ])

(* this requires tjr_lib 
let _ = 
  doc |> Format.asprintf "%a" (Html.pp ~indent:true ())
  |> fun txt -> 
  Tjr_file.write_string_to_file ~fn:"test.html" txt;
  print_endline txt
*)


