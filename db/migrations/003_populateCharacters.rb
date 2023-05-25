require 'faraday'
require 'nokogiri'
require 'tty-progressbar'
require 'tty-spinner'
require 'pastel'

pas = Pastel.new
comp = pas.green '▰'
inc = pas.green '▱'

Sequel.migration do
  up do
    spinner = TTY::Spinner.new('[:spinner] Querying characters', format: :dots)
    spinner.auto_spin
    listSrc = Faraday.get('https://genshin.honeyhunterworld.com/fam_chars/?lang=EN').body
    spinner.success('(Done)')
    spinner = TTY::Spinner.new('[:spinner] Parsing list', format: :dots)
    doc = Nokogiri::HTML(listSrc)
    scs = doc.css('script').text
    a = scs.index 'sortable_data.push'
    b = scs.index 'sortable_cur_page.push'
    js = scs[a+19...b-2]
    list = JSON.parse(js)
    spinner.success('(Done)')
    begin
      bar = TTY::ProgressBar.new(':bar', bar_format: :blade, clear: true, hide_cursor: true, total: list.count, complete: comp, incomplete:inc)
      bar.resize
      bar.format = 'Adding :current/:total :bar'
      list.each do
        |frag|
        char = Nokogiri::HTML5::DocumentFragment.parse(frag[0])
        name = url = ''
        char.css('a div img').each { |l| name = l['alt'] }
        char.css('a').each { |l| url = l['href'] }

        bar.advance
        self[:characters].insert(name: name, statsUrl: url)
        bar.log('Added %s' % name)
        sleep 0.1
      end
    ensure
      # ensure that cursor is made visible again
      bar.finish
    end
  end

  down do
    self[:characters].truncate
  end
end
