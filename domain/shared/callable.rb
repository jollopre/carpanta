module Carpanta
  module Domain
    module Shared
      module Callable
        def call(*args, &block)
          new.call(*args, &block)
        end
      end
    end
  end
end
