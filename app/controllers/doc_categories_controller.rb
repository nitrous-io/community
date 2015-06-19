class DocCategoriesController < ApplicationController
  before_action :verify_admin

  def index
    @content = DocCategory.ordered
    @new_category = DocCategory.new
  end

  def create
    if @content = DocCategory.create(content_params)
      flash[:success] = "Category has been created"
      redirect_to action: 'index'
    else
      flash[:error] = "Unable to create category"
      render :index
    end
  end

  def update
    content_params = params['doc_categories']
    ids = content_params.try(:keys)
    if ids.present?
      categories = DocCategory.where('id IN (?)', ids.map(&:to_i))

      begin
        DocCategory.transaction do
          categories.each do |category|
            if name = content_params[category.id.to_s]['name']
              category.name = name
            end
            if position = content_params[category.id.to_s]['position']
              category.position = position
            end
            category.save!
          end
        end
      rescue
      else
        flash[:success] = "Categories have been updated"
        redirect_to action: 'index'
        return
      end
    end

    flash[:error] = "Unable to update categories"
    render :index
  end

  def destroy
    @content = DocCategory.find(params[:id].to_i)
    if @content.present? && @content.destroy
      flash[:success] = "Category has been deleted"
      redirect_to action: 'index'
    else
      flash[:error] = "Unable to delete category. (Category not empty?)"
      redirect_to :back
    end
  end

  protected
  def content_params
    params.require(:doc_category).permit(:name, :position)
  end
end
