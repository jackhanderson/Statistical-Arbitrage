import tweepy
from sys import argv

consumer_key = 'e2IfpmdsIHGSy9KeZElwVMVBK'
consumer_secret = 'r335K4VZs1FaQO3W2K7sEmUPHmRyrkdwFqTi643P7w01ub2k04'
access_token = '1197282599493947397-q1DcubDTGUa0vnxPglvlPh3VDb8U5B'
access_token_secret = 'lqizyFTcpx4rdBWGibM3HKlCDToExq5LDXONrc9ixQqRc'


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



