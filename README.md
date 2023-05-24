# Chouji's Oracle

  ## Scrape the web
  
  ## Genshin Impact Database
  
  [Genshin Impact Database](https://genshin.honeyhunterworld.com/fam_chars/?lang=EN)
  
  ### Mining
  
  Getting the list of characters
  
  ```ruby
  require 'faraday'
  require 'nokogiri'
  listP = Faraday.get('https://genshin.honeyhunterworld.com/fam_chars/?lang=EN').body
  doc = Nokogiri::HTML(listP)
  doc.css('.genshin_table a').each {|el| puts el.text + ' -> '+ el['href'] unless el.text.empty?};nil
  ```
  
  * Build the database
  * Enjoy

# Dev walkthrough

## Install dependencies

``` bash
bundle
```

## Create or update db file

``` bash
bundle exec sequel -m db/migrations/ sqlite://db/oracle.db
```

