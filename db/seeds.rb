# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
BentoUser.create({:username => 'admin', :password => 'password', :email => 'admin@local.host'})
main_nav      = Nav.new({:name => 'Navigation'})
main_nav.save!
portfolio_nav = SubNav.new({:name => 'Portfolio'})
portfolio_nav.save!
contact       = Sub.new({:name => 'Contact', :type => 'contact'})
contact.save!

portfolio_nav_items = [{:name => 'Portfolio Places', :text => 'Places', 
                                      :page_type => 'filter', :nav_filter_tag => 'places',
                                      :url_id => '/portfolio/places', :sort => 12},
                                      {:name => 'Portfolio People', :text => 'People', 
                                      :page_type => 'filter', :nav_filter_tag => 'people',
                                      :url_id => '/portfolio/people', :sort => 11},
                                      {:name => 'Portfolio Current', :text => 'Current', 
                                      :page_type => 'filter', :nav_filter_tag => 'current',
                                      :url_id => '/portfolio/current', :sort => 10},
                                      {:name => 'Portfolio Motion', :text => 'Motion', 
                                      :page_type => 'filter', :nav_filter_tag => 'motion',
                                      :url_id => '/portfolio/motion', :sort => 13},
                                      {:name => 'Portfolio All', :text => 'View All', 
                                      :page_type => 'filter', :nav_filter_tag => 'all',
                                      :url_id => '/portfolio/all', :sort => 14}]
                                      
portfolio_nav_items.map! { |ni|  record = NavItem.create(ni); record.id }
portfolio_nav.nav_item_ids = portfolio_nav_items
portfolio_nav.save!

main_nav_items      = [{:name => 'Reel', :text => 'Film Reels', 
                                      :page_type => 'portfolio',
                                      :url_id => '/films', :sort => 2},
                                      {:name => 'Contact', :text => 'Contact', 
                                      :sub => contact,
                                      :url_id => '/contact', :sort => 6},
                                      {:name => 'Portfolio', :text => 'Portfolio', 
                                      :page_type => 'portfolio', :is_default => true,
                                      :sub_id => portfolio_nav.id,
                                      :url_id => '/portfolio', :sort => 1},
                                      {:name => 'Blog', :text => 'Blog', 
                                      :page_type => 'external',
                                      :url_id => 'http://blog.kielphoto.com/', :sort => 5},
                                      {:name => 'Home', :text => 'Home', :is_logo => true,
                                      :url_id => '/', :sort => 0},
                                      {:name => 'Tear Sheets', :text => 'Campaigns', 
                                      :page_type => 'portfolio',
                                      :url_id => '/tear_sheets', :sort => 4},
                                      {:name => 'Stock', :text => 'Stock', 
                                      :page_type => 'stock',
                                      :url_id => '/stock', :sort => 3}]

main_nav_items.map! { |ni| puts ni[:name];  record = NavItem.create(ni); record.id }
main_nav.nav_item_ids = main_nav_items
main_nav.save!
categories = [{:name => 'Current',:text_id => 'current' ,:rank => 1},
                              {:name => 'Default Portfolio',:text_id => 'default_profile' ,:rank => 1},
                              {:name => 'People',:text_id => 'people' ,:rank => 2}]
categories.map! {|c| record = Category.create(c); record.id }
main_portfolio       = Portfolio.create({:name => 'Main Photo Portfolio', :portfolio_item_ids => []})
portfolio_nav_item   = NavItem.find('portfolio')
portfolio_nav_item.service_id = main_portfolio.id
portfolio_nav_item.save!

ConfigSetting.create({:default_nav => main_nav.id, :background_image => '/images/greenish_sky_bg_1.jpg', :filters => 'all, current, motion, people, places'})

