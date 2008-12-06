require 'simply_restful'

# Wheeee! Monkey-patching!

ActionController::AbstractRequest.send :include, SimplyRestful::Request
ActionController::Routing::RouteSet.send :include, SimplyRestful::Routes
