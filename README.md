# weekly-atcoder-report

weekly-atcoder-report (for short, war) posts weekly AtCoder submission status to Slack.

## Move

## Usage

```console
# if needed
bundle config set path vendor/bundle
```

```console
touch .env
echo "WEBHOOK_URL=<your Slack incoming webhook URL>" >> .env
```

```console
bundle install
bundle exec ruby main.rb
```

## Develop

### Test

```console
bundle exec ruby test/atcoder.rb
```

## Link
