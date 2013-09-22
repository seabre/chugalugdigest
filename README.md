# chugalugdigest
[![Build Status](https://travis-ci.org/seabre/chugalugdigest.png)](https://travis-ci.org/seabre/chugalugdigest)

## About

This came about because members of [Chugalug] that also subscribed to the [subreddit](http://www.reddit.com/r/chugalug) wanted daily digests sent to the subreddit.

##Configuration

### Environment Variables

The app is looking for the following environment variables

| Environment Variable   | Description                                                                               |
| -----------------------| ----------------------------------------------------------------------------------------- |
| `REDDIT_USERNAME`      | A string containing the reddit username of the bot you want to use.                       |
| `REDDIT_PASSWORD`      | A string containing the password for the reddit username of the bot you want to use.      |
| `REDDIT_SUBREDDIT`     | A string containing the subreddit where you want to post to.                              |
| `LISTDIGEST_WHITELIST` | A string of comma separated e-mail addresses that are allowed to send to the app.         |
| `IP_WHITELIST`         | A string of comma separated IP addresses that are allowed to POST e-mail data to the app. |

You can either use `config/application.yml` to store your environment variables for development or a `.env.development`
The test environment currently uses `.env.test`. I am probably moving to using strictly [dotenv](https://github.com/bkeepers/dotenv) for working with environment variables, so for now, whichever method you decide to use is up to you.

### Inbound API

For the app to just work, the app was designed to work with [Postmark's Inbound JSON API](http://developer.postmarkapp.com/developer-inbound.html). You can either use their service or slightly modify the app to use whatever you want.

If you want to work with mailman, you will need to signup for the mailing list with the special e-mail address Postmark gave you for inbound e-mailing. 
You can do this without having the application setup, but ensure that your app isn't posting these e-mails anywhere. Also, in your mailman config for your account, **make sure you disallow mailman from e-mailing your mailing list account password once a month**. If you don't that's bad.

Also, you will want keep your e-mail hidden from the membership list. Configure your account to not show your inbound mailing address. I have taken measures to guard against if your inbound e-mail address gets exposed, but it's still a very good idea to keep it hidden.

## Contributing

Pull requests are accepted. If you're adding features, please have tests if possible.

## License

The application is under the MIT License.

