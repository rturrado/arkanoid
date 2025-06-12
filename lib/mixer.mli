module Mixer : sig
    type audio_t = {
        frequency : int;
        format : int;
        channels : int;
        chunk_size : int
    }

    val default_audio : audio_t

    val init : unit -> (unit, string) result
    val quit : unit -> unit
    val open_audio : audio_t -> (unit, string) result
    val close_audio : unit -> unit
    val load_music : string -> (Tsdl_mixer.Mixer.music, string) result
    val free_music : Tsdl_mixer.Mixer.music -> unit
    val play_music : Tsdl_mixer.Mixer.music -> int -> (unit, string) result
    val halt_music : unit -> (unit, string) result
end
