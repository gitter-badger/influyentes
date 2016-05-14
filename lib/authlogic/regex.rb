module Authlogic
  module Regex
    def self.login
      /\A[a-zA-Z0-9_]{3,15}\z/
    end
  end
end
