require 'bundler'
Bundler.require


$:.unshift File.expand_path("/home/paul/Documents/save_as_project/lib", __FILE__)
require 'mail_ville'

MailVille.new.perform