# toutes les gems nécessaires

require 'pry'
require 'rspec'
require 'rubocop'
require 'nokogiri'
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'
page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))

PAGE_URL = "http://annuaire-des-mairies.com/val-d-oise.html"

# définition de la classe ville ==> mail
class MailVille

  # récupérer le mail
  def get_the_email(page)
  page = Nokogiri::HTML(open(page))
  text = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').text 
    if text != "" 
      return text 
    else 
      return "AUCUN EMAIL" 
    end
  end

  # récupérer le nom des villes et y associer une url
  def get_the_url(page) 
    url = page.chomp("val-d-oise.html") 
    page = Nokogiri::HTML(open(page))
    municipalities = [] 
    page.css("a.lientxt").each do |municipality| 
    municipalities << {municipality.text => get_the_email(url + municipality['href'].sub!("./", ""))}
    end
    return municipalities 
  end

  # mtéhode pour sauvegarder la liste sur un fichier JSON
  def save_as_JSON(municipalities)
    File.open("/home/paul/Documents/save_as_project/db/email.json","w") do |f|
      f.write(municipalities.to_json)
    end
  end

  # mtéhode pour sauvegarder la liste sur un sheet Google
  def save_as_spreadsheet(municipalities)
    session = GoogleDrive::Session.from_config("config.json")
    ws = session.spreadsheet_by_key("10URCixdlldzOgVwdmbYIIpQWyd_kREt0vetjSTyK1x4").worksheets[0]
    
    i = 1
    municipalities.each do |municipality|
    municipality.each_pair do |ville, mail|
      ws[i, 1] = ville 
      ws[i, 2] = mail
      i+=1
    end
  end
    ws.save
  end

  # mtéhode pour sauvegarder la liste sur un fichier csv
  def save_as_csv(municipalities)
    CSV.open("/home/paul/Documents/save_as_project/db/email.csv", "wb")  do |csv| 
    municipalities.each do |municipality|
    municipality.each_pair do |ville, mail|
    csv << [ville, mail]
    end
    end
    end
  end

  # le bouquet final pour que tout fonctionne 
  def perform
    municipalities = get_the_url(PAGE_URL)
    for municipality in municipalities 
      puts municipality
    save_as_JSON(municipalities)
    save_as_spreadsheet(municipalities)
    save_as_csv(municipalities)
    end
  end

end
