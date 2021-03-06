#!/usr/bin/env ruby
# == Synopsis
#   grab and send mms from tags to msisdn
# == Usage
#  flickr_tag_test.rb  -h host -m msisdn -t tags" 
# == Useful commands
# flickr_tag_test.rb  -m 639993130030 -t 'sexy bikini' 
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
 RDoc::usage if   arg_hash[:help]==true or arg_hash[:text]==nil or arg_hash[:msisdn]==nil
require 'pp'
  tag= arg_hash[:text]
  msisdn=arg_hash[:msisdn]
 puts "MMS Processing images  using flickr: #{tag}"
      feed=SimpleSmsServices::FlickrImages.new(tag,
                            "Flickr images: #{tag}")
                    
                     result= feed.send_to_mms_manager(arg_hash, msisdn)  
                              
                   puts "found #{feed.pictures.size} images. MMS result is #{result}"
                                               

exit!
