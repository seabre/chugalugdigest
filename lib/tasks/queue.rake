namespace :queue do
  task :dequeue => :environment do
    ListDigest.pop_and_run
    sleep 2
    ListDigest.pop_and_run_processing
    sleep 2
  end
end
