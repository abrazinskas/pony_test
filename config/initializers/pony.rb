

# #pony
if Rails.env.test?
  Pony.options={
      :from=>"Arthur <#{ENV['FROM_EMAIL']}>",
  }
end


# prod and dev were omitted

