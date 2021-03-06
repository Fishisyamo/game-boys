class OwnershipsController < ApplicationController

  def create
    @item = Item.find_or_initialize_by(code: params[:item_code])

    # @itemが保存されていない場合、先に @item を保存する
    unless @item.persisted?
      results = RakutenWebService::Books::Game.search({jan: @item.code,
                                                       outOfStockFlag: 1})
      @item = Item.new(read(results.first))
      @item.save
    end

    # Favo関係として保存
    if params[:type] == 'Favo'
      current_user.favo(@item)
      flash[:success] = "ゲームを Favo に登録しました。"
    # Play関係として保存
    elsif params[:type] == 'Play'
      current_user.play(@item)
      flash[:success] = "ゲームを Play に登録しました。"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @item = Item.find(params[:item_id])

    if params[:type] == 'Favo'
      current_user.unfavo(@item)
      flash[:danger] = 'ゲームを Favo から外しました。'
    elsif params[:type] == 'Play'
      current_user.unplay(@item)
      flash[:danger] = 'ゲームを Play から外しました。'
    end
    redirect_back(fallback_location: root_path)
  end
end