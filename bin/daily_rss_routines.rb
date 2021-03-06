#!/usr/bin/env ruby
# == Synopsis
#   run the daily rss feeds
# == Usage
#  daily_rss_routines.rb  -h host -p port -d " 
# == Useful commands
# daily_rss_routines.rb  -d 
# daily_rss_routines.rb  -h svbalance.cure.com.ph
# == Author
#   Scott Sproule  --- Ficonab.com (scott.sproule@ficonab.com)
# == Copyright
#    Copyright (c) 2007 Ficonab Pte. Ltd.
#     See license for license details
require 'rubygems'
require 'optparse'
#
begin
  gem 'simple_sms_services'
  require 'simple_sms_services'
rescue LoadError => e
  puts '---- simple sms services required'
  puts '---- install with the following command'
  puts '----- sudo gem install simple_sms_services'
  puts "----- #{e.backtrace}"
  exit(1)
end
require 'optparse'
gem 'stomp_message'
require 'stomp_message'
require 'rdoc/usage'

 arg_hash=StompMessage::Options.parse_options(ARGV)
 RDoc::usage if   arg_hash[:help]==true
require 'pp'



to_do = { 'bbcnews' => 'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml',
           'ihtnews' =>'http://www.iht.com/rss/frontpage.xml' ,
           'wsjnews' => 'http://online.wsj.com/xml/rss/3_7013.xml' ,
           'bbcsports' => 'http://newsrss.bbc.co.uk/rss/sportonline_world_edition/front_page/rss.xml',
           'fitness' => 'http://www.crossfit.com/index1.xml',
           'joke' => 'http://www.thespoof.com/rss/thespoof_rss_091.xml',
             'wod' => 'http://www.winespectator.com/RSS/wod_rss/0,4007,,00.xml'
        #    'grandprixhardcore' => 'http://www.grandprix.com/ft/rss.xml',
         #    'grandprix' => 'http://www.grandprix.com/rss.xml'
        #   'weather' => 'http://www.weather.com/weather/rss/subscription/RPXX0017'
         }
feed_messages = []
to_do.each { |keyword, url|   puts "Processing #{keyword}: from: #{url}"
                #arguments = " -U #{url} -t #{keyword} --k #{keyword} "
                 feed=SimpleSmsServices::Feed.new(url,keyword)
                 args = {}
                 args=args.merge(arg_hash)
               #  puts "args is #{args}  arg hash is #{arg_hash}"
                 args[:broadcast]=""
                 args[:keyword]=keyword
                 result=feed.send_sms_to_subscription(args)
                 feed_messages << result
                 puts "result is #{result}"
                 feed=nil
                 sleep(1)  #just to let smsc relax
              } if false  # do not do this now...
to_do.each { |keyword, url|   puts "RSS text Processing #{keyword}: from: #{url}"
                              #arguments = " -U #{url} -t #{keyword} --k #{keyword} "
                               feed=SimpleSmsServices::Feed.new(url,keyword)
                               feed.unsubscribe_command="subscribe #{keyword} off"
                               args = {}
                               args=args.merge(arg_hash)
                             #  puts "args is #{args}  arg hash is #{arg_hash}"
                               args[:broadcast]=""
                               args[:keyword]=keyword
                               result=feed.send_mms_to_subscription(args)
                               feed_messages << result
                               puts "RSS result is #{result}"
                               feed=nil
                               sleep(1)  #just to let smsc relax
                            }              
puts "Result is #{feed_messages.join("\n")}"
  email='scott.sproule@cure.com.ph'
                
                    email='scott.sproule@cure.com.ph'
                    StompMessage::StompSendTopic.send_email_stomp("scott.sproule@cure.com.ph","DAILY RSS", email,
                                    "rss feeds: processed  #{feed_messages.size}", feed_messages.join('\n'))

#{}`get_feed.rb  -U 'http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml' -t bbcnews --k bbcnews `
#puts "iht news"
#{}`get_feed.rb  -U 'http://www.iht.com/rss/frontpage.xml' -t IHT -k ihtnews`
#puts "bbc sports"
# `get_feed.rb  -U 'http://www.iht.com/rss/frontpage.xml' -t IHT -k ihtnews`

exit!
