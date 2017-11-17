module Wiselinks
  module Request
    def self.included(base)
      base.send :alias_method, :referer_without_wiselinks, :referer
      base.send :alias_method, :referer, :referer_with_wiselinks
      base.send :alias_method, :referrer_without_wiselinks, :referrer
      base.send :alias_method, :referrer, :referrer_with_wiselinks
    end

    def referer_with_wiselinks
      self.headers['X-Wiselinks-Referer'] || self.referer_without_wiselinks
    end

    def referrer_with_wiselinks
      self.referer_with_wiselinks
    end

    def wiselinks?
      self.headers['X-Wiselinks'].present?
    end

    def wiselinks_template?
      self.wiselinks? && self.headers['X-Wiselinks'] != 'partial'
    end

    def wiselinks_partial?
      self.wiselinks? && self.headers['X-Wiselinks'] == 'partial'
    end
  end
end

