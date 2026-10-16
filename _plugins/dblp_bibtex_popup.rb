# frozen_string_literal: true

# Shows the official DBLP BibTeX, verbatim, in each publication's "Bib" popup.
#
# _bibliography/papers.bib drives what the page displays (shortened venue
# names, thumbnails, links), but jekyll-scholar re-serializes entries when it
# renders the popup (e.g. "Alessio Cocchieri" becomes "Cocchieri, Alessio").
# _bibliography/dblp.bib is the unmodified export of
# https://dblp.org/pid/371/9197.bib; when a papers.bib entry has the same key,
# the popup shows that DBLP text exactly. Entries not on DBLP fall back to the
# al_folio_core filter.
module DblpBibtexPopup
  DBLP_FILE = File.join("_bibliography", "dblp.bib")

  def self.entries(site)
    path = File.join(site.source, DBLP_FILE)
    return {} unless File.exist?(path)

    mtime = File.mtime(path)
    return @entries if @entries && @mtime == mtime

    @mtime = mtime
    @entries = File.read(path).split(/^(?=@)/).each_with_object({}) do |chunk, map|
      key = chunk[/\A@\w+\{([^,\s]+),/, 1]
      map[key] = chunk.strip if key
    end
  end

  def hideCustomBibtex(input)
    key = input.to_s[/@\w+\{([^,\s]+),/, 1]
    DblpBibtexPopup.entries(@context.registers[:site])[key] || super
  end
end

# al_folio_core registers its filter after site plugins load, so registering a
# second filter would lose; prepend onto the gem's module once it exists.
Jekyll::Hooks.register :site, :after_init do
  target = AlFolioCore::Filters::HideCustomBibtex
  target.prepend(DblpBibtexPopup) unless target.ancestors.include?(DblpBibtexPopup)
end
