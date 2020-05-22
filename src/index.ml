
open Js_of_ocaml
open Js_of_ocaml_lwt
let (>>=) = Lwt.bind

open Js_of_ocaml_tyxml.Tyxml_js(*.Html*)
open Parse_aiken

module Bootstrap_css = struct

  let button_classes=["mcq";"btn";"btn-primary"]

  let div_mcq_classes=["mcq"]

  let ul_classes=["mcq";"list-group"]

  let div_mcq_footer_classes=["mcq_footer"]

  let div_mcq_footer_styles=""
end
open Bootstrap_css

let get_body_div () = 
  let body_div : Dom_html.element Js.t = 
    Dom_html.document##getElementById (Js.string "body")
    |> Js.Opt.to_option |> function
    | None -> failwith __LOC__
    | Some e -> e
  in
  body_div

type mcq = {
  text:string;
  possibles: string list;
  answer: string;
}

let _ = print_endline "hello"

(* let mcq_questions_as_text = [%blob "../src-other/questions.md"] *)

let main () = 
  (* Js_of_ocaml.Sys_js.read_file ~name:"questions.md" *)
  Js_of_ocaml_lwt.XmlHttpRequest.get "questions.md" >>= fun frm -> 
  let open (struct
    let mcq_questions_as_text = frm.content
                                  
    let _ = print_endline mcq_questions_as_text

    let mcqs = 
      parse_aiken_list mcq_questions_as_text |> function
      | None -> failwith "no mcqs"
      | Some(mcqs,rest) -> 
        Printf.printf "Got %d mcqs\n" (List.length mcqs);
        mcqs |> List.map (fun (q,ps,a) -> { text=q; possibles=ps; answer=a })

    let render = 
      let count = ref 0 in
      fun mcq -> 
        Html.(
          let c = !count in
          incr count;
          let selected = ref "" in
          div [
            div ~a:[a_class div_mcq_classes] [
              p ~a:[a_class ["mcq"]] [txt mcq.text];
              br();

              ul ~a:[a_class ul_classes] (
                mcq.possibles |> List.map (fun a ->
                    li ~a:[a_class ["mcq"]]
                      [
                        input ~a:[a_input_type `Radio; 
                                  a_name (string_of_int c); 
                                  a_onclick (fun _ -> selected:=a; true)] ();
                        txt ("    "^a)]
                  )
              );
              br();

              (
                button ~a:[a_class button_classes] [txt "Click to check!"] |> fun b1 ->
                b1 |> To_dom.of_element |> fun b2 ->
                Lwt_js_events.(async (fun () -> clicks b2 (fun ev -> fun _ -> 
                    print_endline "clicked!"; 
                    print_endline (!selected); 
                    if (String.sub !selected 0 (String.length mcq.answer) = mcq.answer) then
                      b2 ##.innerHTML := Js.string "Correct! Brilliant!"
                    else 
                      b2 ##.innerHTML := Js.string "Incorrect :( Click to check again";
                    Lwt.return ())));
                b1);
            ];
            div ~a:[a_class div_mcq_footer_classes; a_style div_mcq_footer_styles] []
          ]
        )

    let start () = 
      let append_mcq mcq = 
        mcq |> render |> To_dom.of_node |> fun n ->
        ignore @@ (get_body_div())##appendChild n
      in
      List.iter append_mcq mcqs;
      ()

    let _ = Printf.printf "About to call start()\n %!"

    let _ = start ()
  end)
  in
  Lwt.return ()


let _ =
  Dom_html.window##.onload := 
    Dom_html.handler (fun _ -> ignore (main ()); Js._false)



(*

  let rec loop () = 
    Lwt.return () >>= fun _ -> 
    let x = Html.(p [txt "Hello world"]) in
    ignore @@ (get_body_div())##appendChild (x |> To_dom.of_node);
    Lwt_js.sleep 1.0 >>= fun _ -> 
    let x = Html.(p [txt "Hello world again"]) in
    ignore @@ (get_body_div())##appendChild (x |> To_dom.of_node);
    Lwt_js.sleep 1.0 >>= fun _ -> 
    loop ()
  in
  (* loop () *)


let test_mcq_as_string = {|
What is the capital of the UK?

A. London
B. York
C. Leicester
ANSWER: A
|}
*)

(*

let parse_aiken txt = parse_aiken txt |> function
  | None -> failwith __LOC__
  | Some(q,ps,a,rest) -> { text=q; possibles=ps; answer=a }

let test_mcq = {
  text="What is the capital of the UK?";
  answers=["London",true; "York",false; "Leicester",false]
}
*)


(*
let _ = 
  P0.to_fun parse_aiken_format test_mcq_as_string |> function
  | None -> failwith __LOC__
  | Some ((question,poss,answer),_) ->     
    Printf.printf "parsed mcq: %s %s %s" question (String.concat "\n" poss) answer
*)


(*  let _ = 
    Html.(button [txt "press me"]) |> fun b1 -> 
    b1 |> To_dom.of_button |> fun b2 ->
      Lwt_js_events.(async (fun () -> 
        clicks b2 (fun ev _ -> print_endline "clicked!"; Lwt.return ())));
      ignore @@ Dom_html.document##.body##appendChild (b1 |> To_dom.of_node)
  in*)
