import tweepy
from sys import argv

consumer_key = '#########################'
                
consumer_secret = '##################################################'
                   
access_token = '##################################################'
                
access_token_secret = '#############################################'
                       


def OAuth():
    try:
        auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
        auth.set_access_token(access_token, access_token_secret)
        return auth
    except Exception as e:
        return None


oauth = OAuth()

api = tweepy.API(oauth)



if argv[1] == 'enter':
    api.update_status('Buy: {} at {}, Short: {} at {}'.format(argv[2], argv[3], argv[4], argv[5]))

if argv[1] == 'exit':
    api.update_status('Sell: {} at {}, Buyback: {} at {}'.format(argv[2], argv[3], argv[4], argv[5]))
    api.update_status('Long Profit: {}, Short Profit: {}, Total Profit: {}'.format(argv[6], argv[7], argv[8]))



