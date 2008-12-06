module SimplyRestful
  module Routes
    def resource(entity, options={})
      plural = entity.to_s.pluralize

      collection  = options.delete(:collection) || {}
      member      = options.delete(:member) || {}
      new         = options.delete(:new) || true
      path_prefix = options.delete(:path_prefix)
      name_prefix = options.delete(:name_prefix)

      member[:edit] = :get

      new = new.is_a?(Hash) ? {:new => :get}.update(new) : { :new => :get }

      collector = Proc.new { |h,(k,v)| (h[v] ||= []) << k; h }

      collection_methods = collection.inject({}, &collector) 
      member_methods = member.inject({}, &collector)
      new_methods = new.inject({}, &collector)

      (collection_methods[:post] ||= []).unshift :create
      (member_methods[:put] ||= []).unshift :update
      (member_methods[:delete] ||= []).unshift :delete

      path = "#{path_prefix}/#{plural}"

      collection_path = path
      new_path = "#{path}/new"
      member_path = "#{path}/:id"

      with_options :controller => (options[:controller] || plural).to_s do |map|
        collection_methods.each do |method, list|
          primary = list.shift.to_s if method != :get
          route_options = requirements_for(method)
          list.each do |action|
            map.named_route("#{name_prefix}#{action}_#{plural}", "#{collection_path};#{action}", route_options.merge(:action => action.to_s))
          end
          map.connect(collection_path, route_options.merge(:action => primary)) unless primary.blank?
        end

        map.named_route("#{name_prefix}#{plural}", collection_path, :action => "index", :require => { :method => :get })

        new_methods.each do |method, list|
          route_options = requirements_for(method)
          list.each do |action|
            path = action == :new ? new_path : "#{new_path};#{action}"
            name = "new_#{entity}"
            name = "#{action}_#{name}" unless action == :new
            map.named_route("#{name_prefix}#{name}", path, route_options.merge(:action => action.to_s))
          end
        end

        member_methods.each do |method, list|
          route_options = requirements_for(method)
          primary = list.shift.to_s if method != :get
          list.each do |action|
            map.named_route("#{name_prefix}#{action}_#{entity}", "#{member_path};#{action}", route_options.merge(:action => action.to_s))
          end
          map.connect(member_path, route_options.merge(:action => primary)) unless primary.blank?
        end

        map.named_route("#{name_prefix}#{entity}", member_path, :action => "show", :require => { :method => :get })
      end
    end

    private

      def requirements_for(method)
        method == :any ?
          {} :
          { :require => { :method => method } }
      end
  end
end
