discard """
  cmd: "nim $target --hints:on -d:testing -d:ssl --nimblePath:tests/deps $options $file"
  joinable: false
  batchable: false
  output: '''
[:] Loading data from manifest..
[:] Writing to manifest...
[-] Set MC version 1.16.3
[:] Set forge version forge-34.1.0
'''
"""

import std/[json, os]
import cmd/version
import term/color

disableTermColors()

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
      "projectID": 60089,
      "fileID": 2849221,
      "required": true,
      "__meta": {
        "name": "Mouse Tweaks",
        "explicit": true,
        "dependencies": []
      }
    },
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

block: # change loader version
  removeDir("./modpack/")

  createDir("./modpack")
  writeFile("./modpack/manifest.json", manifestJson.pretty)
  paxVersion("1.16.3", "forge", false)

  let manifest = readFile("./modpack/manifest.json").parseJson
  doAssert manifest["minecraft"]["modLoaders"][0]["id"].getStr() == "forge-34.1.0"