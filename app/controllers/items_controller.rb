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
end