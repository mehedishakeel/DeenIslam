# Full Adhan at prayer time (works with the app closed)

The Adhan is played by Android itself from the scheduled prayer notification,
so the app does not need to be running.

## Bundled files (supplied by the project owner)
Taken from `assets/` of https://github.com/HGg940977/DeenIslam (main):

| Bundled as (`android/app/src/main/res/raw/`) | Source file | Format | Length |
|---|---|---|---|
| `adhan_1.mp3` | `addan1.mp3` | MP3 16 kHz mono | ~3 min 46 s |
| `adhan_2.mp3` | `addan2.mp3` | MP3 44.1 kHz stereo | ~3 min 39 s |
| `adhan_3.mp3` | `addan4.mp3` | MP3 16 kHz mono | ~2 min 39 s |

- `addan3.mp3` is byte-identical to `addan2.mp3` (same SHA-1/MD5), so it was
  not added a second time.
- Only the embedded cover-art image was removed from `addan2`; the audio
  stream was copied without re-encoding.
- Provenance/licence of the recordings is not documented in the source
  repository. They are used as supplied by the owner, only for the prayer
  Adhan. Replace them if a licence check fails.

## Behaviour
- One notification channel per Adhan (`prayer_adhan_<n>_v1`) because Android
  fixes a channel's sound at creation. The user picks the Adhan in
  Settings -> Prayer alarms; the choice is saved and alarms are rescheduled.
- Follows phone volume, silent mode and Do-Not-Disturb; the app does not
  bypass them.
- Pre-reminders (X minutes before) use the default notification sound.
- Preview play/stop in the settings screen uses the same bundled files.
- Needs notification permission (Android 13+). Without exact-alarm permission,
  delivery can be a few minutes late.
- Some phone makers (Xiaomi, Oppo, Vivo, Huawei, Samsung power saving) kill
  background apps; the user may need to allow background activity.
- Not tested on a physical device; only CI build/analyze/tests run.
