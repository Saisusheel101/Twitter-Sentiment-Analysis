# Twitter Sentiment Analysis on Demonetization (Apache Pig)

This project classifies demonetization-related tweets into sentiment groups using an Apache Pig script and the AFINN sentiment lexicon.

## What this project does

- Reads tweets from a CSV file (`id,text` format)
- Tokenizes each tweet into words
- Looks up each word in `AFINN.txt` (word -> score from `-5` to `+5`)
- Computes an average sentiment score per tweet
- Writes tweets to:
  - `positive_tweets` (`tweet_rating > 0`)
  - `negative_tweets` (`tweet_rating < 0`)
  - `neutral_tweets` (`tweet_rating == 0`)

## Project files

- `demonotetization_analysis.pig`: main Pig script
- `AFINN.txt`: sentiment dictionary
- `docs/DATASET.md`: expected input schema and formatting rules
- `scripts/run_pig.ps1`: helper script for running Pig on Windows/PowerShell

## Prerequisites

- Apache Hadoop + Apache Pig installed and available in your environment
- Input tweets file available in CSV format

## Run the analysis

Use either direct Pig command or helper script.

### Option 1: Direct Pig command

```bash
pig ^
  -param INPUT_TWEETS="demonetization-tweets.csv" ^
  -param INPUT_LEXICON="AFINN.txt" ^
  -param OUTPUT_DIR="output" ^
  demonotetization_analysis.pig
```

### Option 2: PowerShell helper

```powershell
.\scripts\run_pig.ps1 -TweetsPath "demonetization-tweets.csv" -LexiconPath "AFINN.txt" -OutputDir "output"
```

## Output

After execution, the output directory contains:

- `output/positive_tweets`
- `output/negative_tweets`
- `output/neutral_tweets`

Each output record includes:

- `id`
- `text`
- `tweet_rating` (average sentiment score)

## Notes

- Unknown words (not in `AFINN.txt`) are treated as `0` score.
- Text is lowercased before lexicon matching for more consistent results.
- CSV parsing assumes simple comma-separated input. If tweet text includes unescaped commas, preprocess input first.
