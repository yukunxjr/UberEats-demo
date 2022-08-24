# 仮注文を作成するメソッド
# パラメーターには「どのフード？」、また「それをいくつ？(数量)」という２つが必要
module Api
    module V1
      class LineFoodsController < ApplicationController
        before_action :set_food, only: %i[create replace]

    # 仮注文一覧
        def index
            line_foods = LineFood.active
            # 対象のインスタンスのデータがDBに存在するかどうか？
            if line_foods.exists?
              render json: {
                line_food_ids: line_foods.map { |line_food| line_food.id },
                restaurant: line_foods[0].restaurant,
                count: line_foods.sum { |line_food| line_food[:count] },
                amount: line_foods.sum { |line_food| line_food.total_amount },
              }, status: :ok
            else
              render json: {}, status: :no_content
            end
        end
  
    # 仮注文の作成
        def create
         # 他店舗での仮注文がある場合
         # modelで定義したactiveとother_restaurantを使う
         # 存在するかどうか？をexists?で判断
          if LineFood.active.other_restaurant(@ordered_food.restaurant.id).exists?
            return render json: {
              existing_restaurant: LineFood.other_restaurant(@ordered_food.restaurant.id).first.restaurant.name,
              new_restaurant: Food.find(params[:food_id]).restaurant.name,
            }, status: :not_acceptable
          end

         # 正常に仮注文した場合
          set_line_food(@ordered_food)

         # エラーが発生した場合にはif @line_food.saveでfalseと判断されelse以降が帰る
          if @line_food.save
            render json: {
              line_food: @line_food
            }, status: :created
          else
            render json: {}, status: :internal_server_error
          end
        end

    # 例外パターン
        def replace
            LineFood.active.other_restaurant(@ordered_food.restaurant.id).each do |line_food|
              line_food.update_attribute(:active, false)
            end
    
            set_line_food(@ordered_food)
    
            if @line_food.save
              render json: {
                line_food: @line_food
              }, status: :created
            else
              render json: {}, status: :internal_server_error
            end
          end
  
        private
  
        def set_food
          @ordered_food = Food.find(params[:food_id])
        end
  
        def set_line_food(ordered_food)
            # 仮注文が存在するか？否か？
          if ordered_food.line_food.present?
            @line_food = ordered_food.line_food
            @line_food.attributes = {
              count: ordered_food.line_food.count + params[:count],
              active: true
            }
          else
            @line_food = ordered_food.build_line_food(
              count: params[:count],
              restaurant: ordered_food.restaurant,
              active: true
            )
          end
        end
      end
    end
  end
  
  