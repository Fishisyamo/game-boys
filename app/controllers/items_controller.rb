class ItemsController < ApplicationController
  def new
    @items = []
    @title = params[:title]
    if @title.present?
      results = RakutenWebService::Books::Game.search({
        title: @title,
        hits: 30,
        outOfStockFlag: 1,
      })
      
      results.each do |result|
        item = Item.find_or_initialize_by(read(result))
        @items << item
      end
    end
  end

  private

    # 取得情報をitem用ハッシュに保存
    def read(result)
       code = result['makerCode']
       name = result['title']
       url  = result['itemUrl']
       image_url = result['mediumImageUrl'].gsub('?_ex=120x120','')
  
      return {
        code: code,
        name: name,
        url: url,
        image_url: image_url,
      }
    end
end