if ((Test-Path Function:\TabExpansion) -and (-not (Test-Path Function:\PrevTabExpansion))) {
  Rename-Item Function:\TabExpansion PrevTabExpansion
}

function AntTabExpansion ($buildFile,$lastWord) {
  $buildFileDir = [regex]::Match($buildFile,'^(.+)/([^/]+)$').captures.groups[1].value
  if ($buildFileDir) { $buildFileDir += "/" }
  $targets = Select-Xml -Path ./$buildFile -XPath "//target[@name]" | ForEach-Object { $_.Node.Name }
  $importedTargets = @()
  $importedBuildFiles = Select-Xml -Path ./$buildFile -XPath "//import[@file]" | ForEach-Object { $_.Node.file }
  foreach ($importedBuildFile in $importedBuildFiles) {
    $isAbsolutePath = $importedBuildFile -match '/^(?:[A-Za-z]:)?\\/'
    if (!$isAbsolutePath) { $importedBuildFile = $buildFileDir + $importedBuildFile }
    $importedTargets += AntTabExpansion ($importedBuildFile,$lastWord)
  }
  return $targets + $importedTargets | Where-Object { ($_ -notlike "-*") -and ($_ -like "$lastWord*") } | Sort
}

function TabExpansion ($line,$lastWord) {
  $lastBlock = [regex]::Split($line,'[|;]')[-1].TrimStart()

  switch -regex ($lastBlock) {
    # Execute ant tab completion for non standard ant files  
    "ant -f (.*\.xml) (.*)" { AntTabExpansion $matches[1] $lastWord; break }
    # Execute ant tab completion for all ant targets
    "ant (.*)" { AntTabExpansion "build.xml" $lastWord; break }

    # Fall back on existing tab expansion
    default { if (Test-Path Function:\PrevTabExpansion) { PrevTabExpansion $line $lastWord } }
  }
}
