# SR-Hdiff Patcher: a tool for updating HSR properly

If you update the game by simply copying all the *update files* and then replacing them in the game client directory, that's actually not the correct way. You should merge the `.pck.hdiff` update with the old `.pck` file and delete the obsolete files listed in `deletefiles.txt`.

## How to use?

For example, you want to update the game from 2.3.0 to 2.4.0:

1. Make sure you have extracted all files from the `game_2.3.0_2.4.0_hdiff.zip` and `audio_en-us_2.3.0_2.4.0_hdiff.zip`, then replace them in the `2.3.0` game client directory.
2. Place the following files in the same folder as `StarRail.exe`:
   - `hdiffz.exe`
   - `hpatchz.exe`
   - `Start.bat`
   - `Cleanup_2.3.0-2.4.0.txt`
   - `AudioPatch_Common_2.3.0-2.4.0.txt`
   - `AudioPatch_English_2.3.0-2.4.0.txt`
   - `AudioPatch_Japanese_2.3.0-2.4.0.txt`
   - `AudioPatch_Chinese_2.3.0-2.4.0.txt`
   - `AudioPatch_Korean_2.3.0-2.4.0.txt`
3. Run `Start.bat` and wait until the process finishes.
4. Now, your game is updated to version `2.4.0`.

## Note
  - Overview of the merging process:
    ```
    Banks0.pck (59.5 MB)        // old file, before update
    + Banks0.pck.hdiff (3.0 MB) // hdiff update
    -----------------------------
    = Banks0.pck (62.5 MB)      // new file with new size, after update
    ```
