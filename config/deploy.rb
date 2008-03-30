require 'mongrel_cluster/recipes'

ssh_options[:forward_agent] = true
ssh_options[:port] = 1022

set :application, "smarterfitter"
set :repository,  "svn+ssh://panic.gatezero.org/Users/tim/svn/#{application}/trunk"

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

role :app, "hosted.smarterfitter.com"
role :web, "hosted.smarterfitter.com"
role :db,  "hosted.smarterfitter.com", :primary => true

namespace :deploy do
  namespace :link do
    desc "Link the forums and blog into the current directory."
    task :blog, :roles => :app do
      run "(cd #{release_path}/public && ln -s /u/apps/blog_smarterfitter/blog)"
      run "(cd #{release_path}/public && ln -s /u/apps/forum_smarterfitter/forums)"
    end
  end
end

after 'deploy:symlink', 'deploy:link:blog'
