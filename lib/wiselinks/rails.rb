module Wiselinks
  module Rails
    class Engine < ::Rails::Engine
      initializer 'wiselinks.register_logger' do
        Wiselinks.options[:logger] = ::Rails.logger
      end

      initializer "wiselinks.register_extensions"  do
        ActionDispatch::Request.send :include, Request
        ActionController::Base.send :include, ControllerMethods
        ActionController::Base.send :include, Rendering
        ActionView::Base.send :include, Helpers
      end

      initializer "wiselinks.register_assets_digest"  do
        if ::Rails.application.config.assets.digest
          if ::Rails.application.config.assets.digests.present?
            Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(::Rails.application.config.assets.digests.values.join)
          elsif ::Rails.application.config.assets.manifest.present? && File.exist?(::Rails.application.config.assets.manifest)
            Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(File.read(::Rails.application.config.assets.manifest))
          elsif manifest = ::Rails.root.join('public', 'assets').glob('.sprockets-manifest-*.json').map(&:mtime).last
            Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(manifest.read)
          elsif manifest = ::Rails.root.join('public', 'assets', '.manifest.json') and manifest.exist?
            Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(manifest.read)
          end
        end
      end
    end
  end
end
