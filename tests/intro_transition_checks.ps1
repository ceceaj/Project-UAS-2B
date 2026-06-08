$ErrorActionPreference = "Stop"

function Assert-FileContains {
	param(
		[string] $Path,
		[string] $Pattern,
		[string] $Message
	)

	$content = Get-Content -Raw $Path
	if ($content -notmatch $Pattern) {
		throw $Message
	}
}

Assert-FileContains "title_screen.gd" "start_intro_sequence" "Play button should start the intro sequence instead of changing directly to the world."
Assert-FileContains "title_screen.gd" "intro_finished" "Title screen should wait for the intro video to finish before changing scene."
Assert-FileContains "title_screen.tscn" "VideoStreamPlayer" "Title screen scene should include a VideoStreamPlayer for the intro."
Assert-FileContains "title_screen.tscn" "res://video/Intro.ogv" "Title screen scene should reference a Godot-loadable OGV intro video."
Assert-FileContains "game.gd" "fade_in_from_black" "Game scene switcher should fade in from black after entering the world."

$titleScene = Get-Content -Raw "title_screen.tscn"
if ($titleScene -match "Intro\.webm") {
	throw "Title screen should not reference Intro.webm because Godot cannot load it as VideoStream."
}

if (!(Test-Path "video/Intro.ogv")) {
	throw "video/Intro.ogv should exist for Godot VideoStreamPlayer."
}

Write-Host "Intro transition checks passed."
