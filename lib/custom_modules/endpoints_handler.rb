module EndpointsHandler
  module ClassMethods
    COMMON_ERRORS = [
      ActiveRecord::RecordNotFound,
      ActiveRecord::RecordInvalid,
      ActiveRecord::RecordNotUnique
    ]

    # Used for non token required endpoints
    def flat_endpoint(*pars)
      begin
        [yield(*pars), :ok]
      rescue PersonalizedException => e
        [{ error: e&.message }, e&.status_code]
      rescue *COMMON_ERRORS => e
        [{ error: e&.message }, :unprocessable_entity]
      rescue StandardError => e
        [{ error: e&.message }, :internal_server_error]
      end
    end

    # Used for permissions required endpoints
    def permissions_endpoint(user, *pars, &block)
      # Here can be putted code to verify if endpoint if accesible by user
      begin
        [yield(user, *pars), :ok]
      rescue PersonalizedException => e
        [{ error: e&.message }, e&.status_code]
      rescue *COMMON_ERRORS => e
        [{ error: e&.message }, :unprocessable_entity]
      rescue StandardError => e
        [{ error: e&.message }, :internal_server_error]
      end
    end
  end
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end