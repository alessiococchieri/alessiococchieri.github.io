# frozen_string_literal: true

require "date"

# Adapts the rendered /cv/ page to match the user's PDF CV without changing
# the underlying _data/cv.yml fields that the RenderCV PDF pipeline
# (.github/workflows/render-cv.yml) validates and consumes:
#
# - Experience date badges show "Month YYYY - Month YYYY" instead of
#   "YYYY - YYYY", derived from the existing start_date/end_date values.
# - Publication date badges show venue + year (e.g. "ACL 2026") instead of
#   just the year, derived from the existing journal field.
# - The "Publications" card title is relabeled "Selected Publications" while
#   the "Publications" data key is left untouched, since al_folio_cv's
#   section router only recognizes that exact key.
module CvLocalOverrides
  def self.format_month_year(value)
    return "Present" if value.nil? || value.to_s.strip.casecmp("present").zero?

    Date.strptime(value.to_s, "%Y-%m").strftime("%B %Y")
  rescue ArgumentError
    value.to_s
  end

  def self.venue_and_year(entry)
    journal = entry["journal"]
    return entry["date"] if journal.nil?

    journal.to_s.sub(/\s*\(.*\)\s*\z/, "")
  end
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  next unless page.data["cv_format"] == "rendercv"

  sections = page.site.data.dig("cv", "cv", "sections")
  next unless sections

  %w[Experience Volunteer].each do |key|
    next unless sections[key]

    sections[key] = sections[key].map do |entry|
      next entry unless entry["start_date"]

      entry = entry.dup
      entry["start_date"] = CvLocalOverrides.format_month_year(entry["start_date"])
      entry["end_date"] = CvLocalOverrides.format_month_year(entry["end_date"])
      entry
    end
  end

  next unless sections["Publications"]

  sections["Publications"] = sections["Publications"].map do |entry|
    entry = entry.dup
    entry["date"] = CvLocalOverrides.venue_and_year(entry)
    entry
  end
end

Jekyll::Hooks.register :pages, :post_render do |page|
  next unless page.data["cv_format"] == "rendercv"

  page.output = page.output.sub(
    '<h3 class="card-title font-weight-medium">Publications</h3>',
    '<h3 class="card-title font-weight-medium">Selected Publications</h3>'
  )
end
