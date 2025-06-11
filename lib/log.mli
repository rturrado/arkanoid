module Log : sig
    val init : unit -> unit
    val verbose : ('b, Format.formatter, unit) format -> 'b
    val debug : ('b, Format.formatter, unit) format -> 'b
    val info : ('b, Format.formatter, unit) format -> 'b
    val warn : ('b, Format.formatter, unit) format -> 'b
    val error : ('b, Format.formatter, unit) format -> 'b
    val critical : ('b, Format.formatter, unit) format -> 'b
end
