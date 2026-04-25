param(
    [Parameter(Mandatory = $false)]
    [string]$TweetsPath = "demonetization-tweets.csv",

    [Parameter(Mandatory = $false)]
    [string]$LexiconPath = "AFINN.txt",

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = "output",

    [Parameter(Mandatory = $false)]
    [string]$PigScript = "demonotetization_analysis.pig"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command pig -ErrorAction SilentlyContinue)) {
    throw "Apache Pig executable ('pig') was not found in PATH."
}

Write-Host "Running Pig sentiment analysis..."
Write-Host "Tweets : $TweetsPath"
Write-Host "Lexicon: $LexiconPath"
Write-Host "Output : $OutputDir"
Write-Host "Script : $PigScript"

pig `
    -param INPUT_TWEETS="$TweetsPath" `
    -param INPUT_LEXICON="$LexiconPath" `
    -param OUTPUT_DIR="$OutputDir" `
    "$PigScript"

if ($LASTEXITCODE -ne 0) {
    throw "Pig execution failed with exit code $LASTEXITCODE."
}

Write-Host "Pig execution completed successfully."
