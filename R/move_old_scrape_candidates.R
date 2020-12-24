fileNames <- list.files()
candIdx <- grep("candidate_", fileNames)
cands <- fileNames[candIdx]

cands
tobeMoved <- cands[1:45]
tobeMoved <- cands[file.info(cands)$mtime < "2019-01-11 00:00:30 UTC"]

file.rename(tobeMoved, paste0("candidate_archive/", tobeMoved))

tobeMoved <- cands[file.info(cands)$atime != file.info(cands)$mtime]

file.rename(tobeMoved, paste0("candidate_archive/", tobeMoved))
