class ItemsController < ApplicationController
  before_action :logged_in_user, only: [:new]

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
  
  def show
    @item = Item.find(params[:id])
    @favo_users = @item.favo_users
    @play_users = @item.play_users
  end
end