module Admin::V1
  class CategoriesController < ApplicationController
    def index
      @categories = Category.all
    end

    def create
      @category = Category.new
      @category.attributes = category_params

      save_category!
    rescue
      render_error(fields: @category.errors.messages)
    end

    def update
      @category = Category.find(params[:id])
      @category.attributes = category_params
      save_category!
    end

    private

    def category_params
      return {} unless params.has_key?(:category)
      params.require(:category).permit(:id, :name)
    end
  end
end
