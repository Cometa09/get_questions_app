class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :notfound
  #для ошибки "ActiveRecord::RecordNotFound" вызвать следующий метод
  
  private

  def notfound(exception)
    logger.warn exception
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
