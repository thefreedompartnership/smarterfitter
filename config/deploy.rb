require 'mongrel_cluster/recipes'

set :application, "smarterfitter"
set :repository,  "svn+ssh://panic.gatezero.org/Users/tim/svn/#{application}/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/sf/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

role :app, "hosted.smarterfitter.com"
role :web, "hosted.smarterfitter.com"
role :db,  "hosted.smarterfitter.com", :primary => true

