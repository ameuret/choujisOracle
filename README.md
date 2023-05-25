# Chouji's Oracle

## Sources
  
  * [Genshin Impact Database](https://genshin.honeyhunterworld.com/fam_chars/?lang=EN)
  
# Dev walkthrough

This section is for people willing to understand how the scraping is done. If you just want the database, grab [the release file](./db/oracle.db), it's a [SQLite](https://sqlite.org) database file.

## Install dependencies

``` bash
bundle
```

## Create or update db file

``` bash
bundle exec sequel -m db/migrations/ sqlite://db/oracle.db
```

## Mining
  
### Getting the list of characters

Simply scraping the table doesn't work because it's loaded dynamically by JS. This way only gives the first 20 characters:
  ```ruby
  require 'faraday'
  require 'nokogiri'
  listP = Faraday.get('https://genshin.honeyhunterworld.com/fam_chars/?lang=EN').body
  doc = Nokogiri::HTML(listP)
  doc.css('.genshin_table a').each {|el| puts el.text + ' -> '+ el['href'] unless el.text.empty?};nil
  ```
  
  The full list hides in HTML fragments stored in a script tag so we first locate the script, then parse the JS and parse the fragments. 😑
  
  ```ruby
  scs = doc.css('script').text
  a = scs.index 'sortable_data.push'
  b = scs.index 'sortable_cur_page.push'
  js = scs[a+19...b-2]
  list = JSON.parse(js)
  char = Nokogiri::HTML5::DocumentFragment.parse(list[0][0])
  char.css('a div img').each{|l| puts l['alt']};nil
  char.css('a').each{|l| puts l['href']};nil
  ```
  
### Getting a character's stats
  
  ```ruby
  ayakaSrc = Faraday.get('https://genshin.honeyhunterworld.com/ayaka_002/?lang=EN').body
  ayaka = Nokogiri::HTML(ayakaSrc)
  ayaka.css('table.genshin_table.stat_table').first.children.each{|lvl| lvl.children.each {|c| print c.text, " / "};puts ''};nil
  ```
