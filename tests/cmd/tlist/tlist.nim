discard """
  cmd: "nim $target --hints:on -d:testing -d:ssl --nimblePath:tests/deps $options $file"
  joinable: false
  batchable: false
  output: '''
[:] Loading files from manifest..
[-] Loading mods..
[Δ] ALL MODS (1)
 └─ •↑ Just Enough Items (JEI) - https://www.curseforge.com/minecraft/mc-mods/jei/files/3383205
  '''
"""

import json, os
import cmd/list

block:
  removeDir("./modpack/")

  let manifestJson = %* {
    "minecraft": {
      "version": "1.16.5",
      "modLoaders": [
        {
          "id": "forge-36.1.0",
          "primary": true
        }
      ]
    },
    "manifestType": "minecraftModpack",
    "overrides": "overrides",
    "manifestVersion": 1,
    "version": "1.0.0",
    "author": "testauthor",
    "name": "testmodpack123",
    "files": [
      {
        "projectID": 238222,
        "fileID": 3383205,
        "required": true,
        "__meta": {
          "name": "Just Enough Items (JEI)",
          "explicit": true,
          "dependencies": []
        }
      }
    ]
  }

  createDir("./modpack")
  writeFile("./modpack/manifest.json", manifestJson.pretty)
  paxList(status = false, info = false)