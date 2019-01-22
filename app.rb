# le programme ruby qui permet de lancer les classes contenues dans lib et qui installe les bonnes gems par la même occasion"

require 'bundler'
Bundler.require


$:.unshift File.expand_path("/home/paul/Documents/save_as_project/lib/app", __FILE__)
require 'mail_ville'

MailVille.new.perform