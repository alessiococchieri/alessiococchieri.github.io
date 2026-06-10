# frozen_string_literal: true

# al_folio_cv's AssetsGenerator (priority :low) unconditionally re-registers
# its own bundled assets/css/al-folio-cv.css as a static file on every build.
# Because it runs after the site has already picked up this repo's local
# override at the same path, its copy gets written to _site last and
# clobbers our local edits (the date-badge/iconlocation overrides).
#
# This site-local generator runs after it (priority :lowest) and drops any
# gem-provided static file whose path is shadowed by a local file in this
# repo, restoring normal "local override wins" precedence.
class LocalAssetOverrideFix < Jekyll::Generator
  safe true
  priority :lowest

  def generate(site)
    return unless defined?(AlFolioCv::PluginStaticFile)

    site.static_files.reject! do |static_file|
      static_file.is_a?(AlFolioCv::PluginStaticFile) &&
        File.exist?(File.join(site.source, static_file.relative_path))
    end
  end
end
