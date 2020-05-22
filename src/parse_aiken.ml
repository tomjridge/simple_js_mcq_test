open P0_lib

module Internal1 = struct
  open P0

(*
  let parse_poss = 
    plus ~sep:(a "\n") (upto_a "\n")
*)

  let parse_poss = 
    let item = 
      (re Re.(seq [set "ABCDE"; char '.']) -- upto_a "\n") >>= (fun (id,rest) ->
          return (id^rest))
    in
    plus ~sep:(a "\n") item
      
  let parse_aiken_format = 
    upto_a "A." >>= fun question -> 
    (* Printf.printf "Question: %s\n\n%!" question; *)
    upto_a "ANSWER: " >>= fun poss ->
    (* Printf.printf "Possibles: %s\n\n%!" poss;     *)
    let poss = to_fun parse_poss poss |> function
      | None -> failwith __LOC__
      | Some (r,_rest) -> 
        (* Printf.printf "Warning: rest was %s\n%!" rest; *)
        r
    in
    (* NOTE the answer must start one of the poss; the answer is everything after a space to end of line *)
    (a "ANSWER: " -- upto_a "\n") >>= fun (_,answer) -> 
    (* Printf.printf "ANSWER: %s\n\n%!" answer;     *)
    return (question,poss,answer)

  let ws = Re.(longest (rep (set " \n")))

  let sep = re Re.(seq [ws; str "---"; ws]) 

  let parse_aiken_list = P0.(star ~sep parse_aiken_format)

end    


module Internal2 = struct
  (* massage interface *)

  open Internal1

  let parse_aiken txt = 
    P0.to_fun parse_aiken_format txt |> function
    | None -> None
    | Some ((q,ps,a),rest) -> Some(q,ps,a,rest)

  let parse_aiken_list txt = 
    P0.to_fun parse_aiken_list txt |> function
    | None -> None
    | Some (mcqs,rest) -> Some(mcqs,rest)

end

let parse_aiken = Internal2.parse_aiken

let parse_aiken_list = Internal2.parse_aiken_list


module Internal_test = struct

  let test_mcq_as_string = {|
What is the capital of the UK?

A. London
B. York
C. Leicester
ANSWER: A
|}


  let test () = 
    P0.to_fun Internal1.parse_aiken_format test_mcq_as_string |> function
    | None -> failwith __LOC__
    | Some ((question,poss,answer),_) ->     
      Printf.printf "parsed mcq: %s %s %s" 
        question (String.concat "\n" poss) answer

end

