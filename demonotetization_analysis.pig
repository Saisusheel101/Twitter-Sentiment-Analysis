-- -----------------------------------------------------------------------------
-- Sentiment Analysis on Tweets using Apache Pig
-- Usage:
-- pig -param INPUT_TWEETS=/path/to/demonetization-tweets.csv \
--     -param INPUT_LEXICON=/path/to/AFINN.txt \
--     -param OUTPUT_DIR=/path/to/output \
--     demonotetization_analysis.pig
-- -----------------------------------------------------------------------------

%default INPUT_TWEETS 'demonetization-tweets.csv'
%default INPUT_LEXICON 'AFINN.txt'
%default OUTPUT_DIR 'output'

raw_data = LOAD '$INPUT_TWEETS' USING PigStorage(',') AS (id:chararray, text:chararray);

clean_data = FILTER raw_data BY id IS NOT NULL AND text IS NOT NULL;

tokenized = FOREACH clean_data GENERATE
    id,
    text,
    FLATTEN(TOKENIZE(LOWER(text))) AS word:chararray;

dictionary = LOAD '$INPUT_LEXICON' USING PigStorage('\t') AS (word:chararray, rating:int);

word_ratings = JOIN tokenized BY word LEFT OUTER, dictionary BY word USING 'replicated';

-- Convert unmatched words to 0 score to avoid null aggregation issues.
ratings = FOREACH word_ratings GENERATE
    tokenized::id AS id:chararray,
    tokenized::text AS text:chararray,
    ((dictionary::rating IS NULL) ? 0 : dictionary::rating) AS rating:int;

grouped_tweets = GROUP ratings BY (id, text);

tweet_scores = FOREACH grouped_tweets GENERATE
    FLATTEN(group) AS (id:chararray, text:chararray),
    AVG(ratings.rating) AS tweet_rating:double;

positive_tweets = FILTER tweet_scores BY tweet_rating > 0;
negative_tweets = FILTER tweet_scores BY tweet_rating < 0;
neutral_tweets = FILTER tweet_scores BY tweet_rating == 0;

STORE positive_tweets INTO '$OUTPUT_DIR/positive_tweets' USING PigStorage(',');
STORE negative_tweets INTO '$OUTPUT_DIR/negative_tweets' USING PigStorage(',');
STORE neutral_tweets INTO '$OUTPUT_DIR/neutral_tweets' USING PigStorage(',');
