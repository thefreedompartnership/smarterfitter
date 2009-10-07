set :user, 'rails'

set :deploy_via, :remote_cache
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :application, "smarterfitter"
set :repository,  "git@github.com:thefreedompartnership/#{application}.git"
set :scm, "git"

role :app, "dave.thefreedompartnership.com"
role :web, "dave.thefreedompartnership.com"
role :db,  "dave.thefreedompartnership.com", :primary => true

namespace :deploy do
  namespace :link do
    desc "Link the blog into the current directory."
    task :blog, :roles => :app do
      run "(cd #{release_path}/public && ln -s /u/apps/blog_smarterfitter/blog)"
    end
  end

  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end

after 'deploy:symlink', 'deploy:link:blog'
