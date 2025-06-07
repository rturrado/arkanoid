module Log : sig
    val log_verbose : ('b, Format.formatter, unit) format -> 'b
    val log_debug : ('b, Format.formatter, unit) format -> 'b
    val log_info : ('b, Format.formatter, unit) format -> 'b
    val log_warn : ('b, Format.formatter, unit) format -> 'b
    val log_error : ('b, Format.formatter, unit) format -> 'b
    val log_critical : ('b, Format.formatter, unit) format -> 'b
end
