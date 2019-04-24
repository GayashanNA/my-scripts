from httplib import IncompleteRead
import tweepy
import datetime
import json
# Keep your access_token, access_token_secret, consumer_key, and consumer_secret in config.py file
import config

TWEET_COUNT = 100000
ROLLING_LENGTH = 1000
OUTPUT = []
COUNT = 0
LANGUAGES = ['en']
TOPICS = ['news']
LOCATIONS = [111.53, -43.96, 157.24, -10.83]
OUTPUT_FILENAME = "output.csv"


class StreamWatcherListener(tweepy.StreamListener):
    def on_data(self, raw_data):
        try:
            payload = json.loads(raw_data)
            tapp = long(payload['timestamp_ms'])
            tsys = get_current_time_ms_since_epoch()
            delay = tsys - tapp
            tweet_text = str(payload['text'].encode('utf-8', 'ignore')).replace('\n', ' ')
            event = "%s,%s,%s,%s\n" % (tsys, tapp, delay, tweet_text)
            OUTPUT.append(event)
            print event.replace('\n', '')
            print "Progress: %s" % (COUNT + len(OUTPUT))
            rolling_print_to_file(OUTPUT)
            if COUNT == TWEET_COUNT:
                return False
        except:
            pass

    def on_error(self, status_code):
        print "Error code: %s" % status_code  # log the error
        if status_code == 420 or status_code == 404:
            return False  # to avoid a penalty, stop requesting the stream
        return True

    def on_timeout(self):
        print 'Snoozing Zzzzzz'


def get_current_time_ms_since_epoch():
    delta = datetime.datetime.utcnow() - datetime.datetime(1970, 1, 1)
    current_time = long(delta.total_seconds() * 1000)
    return current_time


def rolling_print_to_file(list_to_print):
    global COUNT
    if len(list_to_print) % ROLLING_LENGTH == 0:
        print_to_file(list_to_print)
        del list_to_print[:]
        COUNT += ROLLING_LENGTH


def print_to_file(list_to_print):
    # filename = "output-%s.csv" % get_current_time_ms_since_epoch()
    if len(list_to_print) > 0:
        with open(OUTPUT_FILENAME, 'a') as outfile:
            outfile.writelines(list_to_print)


def main():
    auth = tweepy.OAuthHandler(config.consumer_key, config.consumer_secret)
    auth.set_access_token(config.access_token, config.access_token_secret)
    stream = tweepy.Stream(auth, StreamWatcherListener(), timeout=None)

    stream.filter(track=TOPICS, async=True, languages=LANGUAGES)
    # stream.filter(async=True, locations=LOCATIONS)


if __name__ == '__main__':
    try:
        main()
    except IncompleteRead:
        pass
    except KeyboardInterrupt:
        print '\nGoodbye!'
    except:
        pass
