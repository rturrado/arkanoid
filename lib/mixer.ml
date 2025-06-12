open Tsdl_mixer

module Mixer = struct
    type audio_t = {
        frequency : int;
        format : int;
        channels : int;
        chunk_size : int
    }

    let default_audio : audio_t = {
        frequency = Mixer.default_frequency;
        format = Mixer.default_format;
        channels = Mixer.default_channels;
        chunk_size = 4096
    }

    let init ()
    : (unit, string) result =
        let expected_flags = Mixer.Init.(mp3) in
        match Mixer.init expected_flags with
        | Error _ -> Error "Mixer.init error"
        | Ok initialized_flags ->
            if not (initialized_flags = expected_flags) then
                Error "Mixer.init error"
            else
                Ok ()

    let quit ()
    : unit =
        Mixer.quit ()

    let open_audio (audio : audio_t)
    : (unit, string) result =
        match Mixer.open_audio audio.frequency audio.format audio.channels audio.chunk_size with
        | Error (`Msg err) -> Error ("Mixer.open_audio error: " ^ err)
        | Ok () -> Ok ()

    let close_audio ()
    : unit =
        Mixer.close_audio ()

    let load_music (music : string)
    : (Mixer.music, string) result =
        match Mixer.load_mus music with
        | Error (`Msg err) -> Error ("Mixer.load_mus error: " ^ err)
        | Ok mixer_music -> Ok mixer_music

    let free_music (music : Mixer.music)
    : unit =
        Mixer.free_music music

    let play_music (music : Mixer.music) (loops : int)
    : (unit, string) result =
        match Mixer.play_music music loops with
        | Ok 0 -> Ok ()
        | Ok exit_code -> Error ("Mixer.play_music error: " ^ (string_of_int exit_code))
        | Error (`Msg err) -> Error ("Mixer.play_music error: " ^ err)

    let halt_music ()
    : (unit, string) result =
        match Mixer.halt_music () with
        | Error (`Msg err) -> Error ("Mixer.halt_music error: " ^ err)
        | Ok () -> Ok ()
end
