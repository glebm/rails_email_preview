# coding: utf-8
# simply require this file to enable Comfortable Mexican Sofa integration
# read more https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa

module RailsEmailPreview
  module Integrations
    module ComfortableMexicanSofa
      # returns CMS identifier for the current email
      # ModerationMailer#approve -> "moderation_mailer-approve"
      def cms_email_id
        mailer = respond_to?(:controller) ? controller : self
        [mailer.class.name.underscore, action_name, cms_content_type_string].compact.join('-')
      end

      # Will return snippet title interpolated with passed variables
      #   E.g, for snippet with title "Welcome, %{name}!"
      #      cms_email_subject(name: "Alice") #=> "Welcome, Alice!"
      def cms_email_subject(interpolation = {})
        snippet_id = "email-#{cms_email_id}"
        return '(no subject)' unless Cms::Snippet.where(identifier: snippet_id).exists?
        [I18n.locale, I18n.default_locale].compact.each do |locale|
          site    = Cms::Site.find_by_locale(locale.to_s)
          snippet = site.snippets.find_by_identifier(snippet_id)
          next unless snippet.try(:content).present?

          # interpolate even if keys/values are missing
          title         = snippet.label.to_s
          interpolation = interpolation.stringify_keys
          # set all missing values to ''
          title.scan(/%{([^}]+)}/) { |m| interpolation[m[0]] ||= '' }
          # remove all missing keys
          subject = title % interpolation.symbolize_keys.delete_if { |k, v| title !~ /%{#{k}}/ }

          return subject if subject.present?
        end
        '(no subject)'
      end

      # show edit link?
      def cms_email_edit_link?
        RequestStore.store[:rep_edit_links]
      end

      def cms_content_type_string(content_type = formats.first)
        if content_type == :html
          nil
        else
          content_type
        end
      end

      # Will return snippet content, passing through Kramdown
      # Will also render an "✎ Edit text" link if used from
      def cms_email_snippet(snippet_id = self.cms_email_id)
        snippet_id = "email-#{snippet_id}"
        site       = Cms::Site.find_by_locale(I18n.locale.to_s)
        if Cms::Snippet.where(identifier: snippet_id).exists?
          # Fallback default locale: (# prefill)
          unless (content = cms_snippet_content(snippet_id, site).presence)
            default_site     = Cms::Site.find_by_locale(I18n.default_locale.to_s)
            fallback_content = cms_snippet_content(snippet_id, default_site).presence
          end
          result = (content || fallback_content).to_s
        else
          result = ''
        end

        # If rendering in preview from admin, add edit/create lnk
        if cms_email_edit_link?
          snippet = site.snippets.find_by_identifier(snippet_id)

          route_name = respond_to?(:new_cms_admin_site_snippet_path) ? :cms_admin_site_snippet : :admin_cms_site_snippet


          cms_path = if snippet
                       unless content
                         fallback_snippet     = default_site.snippets.find_by_identifier(snippet_id)
                         prefill_from_default = {label: fallback_snippet.label, content: fallback_snippet.content}
                       end
                       send :"edit_#{route_name}_path", site_id: site.id, id: snippet.id, snippet: prefill_from_default || nil
                     else
                       send :"new_#{route_name}_path", site_id: site.id,
                            snippet:                            {
                                label:        "#{snippet_id.sub('-', ' / ').humanize}",
                                identifier:   snippet_id,
                                category_ids: [site.categories.find_by_label('email').try(:id)]
                            }
                     end

          result = safe_join ["<table class='rep-edit-link'><tr><td>".html_safe, cms_edit_email_snippet_link(cms_path),
                              "</td></tr></table>".html_safe, "\n\n", result]
        end
        result
      end

      def cms_edit_email_snippet_link(path)
        link_to(RailsEmailPreview.edit_link_text, path, style: RailsEmailPreview.edit_link_style.html_safe, 'onClick' => '')
      end

      def self.rep_email_params_from_snippet(snippet)
        id_prefix = 'email-'
        return unless snippet && snippet.identifier && snippet.identifier.starts_with?(id_prefix)
        mailer_cl, act, part_type = snippet.identifier[id_prefix.length..-1].split('-')

        part_type = part_type == 'text' ? 'text/plain' : part_type
        mailer_cl += '_preview'
        { mail_class: mailer_cl,
          mail_action: act,
          email_locale: snippet.site.locale,
          part_type: part_type }
      end
    end
  end
end

ActionMailer::Base.module_eval do
  include ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
  helper ::RailsEmailPreview::Integrations::ComfortableMexicanSofa
end

require 'comfortable_mexican_sofa'
ComfortableMexicanSofa::ViewHooks.add :navigation, 'integrations/cms/customize_cms_for_rails_email_preview'
