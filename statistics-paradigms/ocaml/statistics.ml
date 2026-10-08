let mean values =
  match values with
  | [] -> invalid_arg "mean requires at least one value"
  | _ ->
      let sum = List.fold_left ( + ) 0 values in
      float_of_int sum /. float_of_int (List.length values)

let median values =
  match List.sort compare values with
  | [] -> invalid_arg "median requires at least one value"
  | sorted ->
      let count = List.length sorted in
      let middle = count / 2 in
      if count mod 2 = 1 then float_of_int (List.nth sorted middle)
      else float_of_int (List.nth sorted (middle - 1) + List.nth sorted middle) /. 2.0

let mode values =
  let increment key counts =
    let current = Option.value (List.assoc_opt key counts) ~default:0 in
    (key, current + 1) :: List.remove_assoc key counts
  in
  match List.fold_left (fun counts value -> increment value counts) [] values with
  | [] -> invalid_arg "mode requires at least one value"
  | counts ->
      let maximum = List.fold_left (fun best (_, count) -> max best count) 0 counts in
      counts
      |> List.filter (fun (_, count) -> count = maximum)
      |> List.map fst
      |> List.sort compare

let () =
  let values = [ 4; 1; 2; 2; 3; 4; 4; 5 ] in
  Printf.printf "Data: %s\n" (String.concat " " (List.map string_of_int values));
  Printf.printf "Mean: %.2f\n" (mean values);
  Printf.printf "Median: %.2f\n" (median values);
  Printf.printf "Mode(s): %s\n" (String.concat " " (List.map string_of_int (mode values)))
