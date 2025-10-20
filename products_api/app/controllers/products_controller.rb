class ProductsController < ApplicationController
  def create
    @category = Category.find_by(name: product_params[:category])

    @product = Product.new(product_params.merge(category: @category))
    @product.user_external_id = @current_user.external_id

    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :category)
  end
end
