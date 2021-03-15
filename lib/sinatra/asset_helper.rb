require 'json'

module Sinatra
  module AssetHelper
    MANIFEST = "#{Carpanta.root}/app/public/#{ENV.fetch('PUBLIC_PATH')}/manifest.json".freeze
    class AssetNotFound < StandardError ; end

    def javascript_tag(source)
      src = manifest.fetch("#{source}.js") { raise AssetNotFound }
      "<script src=\"#{src}\"></script>"
    end

    def stylesheet_tag(source)
      href = manifest.fetch("#{source}.css") { raise AssetNotFound }
      "<link rel=\"stylesheet\" href=\"#{href}\"></link>"
    end

    private

    def manifest
      JSON.parse(File.read(MANIFEST))
    end
  end
end
