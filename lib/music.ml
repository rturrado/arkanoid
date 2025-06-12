open Mixer

let (>>=) = Result.bind

module Music = struct
    let one_0 : string = Filename.concat "./res" "one_0.mp3"

    let play (music : string)
    : (Tsdl_mixer.Mixer.music, string) result =
        Mixer.open_audio Mixer.default_audio >>= fun () ->
            Mixer.load_music music >>= fun mixer_music ->
                let loops = -1 in
                Mixer.play_music mixer_music loops >>= fun () ->
                    Ok mixer_music

    let halt (mixer_music : Tsdl_mixer.Mixer.music)
    : (unit, string) result =
        Mixer.halt_music () >>= fun () ->
            Mixer.free_music mixer_music;
            Mixer.close_audio ();
            Ok ()
end
