import cligen, json, sequtils, tables, options
import cmdutils
import ../lib/flow, ../lib/genutils
import ../lib/io/cli, ../lib/io/files, ../lib/io/http, ../lib/io/io, ../lib/io/term
import ../lib/obj/manifest, ../lib/obj/manifestutils, ../lib/obj/mods, ../lib/obj/verutils

proc cmdUpdate*(name: seq[string], strategy: InstallStrategy = InstallStrategy.recommended): void =
  ## update an installed mod
  requirePaxProject
  if name.len == 0:
    stderr.write "Missing these required parameters:\n"
    stderr.write "  name\n"
    raise newException(ParseError, "")

  echoDebug "Loading data from manifest.."
  var project = parseJson(readFile(manifestFile)).projectFromJson
  let search = name.join(" ")

  echoDebug "Searching for mod.."
  let mcMod = project.searchForMod(search, installed=true)

  echo ""
  let file = project.getFile(mcMod.projectId)
  let mcModFile = parseJson(fetch(modFileUrl(file.projectId, file.fileId))).modFileFromJson
  project.displayMod(mcMod, mcModFile)
  echo ""

  returnIfNot promptYN("Are you sure you want to install this mod?", default=true)

  let latestFiles = mcMod.gameVersionLatestFiles
  let installVersion = project.getVersionToInstall(mcMod, strategy)
  if installVersion.isNone:
    echoError "No compatible version found."
    quit(1)
  echoInfo "Updating ", mcMod.name.clrCyan, " to version ", ($installVersion.get()).clrCyan, ".."
  project.updateMod(mcMod.projectId, latestFiles[installVersion.get()])

  echoDebug "Writing to manifest..."
  writeFile(manifestFile, project.toJson.pretty)