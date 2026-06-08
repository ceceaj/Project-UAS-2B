$ErrorActionPreference = "Stop"

function Get-AsciiHeader {
	param([string] $Path)

	$bytes = Get-Content -Encoding Byte -TotalCount 4 $Path
	return [Text.Encoding]::ASCII.GetString($bytes)
}

$invalidWavFiles = @()
Get-ChildItem -Recurse -File -Include *.wav | ForEach-Object {
	$header = Get-AsciiHeader $_.FullName
	if ($header -ne "RIFF") {
		$invalidWavFiles += "$($_.FullName) starts with '$header'"
	}
}

if ($invalidWavFiles.Count -gt 0) {
	throw "Invalid WAV files found:`n$($invalidWavFiles -join "`n")"
}

$wrongAnimalAudioReferences = Get-ChildItem -Recurse -File -Include *.gd,*.tscn,*.tres,*.import |
	Select-String -Pattern "(Gajah|burung)\.wav"

if ($wrongAnimalAudioReferences) {
	throw "MP3 animal audio should not be referenced as WAV."
}

Write-Host "Audio asset checks passed."
