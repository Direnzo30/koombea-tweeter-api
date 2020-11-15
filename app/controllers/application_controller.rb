class ApplicationController < ActionController::API

  # Handles authentication request
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from(ActionController::ParameterMissing) { |err| manage_missing_parameter_exception(err) }
  # All custom exceptions that inherits PersonalizedException are rescued here
  rescue_from(PersonalizedException) { |err| manage_personalized_exception(err) }

  def curr_user
    @current_user
  end

  # Handles requests autentications
  def authenticate_user!
    authenticate_or_request_with_http_token do |token, _|
      @current_user = User.find_by(authorization_token: token)
      raise UnauthorizedException.new if @current_user.nil?
      raise UnauthorizedException.new if @current_user.token_lifetime < Time.now().utc()
      @current_user.token_lifetime = Time.now().utc() + User::TOKEN_EXPIRACY
      @current_user.save!
      @current_user
    end
  end

  # Core for response render
  def centralize_response(response, status_code, serializer = nil, serializer_params = {})
    if status_code == :ok
      manage_good_response(response, serializer, serializer_params)
    else
      manage_bad_response(response[:error], status_code)
    end
  end

  private

  # Handles response un case of success
  def manage_good_response(response, serializer, serializer_params)
    # Apply custom serializer to content
    if serializer.present?
      # Check if its a collection
      if response[:content].respond_to? :each
        render_multiple_content(response, serializer, serializer_params)
      else
        render_single_content(response, serializer, serializer_params)
      end
    # Return explicit content
    else
      render_raw_content(response[:content])
    end
  end

  # Handles rendering for multiple objects of same class
  def render_multiple_content(response, serializer, serializer_params)
    render json: {
      result: ActiveModel::Serializer::CollectionSerializer.new(response[:content], { serializer: serializer, serializer_params: serializer_params }),
      metadata: response[:metadata]
    }
  end

  # Handles rendering for a single object
  def render_single_content(response, serializer, serializer_params)
    render json: {
      result: serializer.new(response[:content], { serializer_params: serializer_params }),
      metadata: response[:metadata]
    }
  end

  # Handles rendering raw rendering
  def render_raw_content(content)
    render json: { result: content }
  end

  # Handles errors rendering
  def manage_bad_response(message, error_code)
    render json: {
      error: message, 
      code: error_code 
    }, status: error_code
  end

  def manage_missing_parameter_exception(exception)
    msg = "Param #{exception&.param} is required and cannot be blank"
    manage_bad_response(msg, :bad_request)
  end

  def manage_personalized_exception(exception)
    manage_bad_response(exception&.message, exception.status_code)
  end

end
