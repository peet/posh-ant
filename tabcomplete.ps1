if ((Test-Path Function:\TabExpansion) -and (-not (Test-Path Function:\PrevTabExpansion))) {
    Rename-Item Function:\TabExpansion PrevTabExpansion
}

function AntTabExpansion($lastWord) {
  return Select-Xml -path ./build.xml -xpath "//target[@name]"| foreach { $_.Node.name } | Where-Object { ($_ -notlike "-*") -and ($_ -like "$lastWord*") } | Sort
}

function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()

    switch -regex ($lastBlock) {
        # Execute ant tab completion for all ant targets
        "ant (.*)" { AntTabExpansion $lastWord }

        # Fall back on existing tab expansion
        default { if (Test-Path Function:\PrevTabExpansion) { PrevTabExpansion $line $lastWord } }
    }
}