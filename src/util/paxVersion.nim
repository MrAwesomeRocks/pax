## Helper file for retrieving pax version from project pax.nimble

import strutils

const currentPaxVersion*: string = staticExec("git describe --tags HEAD").split("-")[0]
