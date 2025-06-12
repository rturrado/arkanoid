module Music : sig
    val one_0 : string

    val play : string -> (Tsdl_mixer.Mixer.music, string) result
    val halt : Tsdl_mixer.Mixer.music -> (unit, string) result
end
