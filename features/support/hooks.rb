Before("@selenium") do 
    Capybara.current_driver = :selenium
end