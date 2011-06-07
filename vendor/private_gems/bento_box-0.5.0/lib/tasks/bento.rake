namespace :bento do  
  desc "Sync extra files from bento"  
  namespace :skin do
    task :install do  
      system "rsync -ruv #{File.dirname(__FILE__)}/../public ."  
    end
  end
end 