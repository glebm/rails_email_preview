# simply require this file to enable Comfortable Mexican Sofa integration
# read more https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa

module RailsEmailPreview
  module Integrations
    module ComfortableMexicanSofa
      # returns CMS identifier for the current email
      # ModerationMailer#approve -> "moderation_mailer-approve"
      def cms_email_id
        mailer = respond_to?(:controller) ? controller : self
        "#{mailer.class.name.underscore}-#{action_name}"
      end

      # Will return snippet title interpolated with passed variables
      #   E.g, for snippet with title "Welcome, %{name}!"
      #      cms_email_subject(name: "Alice") #=> "Welcome, Alice!"
      def cms_email_subject(interpolation = {})
        snippet_id = "email-#{cms_email_id}"
        [I18n.locale, I18n.default_locale].compact.each do |locale|
          site = Cms::Site.find_by_locale(locale)
          snippet = site.snippets.find_by_identifier(snippet_id)
          next unless snippet.try(:content).present?

          # interpolate even if keys/values are missing
          title = snippet.label.to_s
          interpolation = interpolation.stringify_keys
          # set all missing values to ''
          title.scan(/%{([^}]+)}/) { |m| interpolation[m[0]] ||= ''}
          # remove all missing keys
          subject = title % interpolation.symbolize_keys.delete_if { |k, v| title !~ /%{#{k}}/ }

          return subject if subject.present?
        end
        '(no subject)'
      end

      # Will return snippet content, passing through Kramdown
      # Will also render an "✎ Edit text" link if used from
      def cms_email_snippet(snippet_id = self.cms_email_id)
        snippet_id = "email-#{snippet_id}"
        site       = Cms::Site.find_by_locale(I18n.locale)

        # Fallback default locale: (# prefill)
        unless (content = cms_snippet_content(snippet_id, site).presence)
          default_site     = Cms::Site.find_by_locale(I18n.default_locale)
          fallback_content = cms_snippet_content(snippet_id, default_site).presence
        end
        result = (content || fallback_content).to_s

        # If rendering in preview from admin, add edit/create lnk
        if caller.grep(/emails_controller/).present?
          snippet = site.snippets.find_by_identifier(snippet_id)


          cms_path = if snippet
                       unless content
                         fallback_snippet = default_site.snippets.find_by_identifier(snippet_id)
                         prefill_from_default = {label: fallback_snippet.label, content: fallback_snippet.content}
                       end
                       edit_cms_admin_site_snippet_path(site_id: site.id, id: snippet.id,
                                                        snippet: prefill_from_default || nil)
                     else
                       new_cms_admin_site_snippet_path(site_id: site.id, snippet: {
                           label:        "#{snippet_id.sub('-', ' / ').humanize}",
                           identifier:   snippet_id,
                           category_ids: [site.categories.find_by_label('email').try(:id)]
                       })
                     end

          result += cms_edit_email_snippet_link(cms_path)
        end
        result
      end

      def cms_edit_email_snippet_link(path)
        link_to(RailsEmailPreview.edit_link_text, path, style: RailsEmailPreview.edit_link_style, 'onClick' => '')
      end
    end
  end
end

ActionMailer::Base.module_eval do
  include ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
  helper ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
end

require 'comfortable_mexican_sofa'
ComfortableMexicanSofa::ViewHooks.add :header, 'integrations/cms/customize_cms_for_rails_email_preview'
