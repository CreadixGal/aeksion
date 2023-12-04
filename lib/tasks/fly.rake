# commands used to deploy a Rails application
namespace :fly do
  # RESTORE db step
  #  - changes to the filesystem made here DO get deployed
  #  - full access to secrets, databases
  #  - failures here prevent deployment
  #  - this task is run after build task and only if it is the necessary
  task restoredb: 'db:reset'

  # BUILD step:
  #  - changes to the filesystem made here DO get deployed
  #  - NO access to secrets, volumes, databases
  #  - Failures here prevent deployment
  task build: 'assets:precompile'

  # RELEASE step:
  #  - changes to the filesystem made here are DISCARDED
  #  - full access to secrets, databases
  #  - failures here prevent deployment
  task release: 'db:migrate'

  task reset: 'db:migrate:reset'

  task seed: 'db:seed'

  # SERVER step:
  #  - changes to the filesystem made here are deployed
  #  - full access to secrets, databases
  #  - failures here result in VM being stated, shutdown, and rolled back
  #    to last successful deploy (if any).
  task server: :swapfile do
    sh 'bin/rails server'
  end

  # optional SWAPFILE task:
  #  - adjust fallocate size as needed
  #  - performance critical applications should scale memory to the
  #    point where swap is rarely used.  'fly scale help' for details.
  #  - disable by removing dependency on the :server task, thus:
  #        task :server do
  task swapfile: :environment do
    sh 'fallocate -l 512M /swapfile'
    sh 'chmod 0600 /swapfile'
    sh 'mkswap /swapfile'
    sh 'echo 10 > /proc/sys/vm/swappiness'
    sh 'swapon /swapfile'
  end

  # optional SSH task:
  #
  # - this task is not run as part of the deployment process
  # - it is provided as a convenience for debugging
  # - it is not necessary to deploy this task
  task ssh: :environment do
    sh 'fly ssh console --pty -C "sudo -iu rails"'
  end

  # optional CONSOLE task:
  #
  # - this task is not run as part of the deployment process
  #
  task console: :enivronment do
    sh 'fly ssh console --pty -C "/rails/bin/rails console"'
  end

  task dbconsole: :envionment do
    sh 'fly ssh console --pty -C "/rails/bin/rails dbconsole"'
  end
end
