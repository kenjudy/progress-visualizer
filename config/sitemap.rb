require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.progress-visualizer.com'
SitemapGenerator::Sitemap.create do
  add about_path, :changefreq => 'weekly'
  add help_index_path, :changefreq => 'weekly'
  add contact_form_new_path, :changefreq => 'weekly'
  add new_user_registration_path, :changefreq => 'weekly'
  add new_user_session_path, :changefreq => 'weekly'

  add 'public/demo/burn-up.html', :changefreq => 'weekly'
  add 'public/demo/done-stories.html', :changefreq => 'weekly'
  add 'public/demo/long-term-trend.html', :changefreq => 'weekly'
  add 'public/demo/todo-stories.html', :changefreq => 'weekly'
  add 'public/demo/performance-summary.html', :changefreq => 'weekly'
  add 'public/demo/yesterdays-weather.html', :changefreq => 'weekly'

  add privacy_policy_path, :changefreq => 'weekly'
  add terms_and_conditions_path, :changefreq => 'weekly'
end
#SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
