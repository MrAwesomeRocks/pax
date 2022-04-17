discard """
  cmd: "nim $target --hints:on -d:testing -d:ssl --nimblePath:tests/deps $options $file"
  joinable: false
  batchable: false
  input: '''
y
testmodpack
testauthor
1.0.0
1.16.5
forge
1
y
  '''
"""

import std/[json, os]
import cmd/[add, init]

removeDir("./modpack")
paxInit(force = false, skipManifest = false, skipGit = true)
paxAdd("just enough items", noDepends = false, strategy = "recommended", addonType = "")
let manifest = readFile("./modpack/manifest.json").parseJson

doAssert fileExists("./modpack/manifest.json")
doAssert manifest["files"][0]["projectID"].getInt == 238222