module DelegateMissingTo
  def delegate_missing_to(relation)
    define_method :respond_to_missing? do |name, include_private = false|
      send(relation).respond_to?(name) || super(name, include_private)
    end

    define_method :method_missing do |method, *args, **opts, &block|
      if send(relation).respond_to?(method)
        send(relation).public_send(method, *args, **opts, &block)
      else
        begin
          super(method, *args, **opts, &block)
        rescue NoMethodError
          raise
        end
      end
    end
    
    private :respond_to_missing?
    private :method_missing
  end
end
