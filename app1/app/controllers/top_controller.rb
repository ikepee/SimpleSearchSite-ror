class TopController < ApplicationController
  require "open-uri"
  require 'uri'

  def index
  end

  def result
    @res = Array.new
    @lists = Array.new
    @rescount = 0
    @page = 1

    @keyword = (params[:keyword].gsub(/[\s　]/, ' ')).gsub(/\s+/, ' ')
    if params[:page] then
      @page = params[:page].to_i
    end
    
    @keywords = @keyword.split(/\s/)
    whereku = ""
    for num in 0..@keywords.count - 1 do
      whereku = whereku << "(comment like '%#{@keywords[num]}%')"
      if num != @keywords.count - 1 then
        whereku = whereku << " and "
      end
    end
    inres = Resultlist.where(whereku)
    @rescount = inres.length

    if @rescount == 0 then
      url = "http://www.bing.com/search?q=#{@keyword}"
			url_escape = URI.escape(url)
			user_agent = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36'
      charset = nil
      html = open(url_escape, "User-Agent" => user_agent) do |f|
			  charset = f.charset
			  f.read
      end
      
      @resbing = html.scan(%r{<li class="b_al(.+?)</li>})
      bingres = Array.new
      for i in 0..@resbing.length - 1 do
        url, title, comment = (@resbing[i][0].scan(%r{<a href="(.+?)".+?>(.+?)</a>.+?p>(.+?)</p>}))[0]
        bingres.push([url, title, comment])
      end
      
      t1 = Thread.new {
        ilist = Array.new
        bingres.each do |p1, p2, p3|
          if p1 and p2 and p3 then
            ilist.push(Resultlist.new(:url => p1, :title => p2.gsub(%r{<strong>}, '').gsub(%r{</strong>}, ''), :comment => p3.gsub(%r{<strong>}, '').gsub(%r{</strong>}, '')))
          
          end
        end
        Resultlist.import ilist
        inres = Resultlist.where(whereku)
        @rescount = inres.length
      }
      t1.join
    end

    if @rescount != 0 then
      startnum = (@page * 5) - 5
      endnum = (@page * 5) - 1
      if endnum >= @rescount then
        endnum = @rescount - 1
      end
      for num in startnum..endnum do
        if inres.length != 0 then
          @res.push(inres[num])
        end
      end
    end
  end

end
