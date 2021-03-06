module SmartAssets
  class Railtie < Rails::Railtie

    config.smart_assets = ActiveSupport::OrderedOptions.new
    config.smart_assets.cache_control = 'public,max-age=60'
    config.smart_assets.prefix = nil
    config.smart_assets.serve_non_digest_assets = !Rails.env.development?

    initializer 'smart_assets.configure' do |app|
      if app.config.smart_assets.serve_non_digest_assets
        prefix = app.config.smart_assets.prefix || app.config.assets.prefix || '/assets'
        cc = app.config.smart_assets.cache_control

        serve_static = app.config.respond_to?(:serve_static_files) ? app.config.serve_static_files : app.config.serve_static_assets

        if serve_static || app.config.assets.compile
          app.middleware.insert_after(::Rack::Sendfile, SmartAssets::Rack, prefix, cc)
        end
      end
    end

  end
end
