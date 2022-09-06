class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end
  
  def show
    # byebug
    session[:pageviews_remaining] ||= 3
    if (session[:pageviews_remaining] > 0)
      session[:pageviews_remaining] =- 1
      article = Article.find(params[:id])
      render json: article
    else 
        render json: { error: "Unauthorized" }, status: :unauthorized      
    end

  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
  
  def reduce_page_remaining
    
  end

end
