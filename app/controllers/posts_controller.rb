class PostsController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  HOGE = rand(1..100).freeze

  def index
    render json: { message: "Hello, posts controller!!", hoge: HOGE }
  end
end
