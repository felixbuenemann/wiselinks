module Wiselinks
  module ControllerMethods

    def self.included(base)
      base.helper_method :wiselinks_title
      base.helper_method :wiselinks_description
      base.helper_method :wiselinks_canonical
      base.helper_method :wiselinks_robots
      base.helper_method :wiselinks_link_rel_prev
      base.helper_method :wiselinks_link_rel_next
      if base.respond_to? :before_action
        base.before_action :set_wiselinks_url
      else
        base.before_filter :set_wiselinks_url
      end
    end

  protected

    def wiselinks_layout
      'wiselinks'
    end

    def wiselinks_title(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("title: #{value}")
        self.response.headers['X-Wiselinks-Title'] = uri_encode(value)
      end
    end

    def wiselinks_description(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("description: #{value}")
        self.response.headers['X-Wiselinks-Description'] = uri_encode(value)
      end
    end

    def wiselinks_canonical(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("canonical: #{value}")
        self.response.headers['X-Wiselinks-Canonical'] = uri_encode(value)
      end
    end

    def wiselinks_robots(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("robots: #{value}")
        self.response.headers['X-Wiselinks-Robots'] = uri_encode(value)
      end
    end

    def wiselinks_link_rel_prev(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("link_rel_prev: #{value}")
        self.response.headers['X-Wiselinks-LinkRelPrev'] = uri_encode(value)
      end
    end

    def wiselinks_link_rel_next(value)
      if self.request.wiselinks? && value.present?
        Wiselinks.log("link_rel_next: #{value}")
        self.response.headers['X-Wiselinks-LinkRelNext'] = uri_encode(value)
      end
    end

    def set_wiselinks_url
      # self.response.headers['X-Wiselinks-Url'] = request.env['REQUEST_URI'] if self.request.wiselinks?
      self.response.headers['X-Wiselinks-Url'] = request.url if self.request.wiselinks?
    end

  private

    def uri_encode(value)
      URI::DEFAULT_PARSER.escape(value)
    end
  end
end
