import urllib2
import mechanize
import time

import mechanize
br = mechanize.Browser()  # allow everything to be written to
br.set_handle_robots(False)   # ignore robots
br.set_handle_refresh(False)  # can sometimes hang without this
  	# [('User-agent', 'Firefox')]

response = br.open("http://store.steampowered.com/agecheck/app/211420/")
# print response.read()      # the text of the page
response1 = br.response()  # get the response again
# print response1.read()     # can apply lxml.html.fromstring()

print mechanize.browser().forms()
# f = open('data/html/test2.html', 'w')
# f.write(html)
# f.close

