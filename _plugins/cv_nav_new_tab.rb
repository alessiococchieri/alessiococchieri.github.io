# frozen_string_literal: true

# The navbar "CV" entry comes from _pages/cv.html, whose /cv/ URL only redirects
# to the PDF. The navbar markup is owned by al_folio_core, so instead of
# overriding the header include, rewrite that one link after rendering: point it
# straight at the PDF and open it in a new tab so visitors stay on the site.
module CvNavNewTab
  CV_PDF = "/assets/pdf/Personal_CV_Alessio_Cocchieri.pdf"

  def self.rewrite(doc)
    return unless doc.output_ext == ".html" && doc.output&.include?("nav-link")

    baseurl = doc.site.config["baseurl"].to_s
    doc.output = doc.output.gsub(%(<a class="nav-link" href="#{baseurl}/cv/">)) do
      %(<a class="nav-link" href="#{baseurl}#{CV_PDF}" target="_blank" rel="noopener">)
    end
  end
end

Jekyll::Hooks.register [:pages, :documents], :post_render do |doc|
  CvNavNewTab.rewrite(doc)
end
